package api

import (
	"context"
	"embed"
	"fmt"
	"html/template"
	"math/rand"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/harshag121/FirePaste/internal/store"
	"github.com/prometheus/client_golang/prometheus"
)

//go:embed static/*.html
var content embed.FS

type Handler struct {
	store   *store.Store
	tmpl    *template.Template
	baseURL string
	
	// Metrics
	pastesCreated prometheus.Counter
	pastesViewed  prometheus.Counter
}

func NewHandler(s *store.Store, baseURL string, reg prometheus.Registerer) *Handler {
	t, _ := template.ParseFS(content, "static/*.html")
	
	h := &Handler{
		store:   s,
		tmpl:    t,
		baseURL: baseURL,
		pastesCreated: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "firepaste_pastes_created_total",
			Help: "Total number of pastes created",
		}),
		pastesViewed: prometheus.NewCounter(prometheus.CounterOpts{
			Name: "firepaste_pastes_viewed_total",
			Help: "Total number of pastes viewed",
		}),
	}
	
	if reg != nil {
		reg.MustRegister(h.pastesCreated)
		reg.MustRegister(h.pastesViewed)
	}
	
	return h
}

func (h *Handler) RegisterRoutes(r chi.Router) {
	r.Get("/", h.HandleIndex)
	r.Post("/paste", h.HandleCreatePaste)
	r.Get("/{id}", h.HandleGetPaste)
}

func (h *Handler) HandleIndex(w http.ResponseWriter, r *http.Request) {
	h.tmpl.ExecuteTemplate(w, "index.html", nil)
}

type CreatePasteRequest struct {
	Content string `json:"content"`
	TTL     string `json:"ttl"` // e.g., "10m", "1h"
}

func (h *Handler) HandleCreatePaste(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodPost {
		err := r.ParseForm()
		if err != nil {
			http.Error(w, "Bad Request", http.StatusBadRequest)
			return
		}
		
		content := r.FormValue("content")
		ttlStr := r.FormValue("ttl")
		burn := r.FormValue("burn") == "on"

		if content == "" {
			http.Error(w, "Content required", http.StatusBadRequest)
			return
		}

		ttl, err := time.ParseDuration(ttlStr)
		if err != nil {
			ttl = 24 * time.Hour // Default
		}
		
		id := generateID(6)
		
		// Save paste with burn flag
		err = h.store.SavePaste(r.Context(), id, content, ttl, burn)
		if err != nil {
			http.Error(w, "Internal Error", http.StatusInternalServerError)
			return
		}
		
		h.pastesCreated.Inc()

		// Return simple view or JSON depending on Accept header?
		// For browser form, redirect to view
		http.Redirect(w, r, fmt.Sprintf("/%s", id), http.StatusFound)
		return
	}
}

func (h *Handler) HandleGetPaste(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	
	// Check if this paste is set to burn after reading
	burn, err := h.store.IsBurnPaste(r.Context(), id)
	if err != nil && err != store.ErrNotFound {
		http.Error(w, "Internal Error", http.StatusInternalServerError)
		return
	}
	
	content, err := h.store.GetPaste(r.Context(), id)
	if err == store.ErrNotFound {
		http.NotFound(w, r)
		return
	}
	if err != nil {
		http.Error(w, "Internal Error", http.StatusInternalServerError)
		return
	}
	
	h.pastesViewed.Inc()
	
	// If burn-on-read, delete immediately after viewing
	if burn {
		// Delete in background to not slow down response
		go func() {
			ctx := context.Background()
			h.store.DeletePaste(ctx, id)
		}()
	}
	
	h.tmpl.ExecuteTemplate(w, "view.html", map[string]interface{}{
		"Content": content,
		"ID": id,
		"Burned": burn,
	})
}

const customAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

func generateID(n int) string {
	b := make([]byte, n)
	for i := range b {
		b[i] = customAlphabet[rand.Intn(len(customAlphabet))]
	}
	return string(b)
}

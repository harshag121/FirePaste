package api

import (
	"testing"
)

func TestGenerateID(t *testing.T) {
	id := generateID(6)
	if len(id) != 6 {
		t.Errorf("expected length 6, got %d", len(id))
	}

	id2 := generateID(6)
	if id == id2 {
		t.Errorf("expected random UUIDs, got collision: %s", id)
	}
}

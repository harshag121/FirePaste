package store

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/redis/go-redis/v9"
)

var (
	ErrNotFound = errors.New("paste not found")
)

type Store struct {
	client *redis.Client
}

func NewStore(addr string) (*Store, error) {
	client := redis.NewClient(&redis.Options{
		Addr: addr,
	})

	if err := client.Ping(context.Background()).Err(); err != nil {
		return nil, fmt.Errorf("failed to connect to redis: %w", err)
	}

	return &Store{client: client}, nil
}

func (s *Store) SavePaste(ctx context.Context, id string, content string, ttl time.Duration, burn bool) error {
	// Save the paste content
	if err := s.client.Set(ctx, "paste:"+id, content, ttl).Err(); err != nil {
		return err
	}
	
	// If burn-on-read, store metadata flag with same TTL
	if burn {
		return s.client.Set(ctx, "burn:"+id, "1", ttl).Err()
	}
	
	return nil
}

func (s *Store) GetPaste(ctx context.Context, id string) (string, error) {
	val, err := s.client.Get(ctx, "paste:"+id).Result()
	if err == redis.Nil {
		return "", ErrNotFound
	}
	if err != nil {
		return "", err
	}
	return val, nil
}

func (s *Store) DeletePaste(ctx context.Context, id string) error {
	// Delete both paste content and burn flag if exists
	pipe := s.client.Pipeline()
	pipe.Del(ctx, "paste:"+id)
	pipe.Del(ctx, "burn:"+id)
	_, err := pipe.Exec(ctx)
	return err
}

func (s *Store) IsBurnPaste(ctx context.Context, id string) (bool, error) {
	val, err := s.client.Get(ctx, "burn:"+id).Result()
	if err == redis.Nil {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	return val == "1", nil
}

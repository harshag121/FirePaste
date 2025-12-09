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

func (s *Store) SaveCreate(ctx context.Context, id string, content string, ttl time.Duration) error {
	return s.client.Set(ctx, "paste:"+id, content, ttl).Err()
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
	return s.client.Del(ctx, "paste:"+id).Err()
}

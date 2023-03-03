package repository

import (
	"context"
	"errors"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"omerfarukozturk.com/backend/models"
)

type TodoRepositoryDB struct {
	TodoCollection *mongo.Collection
}

type TodoRepository interface {
	Insert(todo models.Todo) (bool, error)
}

func (t TodoRepositoryDB) Insert(todo models.Todo) (bool, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	result, err := t.TodoCollection.InsertOne(ctx, todo)

	if result.InsertedID == nil || err != nil {
		err := errors.New("failed add")
		if err != nil {
			return false, err
		}
	}
	return true, nil
}

func NewTodoRepositoryDb(dbClient *mongo.Collection) TodoRepositoryDB {
	return TodoRepositoryDB{TodoCollection: dbClient}
}

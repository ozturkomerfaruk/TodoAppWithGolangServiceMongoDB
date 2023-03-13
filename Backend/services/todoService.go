package services

import (
	"net/http"

	"go.mongodb.org/mongo-driver/bson/primitive"
	"omerfarukozturk.com/backend/dto"
	"omerfarukozturk.com/backend/models"
	"omerfarukozturk.com/backend/repository"
)

//go:generate mockgen -destination=../mocks/service/mockTodoservice.go -package=services omerfarukozturk.com/backend/services TodoService
type DefaultTodoService struct {
	Repo repository.TodoRepository
}

type TodoService interface {
	TodoInsert(todo models.Todo) (*dto.TodoDTO, error)
	TodoGetAll() ([]models.Todo, error)
	TodoDelete(id primitive.ObjectID) (bool, error)
	TodoDeleteAll() (*dto.TodoDeleteAllDTO, error)
}

func (t DefaultTodoService) TodoInsert(todo models.Todo) (*dto.TodoDTO, error) {
	var res dto.TodoDTO
	if len(todo.Title) <= 2 {
		res.Status = http.StatusInternalServerError
		return &res, nil
	}

	err := t.Repo.Insert(todo)

	if err != nil {
		res.Status = http.StatusInternalServerError
		return &res, err
	}

	res = dto.TodoDTO{
		Status:  http.StatusOK,
		Message: "All todos deleted successfully",
		Todo:    models.Todo{
			ID: todo.ID,
			Title: todo.Title,
			Category: todo.Category,
			Date: todo.Date,
			StartTime: todo.StartTime,
			EndTime: todo.EndTime,
			Content: todo.Content,
		},
	}
	return &res, nil
}

func (t DefaultTodoService) TodoGetAll() ([]models.Todo, error) {
	result, err := t.Repo.GetAll()
	if err != nil {
		return nil, err
	}
	return result, nil
}

func (t DefaultTodoService) TodoDelete(id primitive.ObjectID) (bool, error) {
	result, err := t.Repo.Delete(id)
	if err != nil || !result {
		return false, err
	}
	return true, nil
}

func (t DefaultTodoService) TodoDeleteAll() (*dto.TodoDeleteAllDTO, error) {
	err := t.Repo.DeleteAll()
	if err != nil {
		return nil, err
	}
	return &dto.TodoDeleteAllDTO{
		Status:  http.StatusOK,
		Message: "All todos deleted successfully",
	}, nil
}

func NewTodoService(Repo repository.TodoRepository) DefaultTodoService {
	return DefaultTodoService{Repo: Repo}
}

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
	TodoInsert(todo models.Todo) (*dto.TodoInsertDTO, error)
	TodoGetAll() (*dto.TodoListDTO, error)
	TodoDelete(id primitive.ObjectID) (bool, error)
	TodoDeleteAll() (*dto.TodoDeleteAllDTO, error)
}

func (t DefaultTodoService) TodoInsert(todo models.Todo) (*dto.TodoInsertDTO, error) {
	var res dto.TodoInsertDTO
	if len(todo.Title) <= 2 {
		res.Status = http.StatusInternalServerError
		return &res, nil
	}

	err := t.Repo.Insert(todo)

	if err != nil {
		res.Status = http.StatusInternalServerError
		return &res, err
	}

	res = dto.TodoInsertDTO{
		Status:  http.StatusOK,
		Message: "Created Successfully",
		Todo: models.Todo{
			ID:        todo.ID,
			Title:     todo.Title,
			Category:  todo.Category,
			Date:      todo.Date,
			StartTime: todo.StartTime,
			EndTime:   todo.EndTime,
			Content:   todo.Content,
		},
	}
	return &res, nil
}

func (t DefaultTodoService) TodoGetAll() (*dto.TodoListDTO, error) {
	result, err := t.Repo.GetAll()
	if err != nil {
		return &dto.TodoListDTO{
			Status:  http.StatusInternalServerError,
			Message: err.Error(),
		}, err
	}

	return &dto.TodoListDTO{
		Status:   http.StatusOK,
		TodoList: result,
	}, nil

}

func (t DefaultTodoService) TodoDelete(id primitive.ObjectID) (bool, error) {
	result, err := t.Repo.Delete(id)
	if err != nil || !result {
		return false, err
		//DTO yazılacak
	}
	return true, nil
}

func (t DefaultTodoService) TodoDeleteAll() (*dto.TodoDeleteAllDTO, error) {
	err := t.Repo.DeleteAll()
	if err != nil {
		return &dto.TodoDeleteAllDTO{
			Status:  http.StatusInternalServerError,
			Message: err.Error(),
		}, err
	}
	return &dto.TodoDeleteAllDTO{
		Status:  http.StatusOK,
		Message: "All Deleted Successfully",
	}, nil
}

func NewTodoService(Repo repository.TodoRepository) DefaultTodoService {
	return DefaultTodoService{Repo: Repo}
}

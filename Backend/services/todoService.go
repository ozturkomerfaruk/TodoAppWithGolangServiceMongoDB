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
	TodoInsert(todo models.Todo, userId primitive.ObjectID) (*dto.TodoInsertDTO, error)
	TodoGetAll(userId primitive.ObjectID) (*dto.TodoListDTO, error)
	TodoDelete(id primitive.ObjectID) (*dto.TodoDeleteDTO, error)
	TodoDeleteAll(userId primitive.ObjectID) (*dto.TodoDeleteAllDTO, error)
	TodoDetail(id primitive.ObjectID) (*dto.TodoDetailDTO, error)
	TodoUpdate(update models.Todo) (*dto.TodoUpdateDTO, error)
}

func (t DefaultTodoService) TodoInsert(todo models.Todo, userId primitive.ObjectID) (*dto.TodoInsertDTO, error) {
	var res dto.TodoInsertDTO
	if len(todo.Title) <= 2 {
		res.Status = http.StatusInternalServerError
		return &res, nil
	}

	err := t.Repo.Insert(todo, userId)

	if err != nil {
		res.Status = http.StatusInternalServerError
		return nil, err
	}

	res = dto.TodoInsertDTO{
		Status:  http.StatusOK,
		Message: "Created Successfully",
		Result: models.Todo{
			ID:        todo.ID,
			UserID:    todo.UserID,
			Title:     todo.Title,
			Category:  todo.Category,
			Date:      todo.Date,
			StartTime: todo.StartTime,
			EndTime:   todo.EndTime,
			Content:   todo.Content,
			Progress:  todo.Progress,
		},
	}
	return &res, nil
}

func (t DefaultTodoService) TodoGetAll(userId primitive.ObjectID) (*dto.TodoListDTO, error) {
	result, count, percent, countToday, percentToday, err := t.Repo.GetAll(userId)
	if err != nil {
		return &dto.TodoListDTO{
			Status:  http.StatusInternalServerError,
			Message: err.Error(),
		}, err
	}

	return &dto.TodoListDTO{
		Status:               http.StatusOK,
		Message:              "Listed Successfully",
		Count:                count,
		ProgressPercent:      percent,
		CountToday:           countToday,
		ProgressPercentToday: percentToday,
		Result:               result,
	}, nil

}

func (t DefaultTodoService) TodoDelete(id primitive.ObjectID) (*dto.TodoDeleteDTO, error) {
	err := t.Repo.Delete(id)

	if err != nil {
		return &dto.TodoDeleteDTO{
			Status:  http.StatusInternalServerError,
			Message: err.Error(),
		}, err
	}

	return &dto.TodoDeleteDTO{
		Status:  http.StatusOK,
		Message: "Deleted This Item Successfully",
	}, nil
}

func (t DefaultTodoService) TodoDeleteAll(userId primitive.ObjectID) (*dto.TodoDeleteAllDTO, error) {
	err := t.Repo.DeleteAll(userId)
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

func (t DefaultTodoService) TodoDetail(id primitive.ObjectID) (*dto.TodoDetailDTO, error) {
	result, err := t.Repo.Detail(id)
	if err != nil {
		return &dto.TodoDetailDTO{
			Status:  http.StatusInternalServerError,
			Message: err.Error(),
		}, err
	}

	return &dto.TodoDetailDTO{
		Status:  http.StatusOK,
		Message: "Detail of Model Is Fetched Successfully",
		Result: models.Todo{
			ID:        result.ID,
			Title:     result.Title,
			Category:  result.Category,
			Date:      result.Date,
			StartTime: result.StartTime,
			EndTime:   result.EndTime,
			Content:   result.Content,
			Progress:  result.Progress,
		},
	}, nil
}

func (t DefaultTodoService) TodoUpdate(update models.Todo) (*dto.TodoUpdateDTO, error) {
	var res dto.TodoUpdateDTO

	// Check if the todo item exists
	err := t.Repo.Update(update)
	if err != nil {
		res.Status = http.StatusNotFound
		res.Message = "Todo item not found"
		return nil, err
	}

	return &dto.TodoUpdateDTO{
		Status:  http.StatusOK,
		Message: "Todo Item Updated Successfully",
		Result:  update,
	}, nil
}

func NewTodoService(Repo repository.TodoRepository) DefaultTodoService {
	return DefaultTodoService{Repo: Repo}
}

package services
/*
import (
	"testing"

	"github.com/golang/mock/gomock"
	"github.com/stretchr/testify/assert"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"omerfarukozturk.com/backend/mocks/repository"
	"omerfarukozturk.com/backend/models"
)

var mockRepo *repository.MockTodoRepository
var service TodoService

var FakeData = []models.Todo{
	{primitive.NewObjectID(), "Title 99", "Content 99"},
	{primitive.NewObjectID(), "Title 101", "Content 102"},
	{primitive.NewObjectID(), "Title 105", "Content 105"},
}

func setup(t *testing.T) func() {
	ct := gomock.NewController(t)
	defer ct.Finish()

	mockRepo = repository.NewMockTodoRepository(ct)
	service = NewTodoService(mockRepo)

	return func() {
		service = nil
		defer ct.Finish()
	}
}

func TestDefaultTodoServixe_TodoGetAll(t *testing.T) {
	td := setup(t)
	defer td()

	mockRepo.EXPECT().GetAll().Return(FakeData, nil)
	result, err := service.TodoGetAll()
	
	assert.NotEmpty(t, result)

	if err != nil {
		t.Error(err)
	}
}
*/
package app

/*
import (
	"net/http/httptest"
	"testing"

	"github.com/gofiber/fiber/v2"
	"github.com/golang/mock/gomock"
	"github.com/stretchr/testify/assert"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"omerfarukozturk.com/backend/models"

	services "omerfarukozturk.com/backend/mocks/service"
)

var td TodoHandler
var mockService *services.MockTodoService

func setup(t *testing.T) func() {
	ctrl := gomock.NewController(t)

	mockService = services.NewMockTodoService(ctrl)

	td = TodoHandler{mockService}

	return func() {
		defer ctrl.Finish()
	}
}

func TestTodoHandler_GetAllTodo(t *testing.T) {
	trd := setup(t)
	defer trd()

	router := fiber.New()
	router.Get("/api/todos", td.GetAllTodo)

	var FakeDataForHandler = []models.Todo{
		{primitive.NewObjectID(), "Title 1", "Content 1"},
		{primitive.NewObjectID(), "Title 2", "Content 2"},
	}

	mockService.EXPECT().TodoGetAll().Return(FakeDataForHandler, nil)

	req := httptest.NewRequest("GET", "/api/todos", nil)

	resp, _ := router.Test(req, 1)

	assert.Equal(t, 200, resp.StatusCode)
}

*/

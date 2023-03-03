package app

import (
	"net/http"

	"github.com/gofiber/fiber/v2"
	"omerfarukozturk.com/backend/models"
	"omerfarukozturk.com/backend/services"
)

type TodoHandler struct {
	Service services.TodoService
}

func (h TodoHandler) CreateTodo(c *fiber.Ctx) error {
	var todo models.Todo
	if err := c.BodyParser(&todo); err != nil {
		return c.Status(http.StatusBadRequest).JSON(err.Error())
	}

	result, err := h.Service.TodoInsert(todo)

	if err != nil || result.Status == false {
		return err
	}

	return c.Status(http.StatusCreated).JSON(result)
}

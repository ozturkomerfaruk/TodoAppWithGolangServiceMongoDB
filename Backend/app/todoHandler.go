package app

import (
	"net/http"

	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"omerfarukozturk.com/backend/models"
	"omerfarukozturk.com/backend/services"
)

type TodoHandler struct {
	Service services.TodoService
}

func (h TodoHandler) InsertTodo(c *fiber.Ctx) error {
	var todo models.Todo
	if err := c.BodyParser(&todo); err != nil {
		return c.Status(http.StatusBadRequest).JSON(err.Error())
	}
	todo.ID = primitive.NewObjectID()
	result, err := h.Service.TodoInsert(todo)

	if err != nil {
		return err
	}

	return c.Status(http.StatusCreated).JSON(result)
}

func (h TodoHandler) GetAllTodo(c *fiber.Ctx) error {
	result, err := h.Service.TodoGetAll()

	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(err.Error())
	}
	return c.Status(http.StatusOK).JSON(result)
}

func (h TodoHandler) DeleteTodo(c *fiber.Ctx) error {
	query := c.Params("id")
	cnv, _ := primitive.ObjectIDFromHex(query)

	result, err := h.Service.TodoDelete(cnv)
	if err != nil || !result {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"State": false})
	}
	return c.Status(http.StatusOK).JSON(fiber.Map{"State": true})
}

func (h TodoHandler) DeleteAllTodo(c *fiber.Ctx) error {
	result, err := h.Service.TodoDeleteAll()
	if err != nil || result.Status != 200 {
		return c.Status(http.StatusInternalServerError).JSON(err.Error())
	}
	return c.Status(http.StatusOK).JSON(result)
}

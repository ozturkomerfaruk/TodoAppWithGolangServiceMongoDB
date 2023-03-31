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

func (h *TodoHandler) InsertTodo(c *fiber.Ctx) error {
	var todo models.Todo
	if err := c.BodyParser(&todo); err != nil {
		return c.Status(http.StatusBadRequest).JSON(err.Error())
	}

	userId := c.Locals("userID").(primitive.ObjectID)

	todo.ID = primitive.NewObjectID()
	todo.UserID = userId
	result, err := h.Service.TodoInsert(todo, userId)
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(err.Error())
	}
	return c.Status(http.StatusCreated).JSON(result)
}

func (h *TodoHandler) GetAllTodo(c *fiber.Ctx) error {
	userId := c.Locals("userID").(primitive.ObjectID)
	result, err := h.Service.TodoGetAll(userId)

	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(err.Error())
	}

	return c.Status(http.StatusOK).JSON(result)
}

func (h TodoHandler) DeleteTodo(c *fiber.Ctx) error {
	query := c.Params("id")
	cnv, _ := primitive.ObjectIDFromHex(query)

	result, err := h.Service.TodoDelete(cnv)
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(result)
	}
	return c.Status(http.StatusOK).JSON(result)
}

func (h TodoHandler) DeleteAllTodo(c *fiber.Ctx) error {
	userId := c.Locals("userID").(primitive.ObjectID)
	result, err := h.Service.TodoDeleteAll(userId)
	if err != nil || result.Status != 200 {
		return c.Status(http.StatusInternalServerError).JSON(err.Error())
	}
	return c.Status(http.StatusOK).JSON(result)
}

func (h TodoHandler) DetailTodo(c *fiber.Ctx) error {
	query := c.Params("id")
	cnv, _ := primitive.ObjectIDFromHex(query)

	detail, err := h.Service.TodoDetail(cnv)
	userId := c.Locals("userID").(primitive.ObjectID)
	detail.Result.UserID = userId

	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(detail)
	}
	return c.Status(http.StatusOK).JSON(detail)
}

func (h TodoHandler) UpdateTodo(c *fiber.Ctx) error {
	// Parse request body to Todo struct
	var updateTodo models.Todo
	err := c.BodyParser(&updateTodo)
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(err.Error())
	}

	userId := c.Locals("userID").(primitive.ObjectID)
	updateTodo.UserID = userId

	result, err := h.Service.TodoUpdate(updateTodo)
	if err != nil {
		return err
	}
	return c.Status(http.StatusCreated).JSON(result)
}

package main

import (
	"omerfarukozturk.com/backend/app"
	"omerfarukozturk.com/backend/configs"
	"omerfarukozturk.com/backend/repository"
	"omerfarukozturk.com/backend/services"

	"github.com/gofiber/fiber/v2"
)

func main() {
	appRoute := fiber.New()
	configs.ConnectDB()
	dbClient := configs.GetCollection(configs.DB, "todos")

	TodoRepositoryDB := repository.NewTodoRepositoryDb(dbClient)

	td := app.TodoHandler{Service: services.NewTodoService(TodoRepositoryDB)}

	appRoute.Post("/api/todo", td.CreateTodo)
	appRoute.Listen(":8080")
}

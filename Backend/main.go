package main

import (
	"fmt"

	"github.com/gofiber/fiber/v2"
	"omerfarukozturk.com/backend/app"
	"omerfarukozturk.com/backend/configs"
	"omerfarukozturk.com/backend/repository"
	"omerfarukozturk.com/backend/services"
)

func main() {
	appRoute := fiber.New()
	configs.ConnectDB()
	dbClient, err := configs.CreateCollection(configs.DB, "database", "collection")
	if err != nil {
		fmt.Println("Collection Error: ", err)
		return
	}

	TodoRepositoryDB := repository.NewTodoRepositoryDb(dbClient)

	td := app.TodoHandler{Service: services.NewTodoService(TodoRepositoryDB)}

	appRoute.Post("/api/insert", td.InsertTodo)
	appRoute.Get("/api/todoList", td.GetAllTodo)
	appRoute.Delete("/api/todo/delete/:id", td.DeleteTodo)
	appRoute.Delete("/api/todo/deleteAll", td.DeleteAllTodo)

	appRoute.Listen(":8080")
}

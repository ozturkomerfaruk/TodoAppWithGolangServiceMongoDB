package main

import (
	"fmt"
	"log"
	"sync"
	"time"

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
	dbUser, err2 := configs.CreateCollection(configs.DB, "database", "usercollection")

	if err != nil || err2 != nil {
		fmt.Println("Collection Error: ", err)
		return
	}

	// Create a sync.Map for InvalidTokens
	invalidTokens := &sync.Map{}
	tokenLifetime := 5 * time.Minute

	// Create UserRepositoryDB instance and UserHandler with the UserService
	UserRepositoryDB := repository.NewUserRepositoryDb(dbUser, invalidTokens)
	ud := app.UserHandler{Service: services.NewUserService(UserRepositoryDB)}

	// Create TodoRepositoryDB instance and TodoHandler with the TodoService
	TodoRepositoryDB := repository.NewTodoRepositoryDb(dbClient)
	td := app.TodoHandler{Service: services.NewTodoService(TodoRepositoryDB)}

	appRoute.Post("/api/user/register", ud.RegisterHandler)
	appRoute.Post("/api/user/login", ud.LoginHandler)
	appRoute.Post("/api/user/sendResetPasswordEmail", ud.SendResetPasswordEmailHandler)
	appRoute.Post("/api/user/changePasswordDeeplink", ud.ChangePasswordHandlerByMail)
	
	appRoute.Post("/api/user/logout", services.AuthRequired(invalidTokens, tokenLifetime), ud.LogoutHandler)
	appRoute.Get("/api/user/userList", services.AuthRequired(invalidTokens, tokenLifetime), ud.GetAllUser)
	appRoute.Get("/api/user/detail/:id", services.AuthRequired(invalidTokens, tokenLifetime), ud.GetUserDetail)
	appRoute.Post("/api/user/detailByMail", services.AuthRequired(invalidTokens, tokenLifetime), ud.GetUserDetailByMail)
	appRoute.Delete("/api/user/delete/:id", services.AuthRequired(invalidTokens, tokenLifetime), ud.DeleteUser)
	appRoute.Delete("/api/user/deleteAll", services.AuthRequired(invalidTokens, tokenLifetime), ud.DeleteAllUser)
	appRoute.Put("/api/user/update", services.AuthRequired(invalidTokens, tokenLifetime), ud.UpdateUser)
	appRoute.Put("/api/user/changePassword", services.AuthRequired(invalidTokens, tokenLifetime), ud.ChangePasswordHandler)


	appRoute.Post("/api/todo/insert", services.AuthRequired(invalidTokens, tokenLifetime), td.InsertTodo)
	appRoute.Get("/api/todo/todoList", services.AuthRequired(invalidTokens, tokenLifetime), td.GetAllTodo)
	appRoute.Delete("/api/todo/delete/:id", services.AuthRequired(invalidTokens, tokenLifetime), td.DeleteTodo)
	appRoute.Delete("/api/todo/deleteAll", services.AuthRequired(invalidTokens, tokenLifetime), td.DeleteAllTodo)
	appRoute.Get("/api/todo/detail/:id", services.AuthRequired(invalidTokens, tokenLifetime), td.DetailTodo)
	appRoute.Put("/api/todo/update", services.AuthRequired(invalidTokens, tokenLifetime), td.UpdateTodo)

	err = appRoute.Listen(":8080")
	if err != nil {
		log.Fatal(err)
	}

}

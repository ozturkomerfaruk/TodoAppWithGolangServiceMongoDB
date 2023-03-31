package main

// Bu dosyada token oluşturma ve o token ile servis işlemlerinin yapılmasına dair örnek bir proje yer almaktadır.

import (
	"fmt"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/logger"
	jwtware "github.com/gofiber/jwt/v3"
	"github.com/golang-jwt/jwt/v4"
)

const jwtSecret = "asecret"

func authRequired() fiber.Handler {
	return jwtware.New(jwtware.Config{
		SigningKey: []byte(jwtSecret),
		ErrorHandler: func(ctx *fiber.Ctx, err error) error {
			return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"error": "Unauthorized",
			})
		},
	})
}

func main() {
	app := fiber.New()

	app.Use(logger.New())

	app.Get("/", authRequired(), func(ctx *fiber.Ctx) error {
		user := ctx.Locals("user").(*jwt.Token)
		claims := user.Claims.(jwt.MapClaims)
		id := claims["sub"].(string)

		return ctx.SendString(fmt.Sprintf("Hello user with id: %s", id))
	})
	app.Post("/login", login)

	err := app.Listen(":3000")
	if err != nil {
		fmt.Println("aksdjaklş")
	}
}

func login(ctx *fiber.Ctx) error {
	type request struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}

	var body request
	err := ctx.BodyParser(&body)

	if err != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cannot parse json",
		})
	}

	if body.Email != "omer@gmail.com" || body.Password != "omer123" {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": "invalid email or password",
		})
	}

	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["sub"] = "1"
	claims["exp"] = time.Now().Add(time.Hour * 24 * 7).Unix()

	s, err := token.SignedString([]byte(jwtSecret))
	if err != nil {
		return ctx.SendStatus(fiber.StatusInternalServerError)
	}

	return ctx.Status(fiber.StatusOK).JSON(fiber.Map{
		"token": s,
		"user": struct {
			Id    int    `json:"id"`
			Email string `json:"email"`
		}{
			Id:    1,
			Email: "omer@gmail.com",
		},
	})
}

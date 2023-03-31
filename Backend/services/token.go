package services

import (
	"sync"
	"time"

	"github.com/gofiber/fiber/v2"
	jwtware "github.com/gofiber/jwt/v3"
	"github.com/golang-jwt/jwt/v4"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

const JWTSecret = "asecret"

func CreateToken(userID primitive.ObjectID) (string, error) {
	// JWT token oluşturma
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"userId": userID.Hex(),
		"exp":    time.Now().Add(time.Minute * 5).Unix(), // 5 dakikalık geçerlilik süresi
	})

	// JWT token'ı imzalama
	tokenString, err := token.SignedString([]byte(JWTSecret))
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

func AuthRequired(invalidTokens *sync.Map, tokenLifetime time.Duration) fiber.Handler {
	return jwtware.New(jwtware.Config{
		SigningKey: []byte(JWTSecret),
		SuccessHandler: func(c *fiber.Ctx) error {
			token := c.Get("Authorization")

			if _, ok := invalidTokens.Load(token); ok {
				return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
					"status": fiber.StatusUnauthorized,
					"error":  "Token is invalidated due to logout",
				})
			}

			// Token süresini uzatma
			user := c.Locals("user").(*jwt.Token)
			claims := user.Claims.(jwt.MapClaims)
			expirationTime := time.Now().Add(tokenLifetime)
			claims["exp"] = expirationTime.Unix()

			newToken, err := user.SignedString([]byte(JWTSecret))
			if err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"status": fiber.StatusInternalServerError,
					"error":  "Error while extending token",
				})
			}

			// userID'yi fiber.Ctx içinde saklama
			userID, err := primitive.ObjectIDFromHex(claims["userId"].(string))
			if err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"status": fiber.StatusInternalServerError,
					"error":  "Error while extracting userID from token",
				})
			}
			c.Locals("userID", userID)

			c.Set("Authorization", newToken)

			return c.Next()
		},

		ErrorHandler: func(ctx *fiber.Ctx, err error) error {
			return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"status": fiber.StatusUnauthorized,
				"error":  "Unauthorized Bearer Token",
			})
		},
	})
}
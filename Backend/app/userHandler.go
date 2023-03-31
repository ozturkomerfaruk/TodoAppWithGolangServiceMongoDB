package app

import (
	"fmt"
	"io"
	"mime/multipart"
	"net/http"

	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"omerfarukozturk.com/backend/models"
	"omerfarukozturk.com/backend/services"
)

type UserHandler struct {
	Service services.UserService
}

func (uh *UserHandler) RegisterHandler(c *fiber.Ctx) error {
	var newUser models.UserModel

	if err := c.BodyParser(&newUser); err != nil {
		return c.Status(http.StatusBadRequest).JSON(err.Error())
	}
	newUser.ID = primitive.NewObjectID()
	registeredUser, err := uh.Service.UserRegister(newUser)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(err.Error())
	}
	return c.Status(http.StatusCreated).JSON(registeredUser)
}

func (uh *UserHandler) LoginHandler(c *fiber.Ctx) error {
	var loginUser models.UserModel

	if err := c.BodyParser(&loginUser); err != nil {
		return c.Status(http.StatusBadRequest).JSON(err.Error())
	}

	loggedInUser, err := uh.Service.UserLogin(loginUser.Username, loginUser.Password)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(loggedInUser)
	}

	return c.Status(http.StatusOK).JSON(loggedInUser)
}

func (uh *UserHandler) LogoutHandler(c *fiber.Ctx) error {
	token := c.Get("Authorization")
	result, err := uh.Service.UserLogout(token)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(err.Error())
	}

	return c.Status(http.StatusOK).JSON(result)
}

func (h *UserHandler) GetAllUser(c *fiber.Ctx) error {
	result, err := h.Service.UserGetAll()

	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(err.Error())
	}

	return c.Status(http.StatusOK).JSON(result)
}

func (h UserHandler) GetUserDetail(c *fiber.Ctx) error {
	query := c.Params("id")
	cnv, _ := primitive.ObjectIDFromHex(query)

	result, err := h.Service.UserGetDetail(cnv)
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(result)
	}
	return c.Status(http.StatusOK).JSON(result)
}

func (h UserHandler) GetUserDetailByMail(c *fiber.Ctx) error {

	var req models.ResetPasswordRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(http.StatusInternalServerError).JSON(err.Error())
	}

	fmt.Println(req.Mail)
	result, err := h.Service.UserGetDetailByMail(req.Mail)
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(result)
	}
	return c.Status(http.StatusOK).JSON(result)
}

func (h UserHandler) DeleteAllUser(c *fiber.Ctx) error {
	result, err := h.Service.UserDeleteAll()
	if err != nil || result.Status != 200 {
		return c.Status(http.StatusInternalServerError).JSON(err.Error())
	}
	return c.Status(http.StatusOK).JSON(result)
}

func (h UserHandler) DeleteUser(c *fiber.Ctx) error {
	query := c.Params("id")
	cnv, _ := primitive.ObjectIDFromHex(query)

	result, err := h.Service.UserDelete(cnv)
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(result)
	}
	return c.Status(http.StatusOK).JSON(result)
}

func (h UserHandler) UpdateUser(c *fiber.Ctx) error {
	var update models.UserModel
	err := c.BodyParser(&update)
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(err.Error())
	}

	if file, err := c.FormFile("profilImage"); err == nil {
		fmt.Println(file.Filename)
		imageBytes, err := saveImageToMongoDB(file)
		if err != nil {
			return c.Status(http.StatusInternalServerError).JSON("Could not save image")
		}
		update.ProfilImage = imageBytes
	}

	if isUpdateEmpty(update) {
		return c.Status(http.StatusOK).JSON("No changes were made")
	}

	result, err := h.Service.UserUpdate(update)
	if err != nil {
		if result == nil {
			return c.Status(http.StatusNotFound).JSON("User not found")
		} else {
			return c.Status(http.StatusBadRequest).JSON("No changes were made")
		}
	}

	return c.Status(http.StatusCreated).JSON(result)
}

func (uh *UserHandler) ChangePasswordHandler(c *fiber.Ctx) error {
	var passwordUpdate models.PasswordUpdateModel

	if err := c.BodyParser(&passwordUpdate); err != nil {
		return c.Status(http.StatusBadRequest).JSON(err.Error())
	}

	result, err := uh.Service.UserUpdatePasswordById(passwordUpdate)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(err.Error())
	}

	return c.Status(http.StatusCreated).JSON(result)
}

func (uh *UserHandler) ChangePasswordHandlerByMail(c *fiber.Ctx) error {
	var passwordUpdate models.PasswordUpdateModelByEmail

	if err := c.BodyParser(&passwordUpdate); err != nil {
		return c.Status(http.StatusBadRequest).JSON(err.Error())
	}

	result, err := uh.Service.UserUpdatePasswordByEmail(passwordUpdate)
	if err != nil {
		return c.Status(http.StatusInternalServerError).JSON(err.Error())
	}

	return c.Status(http.StatusCreated).JSON(result)
}

func (uh *UserHandler) SendResetPasswordEmailHandler(c *fiber.Ctx) error {
	var req models.ResetPasswordRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(http.StatusBadRequest).JSON(map[string]interface{}{
			"status":  http.StatusBadRequest,
			"message": "Geçersiz istek",
		})
	}

	fmt.Println(req.Mail)

	result, err := uh.Service.SendResetPasswordEmail(req.Mail)
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(result)
	}

	return c.Status(http.StatusOK).JSON(result)
}

func isUpdateEmpty(u models.UserModel) bool {
	return u.ID.IsZero() && u.Username == "" && u.NameSurname == "" && u.Mail == "" && len(u.ProfilImage) == 0
}

// Save image to MongoDB
func saveImageToMongoDB(fileHeader *multipart.FileHeader) ([]byte, error) {
	// Read the image file
	imageData, err := fileHeader.Open()
	if err != nil {
		return nil, err
	}
	defer imageData.Close()

	imageBytes, err := io.ReadAll(imageData)
	if err != nil {
		return nil, err
	}

	return imageBytes, nil
}

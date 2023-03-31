package services

import (
	"bytes"
	"fmt"
	"net/http"
	"strings"
	"text/template"

	"go.mongodb.org/mongo-driver/bson/primitive"
	"golang.org/x/crypto/bcrypt"
	"gopkg.in/gomail.v2"
	"omerfarukozturk.com/backend/dto"
	"omerfarukozturk.com/backend/models"
	"omerfarukozturk.com/backend/repository"
)

type DefaultUserService struct {
	Repo repository.UserRepository
}

type UserService interface {
	UserRegister(user models.UserModel) (*dto.UserRegisterDTO, error)
	UserLogin(username, password string) (*dto.UserLoginDTO, error)
	UserLogout(token string) (*dto.UserLogoutDTO, error)
	UserGetAll() (*dto.UserListDTO, error)
	UserGetDetail(id primitive.ObjectID) (*dto.UserModelDTO, error)
	UserGetDetailByMail(mail string) (*dto.UserModelDTO, error)
	UserDelete(id primitive.ObjectID) (*dto.UserDeleteDTO, error)
	UserDeleteAll() (*dto.UserDeleteDTO, error)
	UserUpdate(update models.UserModel) (*dto.UserModelDTO, error)
	UserUpdatePasswordById(user models.PasswordUpdateModel) (*dto.PasswordUpdateModelDTO, error)
	UserUpdatePasswordByEmail(user models.PasswordUpdateModelByEmail) (*dto.PasswordUpdateModelDTO, error)
	SendResetPasswordEmail(email string) (*dto.PasswordUpdateModelDTO, error)
}

func (t DefaultUserService) UserRegister(user models.UserModel) (*dto.UserRegisterDTO, error) {
	var res dto.UserRegisterDTO

	// Şifreyi hashle
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}
	user.Password = string(hashedPassword)

	// Kullanıcıyı kaydet
	err = t.Repo.Register(user)
	if err != nil {
		res.Status = http.StatusInternalServerError
		return nil, err
	}

	res = dto.UserRegisterDTO{
		Status:  http.StatusOK,
		Message: "Created User Successfully",
	}
	return &res, nil
}

func (t DefaultUserService) UserLogin(username, password string) (*dto.UserLoginDTO, error) {
	user, err := t.Repo.Login(username)
	if err != nil {
		res := &dto.UserLoginDTO{
			Status:  http.StatusUnauthorized,
			Message: "Invalid username or password",
		}
		return res, err
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password))
	if err != nil {
		res := &dto.UserLoginDTO{
			Status:  http.StatusUnauthorized,
			Message: "Invalid username or password",
		}
		return res, err
	}

	token, err := CreateToken(user.ID)
	if err != nil {
		return nil, err
	}

	res := &dto.UserLoginDTO{
		Status:  http.StatusOK,
		Message: "Login Successfully",
		Token:   token,
		UserId:  user.ID.Hex(),
	}

	return res, nil
}

func (t DefaultUserService) UserLogout(token string) (*dto.UserLogoutDTO, error) {
	err := t.Repo.Logout(token)
	if err != nil {
		res := &dto.UserLogoutDTO{
			Status:  http.StatusInternalServerError,
			Message: "Error during logout",
		}
		return res, err
	}

	res := &dto.UserLogoutDTO{
		Status:  http.StatusOK,
		Message: "Logout successfully",
	}
	return res, nil
}

func (t DefaultUserService) UserGetAll() (*dto.UserListDTO, error) {
	result, count, err := t.Repo.GetAllUser()
	if err != nil {
		return &dto.UserListDTO{
			Status:  http.StatusInternalServerError,
			Message: err.Error(),
		}, err
	}

	return &dto.UserListDTO{
		Status:  http.StatusOK,
		Message: "Listed Successfully",
		Count:   count,
		Result:  result,
	}, nil

}

func (t DefaultUserService) UserGetDetail(id primitive.ObjectID) (*dto.UserModelDTO, error) {
	result, err := t.Repo.Detail(id)
	if err != nil {
		return &dto.UserModelDTO{
			Status:  http.StatusInternalServerError,
			Message: err.Error(),
		}, err
	}

	return &dto.UserModelDTO{
		Status:  http.StatusOK,
		Message: "User Model Fetched Successfully",
		Result: models.UserModel{
			ID:          result.ID,
			Username:    result.Username,
			NameSurname: result.NameSurname,
			Password:    result.Password,
			Mail:        result.Mail,
			ProfilImage: result.ProfilImage,
		},
	}, nil
}

func (t DefaultUserService) UserGetDetailByMail(mail string) (*dto.UserModelDTO, error) {
	result, err := t.Repo.DetailByEmail(mail)
	if err != nil {
		return &dto.UserModelDTO{
			Status:  http.StatusInternalServerError,
			Message: err.Error(),
		}, err
	}

	return &dto.UserModelDTO{
		Status:  http.StatusOK,
		Message: "User Model Fetched Successfully",
		Result: models.UserModel{
			ID:          result.ID,
			Username:    result.Username,
			NameSurname: result.NameSurname,
			Password:    result.Password,
			Mail:        result.Mail,
			ProfilImage: result.ProfilImage,
		},
	}, nil
}

func (t DefaultUserService) UserDelete(id primitive.ObjectID) (*dto.UserDeleteDTO, error) {
	err := t.Repo.Delete(id)

	if err != nil {
		return &dto.UserDeleteDTO{
			Status:  http.StatusInternalServerError,
			Message: err.Error(),
		}, err
	}

	return &dto.UserDeleteDTO{
		Status:  http.StatusOK,
		Message: "Deleted This User Successfully",
	}, nil
}

func (t DefaultUserService) UserDeleteAll() (*dto.UserDeleteDTO, error) {
	err := t.Repo.DeleteAll()
	if err != nil {
		return &dto.UserDeleteDTO{
			Status:  http.StatusInternalServerError,
			Message: err.Error(),
		}, err
	}
	return &dto.UserDeleteDTO{
		Status:  http.StatusOK,
		Message: "All Deleted Successfully",
	}, nil
}

func (t DefaultUserService) UserUpdate(update models.UserModel) (*dto.UserModelDTO, error) {
	err := t.Repo.Update(update)
	if err != nil {
		return &dto.UserModelDTO{
			Status:  http.StatusOK,
			Message: "No Update Has Been Made.",
			Result:  update,
		}, nil
	}

	return &dto.UserModelDTO{
		Status:  http.StatusOK,
		Message: "User Updated Successfully",
		Result:  update,
	}, nil
}

func (t DefaultUserService) UserUpdatePasswordById(user models.PasswordUpdateModel) (*dto.PasswordUpdateModelDTO, error) {

	// Kullanıcıyı al
	storedUser, err := t.UserGetDetail(user.UserID)
	if err != nil {
		return nil, err
	}

	// Eski şifreyi doğrula
	err = bcrypt.CompareHashAndPassword([]byte(storedUser.Result.Password), []byte(user.OldPassword))
	if err != nil {
		return &dto.PasswordUpdateModelDTO{
			Status:  http.StatusAccepted,
			Message: "The Old Password Was Entered Incorrectly.",
		}, nil
	}

	// Yeni şifreyi hashle
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}
	user.NewPassword = string(hashedPassword)

	// Şifreyi güncelle
	err = t.Repo.UpdatePasswordById(user)
	if err != nil {
		return nil, err
	}

	return &dto.PasswordUpdateModelDTO{
		Status:  http.StatusOK,
		Message: "Password Updated Successfully",
	}, nil
}

func (t DefaultUserService) UserUpdatePasswordByEmail(user models.PasswordUpdateModelByEmail) (*dto.PasswordUpdateModelDTO, error) {
	// Yeni şifreyi hashle
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}
	user.NewPassword = string(hashedPassword)

	// Şifreyi güncelle
	err = t.Repo.UpdatePasswordByEmail(user)
	if err != nil {
		return nil, err
	}

	return &dto.PasswordUpdateModelDTO{
		Status:  http.StatusOK,
		Message: "Password Updated Successfully",
	}, nil
}

func (t DefaultUserService) SendResetPasswordEmail(email string) (*dto.PasswordUpdateModelDTO, error) {

	user, err := t.Repo.GetUserByEmail(email)
	if err != nil {
		return &dto.PasswordUpdateModelDTO{
			Status:  http.StatusBadRequest,
			Message: "Kullanıcı Bulunamadı",
		}, err
	}

	// Get HTML
	var body bytes.Buffer
	tmpl, err := template.ParseFiles("./email.html")
	if err != nil {
		return &dto.PasswordUpdateModelDTO{
			Status:  http.StatusBadRequest,
			Message: "Mail İçeriği Oluşturulamadı",
		}, err
	}

	parts := splitEmail(email)

	resetURL := "todoapp://" + parts[0] + "-" + parts[1]
	fmt.Println(resetURL)

	tmpl.Execute(&body, struct {
		Name     string
		ResetURL string
	}{
		Name:     user.NameSurname,
		ResetURL: resetURL,
	})

	m := gomail.NewMessage()
	m.SetHeader("From", "omerfarukozturk026@gmail.com")
	m.SetHeader("To", user.Mail)
	//m.SetAddressHeader("Cc", "iletisim@omerfarukozturk.com", "Dan")
	m.SetHeader("Subject", "Hello!")
	m.SetBody("text/html", body.String())

	d := gomail.NewDialer("smtp.gmail.com", 587, "omerfarukozturk026@gmail.com", "Şifreme bakma lütfen :))")

	if err := d.DialAndSend(m); err != nil {
		return &dto.PasswordUpdateModelDTO{
			Status:  http.StatusBadRequest,
			Message: "Mail Gönderme İşlemi Başarısız Oldu.",
		}, err
	}

	return &dto.PasswordUpdateModelDTO{
		Status:  http.StatusOK,
		Message: "E-posta başarıyla gönderildi",
	}, nil
}

func NewUserService(Repo repository.UserRepository) DefaultUserService {
	return DefaultUserService{Repo: Repo}
}

//--------

func splitEmail(email string) []string {
	atIndex := strings.Index(email, "@")
	iletisim := email[:atIndex]
	omerfarukozturk := email[atIndex+1:]

	domainIndex := strings.Index(omerfarukozturk, ".")
	omerfarukozturk = omerfarukozturk[:domainIndex]

	return []string{iletisim, omerfarukozturk}
}

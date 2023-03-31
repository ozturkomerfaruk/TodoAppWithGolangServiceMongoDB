package dto

type UserLoginDTO struct {
	Status  int    `json:"status"`
	Message string `json:"message"`
	Token   string `json:"token"`
	UserId  string `json:"userId"`
}

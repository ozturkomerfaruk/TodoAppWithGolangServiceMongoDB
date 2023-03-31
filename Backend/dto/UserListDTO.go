package dto

import "omerfarukozturk.com/backend/models"

type UserListDTO struct {
	Status  int                `json:"status"`
	Message string             `json:"message"`
	Count   int                `json:"count"`
	Result  []models.UserModel `json:"result"`
}

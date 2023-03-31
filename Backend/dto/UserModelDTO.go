package dto

import "omerfarukozturk.com/backend/models"

type UserModelDTO struct {
	Status  int              `json:"status"`
	Message string           `json:"message"`
	Result  models.UserModel `json:"result"`
}

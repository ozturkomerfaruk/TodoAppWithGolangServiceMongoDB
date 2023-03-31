package dto

import "omerfarukozturk.com/backend/models"

type TodoUpdateDTO struct {
	Status  int         `json:"status"`
	Message string      `json:"message"`
	Result  models.Todo `json:"result"`
}

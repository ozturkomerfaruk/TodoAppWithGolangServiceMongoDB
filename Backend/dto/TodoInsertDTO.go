package dto

import "omerfarukozturk.com/backend/models"

type TodoInsertDTO struct {
	Status  int         `json:"status"`
	Message string      `json:"message"`
	Result  models.Todo `json:"result"`
}

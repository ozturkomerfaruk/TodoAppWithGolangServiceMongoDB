package dto

import "omerfarukozturk.com/backend/models"

type TodoDTO struct {
	Status  int         `json:"status,omitempty"`
	Message string      `json:"message,omitempty"`
	Todo    models.Todo `json:"todo,omitempty"`
}

type TodoDeleteAllDTO struct {
	Status  int    `json:"status,omitempty"`
	Message string `json:"message,omitempty"`
}

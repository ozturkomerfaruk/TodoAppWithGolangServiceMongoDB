package dto

import "omerfarukozturk.com/backend/models"

type TodoListDTO struct {
	Status   int           `json:"status,omitempty"`
	Message  string        `json:"message,omitempty"`
	TodoList []models.Todo `json:"todos,omitempty"`
}

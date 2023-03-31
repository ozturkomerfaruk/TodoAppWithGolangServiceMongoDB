package dto

import "omerfarukozturk.com/backend/models"

type TodoListDTO struct {
	Status               int           `json:"status"`
	Message              string        `json:"message"`
	Count                int           `json:"count"`
	ProgressPercent      float32       `json:"progressPercent"`
	CountToday           int           `json:"countToday"`
	ProgressPercentToday float32       `json:"progressPercentToday"`
	Result               []models.Todo `json:"result"`
}

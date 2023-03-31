package models

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Todo struct {
	ID        primitive.ObjectID `json:"id,omitempty"`
	UserID    primitive.ObjectID `json:"userId,omitempty"`
	Title     string             `json:"title"`
	Category  string             `json:"category"`
	Date      string             `json:"date"`
	StartTime string             `json:"startTime"`
	EndTime   string             `json:"endTime"`
	Content   string             `json:"content"`
	Progress  int                `json:"progress"`
}

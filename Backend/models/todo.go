package models

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Todo struct {
	ID        primitive.ObjectID `json:"id,omitempty"`
	Title     string             `json:"title,omitempty"`
	Category  string             `json:"category,omitempty"`
	Date      string             `json:"date,omitempty"`
	StartTime string             `json:"startTime,omitempty"`
	EndTime   string             `json:"endTime,omitempty"`
	Content   string             `json:"content,omitempty"`
	Progress  string             `json:"progress,omitempty"`
}

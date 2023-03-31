package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type PasswordUpdateModel struct {
	UserID      primitive.ObjectID `json:"userId"`
	OldPassword string             `json:"oldPassword"`
	NewPassword string             `json:"newPassword"`
}

type PasswordUpdateModelByEmail struct {
	Mail        string `json:"mail"`
	NewPassword string `json:"newPassword"`
}

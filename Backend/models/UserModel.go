package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type UserModel struct {
	ID          primitive.ObjectID `json:"id,omitempty"`
	Username    string             `json:"username"`
	NameSurname string             `json:"nameSurname"`
	Password    string             `json:"password"`
	Mail        string             `json:"mail"`
	ProfilImage []byte             `json:"profilImage"`
}

package repository

import (
	"context"
	"errors"
	"sync"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"omerfarukozturk.com/backend/models"
)

type UserRepositoryDB struct {
	UserCollection *mongo.Collection
	InvalidTokens  *sync.Map
}

type UserRepository interface {
	Register(todo models.UserModel) error
	Login(username string) (*models.UserModel, error)
	Logout(token string) error
	GetAllUser() ([]models.UserModel, int, error)
	Detail(id primitive.ObjectID) (*models.UserModel, error)
	DetailByEmail(mail string) (*models.UserModel, error)
	Delete(id primitive.ObjectID) error
	DeleteAll() error
	Update(update models.UserModel) error
	UpdatePasswordById(user models.PasswordUpdateModel) error
	UpdatePasswordByEmail(user models.PasswordUpdateModelByEmail) error
	GetUserByEmail(email string) (*models.UserModel, error)
}

func (u UserRepositoryDB) Register(user models.UserModel) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	result, err := u.UserCollection.InsertOne(ctx, user)

	if result.InsertedID == nil || err != nil {
		err := errors.New("failed add")
		if err != nil {
			return err
		}
	}
	return nil
}

func (u UserRepositoryDB) Login(username string) (*models.UserModel, error) {
	var user models.UserModel
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	err := u.UserCollection.FindOne(ctx, bson.M{"username": username}).Decode(&user)
	if err != nil {
		return &models.UserModel{}, err
	}

	return &user, nil
}

func (u UserRepositoryDB) Logout(token string) error {
	// Token'ı geçersiz token'lar listesine ekleyin
	u.InvalidTokens.Store(token, time.Now().Add(time.Minute*5))

	// Süresi dolmuş token'ları temizle
	u.cleanExpiredTokens()

	return nil
}

func (t UserRepositoryDB) GetAllUser() ([]models.UserModel, int, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	var userList []models.UserModel
	result, err := t.UserCollection.Find(ctx, bson.M{})
	if err != nil {
		return nil, 0, err
	}
	defer result.Close(ctx)

	count := 0
	for result.Next(ctx) {
		var user models.UserModel
		if err := result.Decode(&user); err != nil {
			return nil, 0, err
		}

		userList = append(userList, user)
		count++
	}
	return userList, count, nil
}

func (t UserRepositoryDB) Detail(id primitive.ObjectID) (*models.UserModel, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	var user models.UserModel
	err := t.UserCollection.FindOne(ctx, bson.M{"id": id}).Decode(&user)
	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (t UserRepositoryDB) DetailByEmail(mail string) (*models.UserModel, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	var user models.UserModel
	err := t.UserCollection.FindOne(ctx, bson.M{"mail": mail}).Decode(&user)
	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (t UserRepositoryDB) Delete(id primitive.ObjectID) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	result, err := t.UserCollection.DeleteOne(ctx, bson.M{"id": id})
	if err != nil || result.DeletedCount <= 0 {
		return err
	}
	return nil
}

func (t UserRepositoryDB) DeleteAll() error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	_, err := t.UserCollection.DeleteMany(ctx, bson.M{})
	if err != nil {
		return err
	}
	return nil
}

func (u UserRepositoryDB) Update(update models.UserModel) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	updateDoc := bson.M{"$set": bson.M{}}

	if update.Username != "" {
		updateDoc["$set"].(bson.M)["username"] = update.Username
	}
	if update.NameSurname != "" {
		updateDoc["$set"].(bson.M)["nameSurname"] = update.NameSurname
	}
	if update.Mail != "" {
		updateDoc["$set"].(bson.M)["mail"] = update.Mail
	}
	if update.Password != "" {
		updateDoc["$set"].(bson.M)["password"] = update.Password
	}
	if len(update.ProfilImage) > 0 {
		updateDoc["$set"].(bson.M)["profilImage"] = update.ProfilImage
	}

	if len(updateDoc["$set"].(bson.M)) == 0 {
		return errors.New("no changes were made")
	}

	result, err := u.UserCollection.UpdateOne(ctx, bson.M{"id": update.ID}, updateDoc)

	if err != nil {
		return err
	}
	if result.ModifiedCount <= 0 {
		return errors.New("no document found")
	}
	return nil
}

func (u UserRepositoryDB) UpdatePasswordById(user models.PasswordUpdateModel) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	filter := bson.M{"id": user.UserID}
	update := bson.M{"$set": bson.M{"password": user.NewPassword}}

	result, err := u.UserCollection.UpdateOne(ctx, filter, update)

	if err != nil || result.ModifiedCount == 0 {
		err := errors.New("failed to update password")
		if err != nil {
			return err
		}
	}
	return nil
}

func (u UserRepositoryDB) UpdatePasswordByEmail(user models.PasswordUpdateModelByEmail) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	filter := bson.M{"mail": user.Mail}
	update := bson.M{"$set": bson.M{"password": user.NewPassword}}

	result, err := u.UserCollection.UpdateOne(ctx, filter, update)

	if err != nil || result.ModifiedCount == 0 {
		err := errors.New("failed to update password")
		if err != nil {
			return err
		}
	}
	return nil
}

func (u UserRepositoryDB) GetUserByEmail(email string) (*models.UserModel, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	var user models.UserModel
	err := u.UserCollection.FindOne(ctx, bson.M{"mail": email}).Decode(&user)
	if err != nil {
		return nil, err
	}

	return &user, nil
}

func NewUserRepositoryDb(dbUser *mongo.Collection, invalidTokens *sync.Map) UserRepositoryDB {
	return UserRepositoryDB{UserCollection: dbUser, InvalidTokens: invalidTokens}
}

//-------------------------------------------------------------------------------------------------------

// Süresi dolmuş token'ları temizleme işlemi
func (u UserRepositoryDB) cleanExpiredTokens() {
	now := time.Now()
	u.InvalidTokens.Range(func(key, value interface{}) bool {
		expiryTime := value.(time.Time)
		if now.After(expiryTime) {
			u.InvalidTokens.Delete(key)
		}
		return true
	})
}

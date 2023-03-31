package repository

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"omerfarukozturk.com/backend/models"
)

//go:generate mockgen -destination=../mocks/repository/mockTodoRepository.go -package=repository omerfarukozturk.com/backend/repository TodoRepository
type TodoRepositoryDB struct {
	TodoCollection *mongo.Collection
}

type TodoRepository interface {
	Insert(todo models.Todo, userId primitive.ObjectID) error
	GetAll(userId primitive.ObjectID) ([]models.Todo, int, float32, int, float32, error)
	Delete(id primitive.ObjectID) error
	DeleteAll(userId primitive.ObjectID) error
	Detail(id primitive.ObjectID) (*models.Todo, error)
	Update(update models.Todo) error
}

func (t TodoRepositoryDB) Insert(todo models.Todo, userId primitive.ObjectID) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	result, err := t.TodoCollection.InsertOne(ctx, todo)

	if result.InsertedID == nil || err != nil {
		err := errors.New("failed add")
		if err != nil {
			return err
		}
	}
	return nil
}

func (t TodoRepositoryDB) GetAll(userId primitive.ObjectID) ([]models.Todo, int, float32, int, float32, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	var todos []models.Todo
	result, err := t.TodoCollection.Find(ctx, bson.M{"userid": userId})
	if err != nil {
		return nil, 0, 0, 0, 0, err
	}
	defer result.Close(ctx)

	today := time.Now().Format("Jan 02, 2006")
	var count, countToday, sum, sumToday int
	for result.Next(ctx) {
		var todo models.Todo
		if err := result.Decode(&todo); err != nil {
			return nil, 0, 0, 0, 0, err
		}

		normalizedDate, err := normalizeDateFormat(todo.Date)
		if err != nil {
			return nil, 0, 0, 0, 0, err
		}
		todo.Date = normalizedDate

		todos = append(todos, todo)
		sum += todo.Progress
		count++

		if today == todo.Date {
			countToday++
			sumToday += todo.Progress
		}
	}

	var percent, percentToday float32
	if count > 0 {
		percent = float32(sum) / float32(count)
	}
	if countToday > 0 {
		percentToday = float32(sumToday) / float32(countToday)
	}

	if count == 0 {
		percent = 100
	}

	if countToday == 0 {
		percentToday = 100
	}

	return todos, count, percent, countToday, percentToday, nil
}

func (t TodoRepositoryDB) Delete(id primitive.ObjectID) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	result, err := t.TodoCollection.DeleteOne(ctx, bson.M{"id": id})
	if err != nil || result.DeletedCount <= 0 {
		return err
	}
	return nil
}

func (t TodoRepositoryDB) DeleteAll(userId primitive.ObjectID) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	_, err := t.TodoCollection.DeleteMany(ctx, bson.M{"userid": userId})
	if err != nil {
		return err
	}
	return nil
}

func (t TodoRepositoryDB) Detail(id primitive.ObjectID) (*models.Todo, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	var todo models.Todo
	err := t.TodoCollection.FindOne(ctx, bson.M{"id": id}).Decode(&todo)
	if err != nil {
		return nil, err
	}

	return &todo, nil
}

func (t TodoRepositoryDB) Update(update models.Todo) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	updateDoc := bson.M{"$set": bson.M{
		"title":     update.Title,
		"category":  update.Category,
		"date":      update.Date,
		"startTime": update.StartTime,
		"endTime":   update.EndTime,
		"content":   update.Content,
		"progress":  update.Progress,
	}}
	result, err := t.TodoCollection.UpdateOne(ctx, bson.M{"id": update.ID}, updateDoc)

	if err != nil {
		return err
	}
	if result.ModifiedCount <= 0 {
		return errors.New("no document found")
	}
	return nil
}

func NewTodoRepositoryDb(dbClient *mongo.Collection) TodoRepositoryDB {
	return TodoRepositoryDB{TodoCollection: dbClient}
}

//--

func normalizeDateFormat(dateStr string) (string, error) {
	dateFormats := []string{"Jan 02, 2006", "02 Jan 2006"}

	dateStr = replaceTurkishMonthNames(dateStr) // Bu satırı ekleyin

	for _, format := range dateFormats {
		t, err := time.Parse(format, dateStr)
		if err == nil {
			return t.Format("Jan 02, 2006"), nil
		}
	}

	fmt.Printf("Invalid date format: %s\n", dateStr)
	return "", fmt.Errorf("invalid date format")
}

func replaceTurkishMonthNames(dateStr string) string {
	monthReplacements := map[string]string{
		"Oca": "Jan",
		"Şub": "Feb",
		"Mar": "Mar",
		"Nis": "Apr",
		"May": "May",
		"Haz": "Jun",
		"Tem": "Jul",
		"Ağu": "Aug",
		"Eyl": "Sep",
		"Ek":  "Oct",
		"Kas": "Nov",
		"Ara": "Dec",
	}

	for turkishMonth, englishMonth := range monthReplacements {
		dateStr = strings.Replace(dateStr, turkishMonth, englishMonth, -1)
	}

	return dateStr
}

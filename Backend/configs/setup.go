package configs

import (
	"context"
	"log"
	"strings"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func ConnectDB() *mongo.Client {
	//clientOptions := options.Client().ApplyURI(EnvMongoURI())
	//client, err := mongo.Connect(context.Background(), clientOptions)
	client, err := mongo.NewClient(options.Client().ApplyURI(EnvMongoURI()))

	if err != nil {
		log.Fatalln(err)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	err = client.Connect(ctx)
	if err != nil {
		log.Fatalln(err)
	}

	err = client.Ping(ctx, nil)
	if err != nil {
		log.Fatalln(err)
	}

	return client
}

var DB *mongo.Client = ConnectDB()

func GetCollection(client *mongo.Client, collectionName string) *mongo.Collection {
	return client.Database("database").Collection(collectionName)
}

func CreateCollection(client *mongo.Client, databaseName string, collectionName string) (*mongo.Collection, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	collection := client.Database(databaseName).Collection(collectionName)

	if err := collection.Database().CreateCollection(ctx, collectionName); err != nil {
		if !strings.Contains(err.Error(), "NamespaceExists") {
			return nil, err
		}
	}

	return collection, nil
}

package models

type GetAllTasksModel struct {
	Todos        []Todo
	Count        int
	Percent      float32
	CountToday   int
	PercentToday float32
}

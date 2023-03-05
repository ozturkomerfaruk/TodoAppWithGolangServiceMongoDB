package dto

type TodoDTO struct {
	Status bool `json:"status,omitempty"`
	//Todo   models.Todo `json:"todo,omitempty"`
	ID      string `json:"id,omitempty"`
	Title   string `json:"title,omitempty"`
	Content string `json:"content,omitempty"`
}

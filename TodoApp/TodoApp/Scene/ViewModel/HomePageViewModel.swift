//
//  HomePageViewModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 6.03.2023.
//

import Foundation

protocol HomePageViewModelProtocol {
    func fetchAllTodos()
    func getAllTodos() -> [TodoTaskModel]
    func getAllTaskProgressModels() -> [TaskProgressModel]
    func deleteTodo(id: String, completion: @escaping () -> Void)
}

protocol HomePageViewModelDelegate: AnyObject {
    func preFetch()
    func fetchLoaded()
    func fetchFailed(error: Error)
}

final class HomePageViewModel {
    weak var delegate: HomePageViewModelDelegate?
    private var todos = [TodoTaskModel]()
    private var todosToday = [TodoTaskModel]()
    private var allTaskProgressModels = [TaskProgressModel]()
    private var count = 0
    private var percent = 0.0
    private var countToday = 0
    private var percentToday = 0.0
    
    func fetchAllTodos() {
        self.delegate?.preFetch()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let currentDate = Date()
        let currentDateString = dateFormatter.string(from: currentDate)
        Client.getTodoList { [weak self] baseModel, error in
            guard let self = self else { return }
            if let baseModel = baseModel, let result = baseModel.result {
                self.todosToday = result.filter { $0.date == currentDateString }
                self.todos = result
                self.insertedATaskProgress(model: TaskProgressModel(isTitleToday: false, taskCount: baseModel.count, progressPercent: baseModel.progressPercent))
                self.insertedATaskProgress(model: TaskProgressModel(isTitleToday: true, taskCount: baseModel.countToday, progressPercent: baseModel.progressPercentToday))
                self.delegate?.fetchLoaded()
            } else {
                self.todos = []
            }
        }
    }

    
    func getAllTodos() -> [TodoTaskModel] {
        return self.todos
    }
    
    func getTodayTodos() -> [TodoTaskModel] {
        return self.todosToday
    }
    
    func updateTaskProgressModels(completion: @escaping () -> Void) {
        self.allTaskProgressModels.removeAll()
        Client.getTodoList { [weak self] baseModel, error in
            guard let self = self else { return }
            if let baseModel = baseModel {
                self.count = baseModel.count ?? 0
                self.percent     = baseModel.progressPercent ?? 0.0
                self.countToday = baseModel.countToday ?? 0
                self.percentToday = baseModel.progressPercentToday ?? 0.0
                
                self.insertedATaskProgress(model: TaskProgressModel(isTitleToday: false, taskCount: baseModel.count, progressPercent: baseModel.progressPercent))
                self.insertedATaskProgress(model: TaskProgressModel(isTitleToday: true, taskCount: baseModel.countToday, progressPercent: baseModel.progressPercentToday))
                completion()
            }
        }
    }

    
    func getAllTaskProgressModels() -> [TaskProgressModel] {
        return self.allTaskProgressModels
    }
    
    func deleteTodo(id: String, completion: @escaping () -> Void) {
        Client.deleteTodo(withId: id) { [weak self] model, error in
            guard let self = self else { return }
            if let message = model?.message {
                print(message)
                self.removeTodoInBothLists(id: id)
                completion()
            } else {
                fatalError(String(describing: error))
            }
        }
    }
    
    func removeTodoInBothLists(id: String) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos.remove(at: index)
        }

        if let index = todosToday.firstIndex(where: { $0.id == id }) {
            todosToday.remove(at: index)
        }
    }
}

extension HomePageViewModel {
    private func insertedATaskProgress(model: TaskProgressModel) {
        self.allTaskProgressModels.append(model)
    }
}


//
//  HomePageView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit

enum TaskType {
    case all
    case today
}

final class HomePageView: UIViewController {
    
    private var isTableViewIcon = false
    private var selectedTaskType: TaskType = .all
    
    @IBOutlet private weak var taskTitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var taskCollectionView: UICollectionView!
    
    var viewModel = HomePageViewModel()
    var createNewTaskView = CreateNewTaskView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchAllTodos()
        self.fetchLoaded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomePageView()
    }
    
    private func configureHomePageView() {
        
        
        viewModel.delegate = self
        navigationItem.title = "Homepage"
        tabBarItem.title = ""
        barButtonLeftItem()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customTableViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionViewCell")
        
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        taskCollectionView.register(UINib(nibName: "CustomTaskCell", bundle: nil), forCellWithReuseIdentifier: "customTaskCell")
        taskCollectionView.showsHorizontalScrollIndicator = false // Yatay indicator'u gizle
    }
    
    private func updateTaskTitleLabel() {
        switch selectedTaskType {
        case .all:
            taskTitleLabel.text = "All Task"
        case .today:
            taskTitleLabel.text = "Today's Task"
        }
    }

}

extension HomePageView {
    private func barButtonLeftItem() {
        let iconSize = CGSize(width: 30, height: 30)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        let tableViewIcon = makeBarButton(image: UIImage(systemName: "list.dash"), iconSize: iconSize)
        let collectionViewIcon = makeBarButton(image: UIImage(systemName: "square.grid.2x2"), iconSize: iconSize)
        
        let leftBarButton = UIBarButtonItem(customView: isTableViewIcon ? tableViewIcon : collectionViewIcon)
        let leftPaddingBarButton = UIBarButtonItem(customView: paddingView)
        
        self.navigationItem.leftBarButtonItems = [leftPaddingBarButton, leftBarButton]
    }
    
    private func makeBarButton(image: UIImage?, iconSize: CGSize) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(
            top: (50 - iconSize.height) / 2,
            left: (50 - iconSize.width) / 2,
            bottom: (50 - iconSize.height) / 2,
            right: (50 - iconSize.width) / 2
        )
        button.tintColor = .gray
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(barButtonTapped), for: .touchUpInside)
        return button
    }
    
    // UIBarButtonItem'a tıklandığında çağrılacak yöntem
    @objc func barButtonTapped(_ sender: UIBarButtonItem) {
        isTableViewIcon.toggle()
        barButtonLeftItem()
        tableView.isHidden = isTableViewIcon ? true : false
        collectionView.isHidden = isTableViewIcon ? false : true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TaskDetailView, let rowIndex = sender as? Int {
            let indexPath = IndexPath(row: rowIndex, section: 0)
            vc.modelID = viewModel.getAllTodos()[indexPath.row].id
        }
    }
}

extension HomePageView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTaskType == .all ? viewModel.getAllTodos().count : viewModel.getTodayTodos().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customTableViewCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        let model = selectedTaskType == .all ? viewModel.getAllTodos()[indexPath.row] : viewModel.getTodayTodos()[indexPath.row]
        cell.configureCustomTableViewCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toTaskDetailView", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todoList = selectedTaskType == .all ? viewModel.getAllTodos() : viewModel.getTodayTodos()
            guard let id = todoList[indexPath.row].id else { return }
            
            self.viewModel.deleteTodo(id: id) {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.viewModel.removeTodoInBothLists(id: id)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()

                    self.viewModel.updateTaskProgressModels {
                        DispatchQueue.main.async {
                            self.taskCollectionView.reloadData()
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}


extension HomePageView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView:
            return selectedTaskType == .all ? viewModel.getAllTodos().count : viewModel.getTodayTodos().count
        case self.taskCollectionView:
            return 2
        default:
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case self.collectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let model = selectedTaskType == .all ? viewModel.getAllTodos()[indexPath.row] : viewModel.getTodayTodos()[indexPath.row]
            cell.configureCustomCollectionViewCell(model: model)
            return cell
        case self.taskCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customTaskCell", for: indexPath) as? CustomTaskCell else {
                return UICollectionViewCell()
            }
            viewModel.updateTaskProgressModels { [weak self] in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        cell.configureCustomCell(model: self.viewModel.getAllTaskProgressModels()[indexPath.row])
                    }
                }
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.collectionView:
            return CGSize(width: 208, height: 179)
        case self.taskCollectionView:
            return CGSize(width: 350, height: 120)
        default:
            return CGSize(width: 350, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.collectionView:
            performSegue(withIdentifier: "toTaskDetailView", sender: indexPath.row)
        case self.taskCollectionView:
            selectedTaskType = indexPath.item == 0 ? .all : .today
            updateTaskTitleLabel()
            self.collectionView.reloadData()
            self.tableView.reloadData()
        default:
            print("default")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        switch collectionView {
        case self.collectionView:
            return true
        default:
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        switch collectionView {
        case self.collectionView:
            collectionView.allowsMultipleSelection = true
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = UIColor.gray
        default:
            collectionView.allowsMultipleSelection = false
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, attributes: .destructive) { action in
            // Seçili öğeyi sil
            collectionView.performBatchUpdates {
                // Hücreleri koleksiyondan kaldır
                guard let id = self.viewModel.getAllTodos()[indexPath.row].id else { return }
                self.viewModel.deleteTodo(id: id) {
                    DispatchQueue.main.async {
                        collectionView.deleteItems(at: [indexPath])
                        self.viewModel.removeTodoInBothLists(id: id)
                        self.viewModel.updateTaskProgressModels {
                            DispatchQueue.main.async {
                                self.taskCollectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        switch collectionView {
        case self.collectionView:
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                UIMenu(title: "Delete", children: [deleteAction])
            }
        default:
            return nil
        }
    }
    
}

extension HomePageView: HomePageViewModelDelegate {
    func fetchLoaded() {
        self.tableView.reloadData()
        self.collectionView.reloadData()
        self.taskCollectionView.reloadData()
    }
    
    func fetchFailed(error: Error) {
        print("Error fetching todos: \(error.localizedDescription)")
    }
    
    func preFetch() {
        print("pre fetch")
    }
    
}

extension HomePageView: UIScrollViewDelegate {
    
    // Yatay olarak collection view'ın scroll özelliğini takip etme
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == taskCollectionView {
            let pageWidth = scrollView.frame.size.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            selectedTaskType = currentPage == 0 ? .all : .today
            updateTaskTitleLabel()
            collectionView.reloadData()
            tableView.reloadData()
        }
    }
}




//
//  HomePageView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit

final class HomePageView: UIViewController {
    
    private var isTableViewIcon = false
    
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var taskCollectionView: UICollectionView!
    
    var viewModel = HomePageViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomePageView()
        
    }
    
    private func configureHomePageView() {
        viewModel.delegate = self
        viewModel.fetchAllTodos()
        print(viewModel.todos.count)
        
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
            vc.todoModel = viewModel.todos[indexPath.row]
        }
    }
}

extension HomePageView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customTableViewCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        let model = viewModel.todos[indexPath.row]
        cell.configureCustomTableViewCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toTaskDetailView", sender: indexPath.row)
    }
}


extension HomePageView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView:
            return viewModel.todos.count
        case self.taskCollectionView:
            return 2
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case self.collectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
                return UICollectionViewCell()
            }
            let model = viewModel.todos[indexPath.row]
            cell.configureCustomCollectionViewCell(model: model)
            return cell
        case self.taskCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customTaskCell", for: indexPath) as? CustomTaskCell else {
                return UICollectionViewCell()
            }
            cell.configureCustomCell(count: "45 Tasks", percent: "40%")
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
            return CGSize(width: 20, height: 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.collectionView:
            performSegue(withIdentifier: "toTaskDetailView", sender: indexPath.row)
        case self.taskCollectionView:
            print("asdkasd")
        default:
            print("default")
        }
    }
}

extension HomePageView: HomePageViewModelDelegate {
    func fetchLoaded() {
        tableView.reloadData()
        collectionView.reloadData()
        taskCollectionView.reloadData()
    }
    
    func fetchFailed(error: Error) {
        print("Error fetching todos: \(error.localizedDescription)")
    }
    
    func preFetch() {
        print("pre fetch")
    }
    
}

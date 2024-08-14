//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 14.08.2024.
//

import Foundation
import UIKit

final class CategoryViewController: UIViewController {
    private var categories: [String] = []
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Colors.buttonActive
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Добавить категорию", for: .normal)
        button.addTarget(self, action: #selector(addCategotyButtonTapped), for: .touchUpInside)
        return button
    }()
    private let stubImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "stub")
        return image
    }()
    
    private let stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelection = false
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: CategoryViewCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        setupUI()
        updateStubViewVisibility()
        updateTableViewHeight()
    }
    
    func updateStubViewVisibility() {
        let isEmpty = categories.isEmpty
        stubImageView.isHidden = !isEmpty
        stubLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    func reloadData() {
        tableView.reloadData()
        updateStubViewVisibility()
        updateTableViewHeight()
    }
    
    func updateTableViewHeight() {
        let cellHeight: CGFloat = 75.0
        let maxHeight = view.frame.height - addCategoryButton.frame.height - 32 - 24 - cellHeight
        let maxRows = Int(maxHeight / cellHeight)
        let visibleRows = min(categories.count, maxRows)
        tableViewHeightConstraint.constant = CGFloat(visibleRows) * cellHeight
        view.layoutIfNeeded()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        [addCategoryButton, stubImageView, stubLabel, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    @objc func addCategotyButtonTapped() {
        let newViewController = NewCategoryViewController()
        newViewController.navigationItem.title = "Новая Категория"
        newViewController.delegate = self
        navigationController?.isNavigationBarHidden = false
        
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Создание ячейки для строки: \(indexPath.row)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryViewCell", for: indexPath) as? CategoryViewCell else { return UITableViewCell() }
        
        cell.configureCell(title: categories[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let separatorTag = 1001
        if let separatorView = cell.contentView.viewWithTag(separatorTag) {
            separatorView.isHidden = indexPath.row >= categories.count - 1
        } else {
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor.separator
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            separatorView.tag = separatorTag
            cell.contentView.addSubview(separatorView)
            
            NSLayoutConstraint.activate([
                separatorView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                separatorView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                separatorView.heightAnchor.constraint(equalToConstant: 0.5),
                separatorView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
            separatorView.isHidden = indexPath.row >= categories.count - 1
        }
    }
}

extension CategoryViewController: NewCategoryViewControllerDelegate {
    func didAddCategory(name: String) {
        categories.append(name)
        reloadData()
    }
}

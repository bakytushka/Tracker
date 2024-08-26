//
//  FilterViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 22.08.2024.
//

import Foundation
import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filter: TrackerFilter)
}

final class FilterViewController: UIViewController {
    weak var delegate: FilterViewControllerDelegate?
    
    private let filterTitle = Constant.filterTitles
    private var filterTypes: [TrackerFilter] = [.all, .today, .completed, .uncompleted]
    var selectedFilter: TrackerFilter?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterCell")
        setupUI()
        setupNavigationBar()
    }
    
    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Фильтры"
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
        let title = filterTitle[indexPath.row]
        let isSelected = selectedFilter == filterTypes[indexPath.row]
        cell.configure(with: title, isSelected: isSelected)
        cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        if indexPath.row < filterTitle.count - 1 {
            separatorView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        } else {
            separatorView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
            separatorView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilter = filterTypes[indexPath.row]
        tableView.reloadData()
        delegate?.didSelectFilter(selectedFilter!)
        dismiss(animated: true)
    }
}

//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 30.06.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentСategories: [TrackerCategory] = []
    
    private var stubImageView = UIImageView()
    private var stubLabel = UILabel()
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.backgroundColor = UIColor.white
        setupNaviBar()
        setUpStubImage()
        setUpStubLabel()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    private func setUpStubImage() {
        stubImageView.image = UIImage(named: "stub")!
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stubImageView)
        
        NSLayoutConstraint.activate([
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    private func setupNaviBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.automaticallyShowsCancelButton = true
        navigationItem.searchController = searchController
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTracker))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    private func setUpStubLabel() {
        stubLabel.text = "Что будем отслеживать?"
        stubLabel.font = UIFont.systemFont(ofSize: 12)
        
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stubLabel)
        
        NSLayoutConstraint.activate([
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8)
        ])
    }
    
    @objc
    private func addTracker() {
    }
}

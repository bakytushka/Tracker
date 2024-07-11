//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 30.06.2024.
//

import Foundation
import UIKit

final class TrackersViewController: UIViewController {
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Птицы",
            trackers: [
                Tracker(id: UUID.init(), name: "Поливать растения", color: .red, emoji: "🤣", schedule: .friday),
                Tracker(id: UUID.init(), name: "Бабушка прислала открытку в вотсапе", color: .green, emoji: "❤️", schedule: .friday),
                Tracker(id: UUID.init(), name: "Кошла заслонила камеру на созвоне", color: .blue, emoji: "😎", schedule: .friday)
            ]),
        TrackerCategory(
            title: "Ящеры",
            trackers: [
                Tracker(id: UUID.init(), name: "Поливать растения", color: .red, emoji: "🤣", schedule: .friday),
                Tracker(id: UUID.init(), name: "Бабушка прислала открытку в вотсапе", color: .brown, emoji: "❤️", schedule: .friday),
                Tracker(id: UUID.init(), name: "Кошла заслонила камеру на созвоне", color: .blue, emoji: "😎", schedule: .friday)
            ]),
        TrackerCategory(
            title: "Новые",
            trackers: [
                Tracker(id: UUID.init(), name: "Поливать растения", color: .red, emoji: "🤣", schedule: .friday),
                Tracker(id: UUID.init(), name: "Бабушка прислала открытку в вотсапе", color: .green, emoji: "❤️", schedule: .friday),
                Tracker(id: UUID.init(), name: "Кошла заслонила камеру на созвоне", color: .gray, emoji: "😎", schedule: .friday)
            ])
    ]
    
    
    private var completedTrackers: [TrackerRecord] = []
    private var currentСategories: [TrackerCategory] = []
    
        private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
        /*  private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()*/
    
    private var stubImageView = UIImageView()
    private var stubLabel = UILabel()
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupNaviBar()
        //      collectionView.dataSource = self
        //       collectionView.delegate = self
        //       collectionView.register(TrackersViewCell.self, forCellWithReuseIdentifier: "cell")
        showPlugOrTracers()
        
    }
    
    private func showPlugOrTracers() {
        if categories.isEmpty {
            setUpStubLabel()
            setUpStubImage()
        } else {
            addTrecersCollectionView()
            setupTrecersCollectionView()
        }
    }
    
    private func addTrecersCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
        ])
    }
    
    private func setupTrecersCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        //  collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TrackersViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderViewController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        //v    collectionView.register(HeaderViewController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
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
    
    /*   private func setUpcollectionView() {
     /*     collectionView.dataSource = self
      collectionView.delegate = self
      collectionView.register(TrackersViewCell.self, forCellWithReuseIdentifier: "cell") */
     view.addSubview(collectionView)
     collectionView.translatesAutoresizingMaskIntoConstraints = false
     
     NSLayoutConstraint.activate([
     collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
     collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
     collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
     
     ])
     } */
    
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


extension TrackersViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackersViewCell else { return UICollectionViewCell() }
        cell.setupViews(tracker: categories[indexPath.section].trackers[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderViewController
        view.titleLabel.text = categories[indexPath.section].title
        return view
    }
    
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}


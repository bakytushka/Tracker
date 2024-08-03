//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 30.06.2024.
//

import Foundation
import UIKit

final class TrackersViewController: UIViewController {
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private var trackers = [Tracker]()
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentCategories: [TrackerCategory] = []
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private var stubImageView = UIImageView()
    private var stubLabel = UILabel()
    private var isSearching: Bool = false
    
    var currentDate: Date = Date()
    let datePicker = UIDatePicker()
    private var selectedWeekDay: WeekDay = .monday
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupNaviBar()
        setupTrackersCollectionView()
        setupStubImage()
        setupStubLabel()
        syncData()
        updateUI()
    }
    
    private func syncData() {
        trackerCategoryStore.delegate = self
        trackerStore.delegate = self
        fetchCategory()
        if !categories.isEmpty {
            currentCategories = categories
            collectionView.reloadData()
        }
        updateUI()
    }
    
    private func updateUI() {
        if currentCategories.isEmpty {
            showStub(isSearching: isSearching)
        } else {
            hideStub()
        }
        collectionView.reloadData()
    }
    
    private func showStub(isSearching: Bool) {
        stubLabel.text = isSearching ? "Ничего не найдено" : "Что будем отслеживать?"
        stubImageView.image = UIImage(named: isSearching ? "plug" : "stub")
        stubImageView.isHidden = false
        stubLabel.isHidden = false
        collectionView.isHidden = true
    }
    
    private func hideStub() {
        stubImageView.isHidden = true
        stubLabel.isHidden = true
        collectionView.isHidden = false
    }
    
    private func setupTrackersCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(TrackersViewCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collectionView.register(HeaderViewController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewController.reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupNaviBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.automaticallyShowsCancelButton = true
        navigationItem.searchController = searchController
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTrackerButton))
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
    
    private func setupStubImage() {
        stubImageView.image = UIImage(named: "stub")!
        
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stubImageView)
        
        NSLayoutConstraint.activate([
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupStubLabel() {
        stubLabel.text = "Что будем отслеживать?"
        stubLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stubLabel)
        
        NSLayoutConstraint.activate([
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8)
        ])
    }
    
    func addTracker(_ tracker: Tracker, to categoryIndex: Int) {
        do {
            var newCategories = categories
            if categoryIndex < newCategories.count {
                let categoryToUpdate = newCategories[categoryIndex]
                var updatedTrackers = categoryToUpdate.trackers
                updatedTrackers.append(tracker)
                let updatedCategory = TrackerCategory(
                    title: categoryToUpdate.title,
                    trackers: updatedTrackers
                )
                newCategories[categoryIndex] = updatedCategory
            } else {
                let newCategory = TrackerCategory(
                    title: "Новая категория",
                    trackers: [tracker]
                )
                newCategories.append(newCategory)
            }
            
            currentCategories = newCategories
            if try trackerCategoryStore.fetchCategories().filter({ $0.title == "Новая категория" }).isEmpty {
                let newCategoryCoreData = TrackerCategory(title: "Новая категория", trackers: [])
                try trackerCategoryStore.addNewCategory(newCategoryCoreData)
            }
            
            createCategoryAndTracker(tracker: tracker, with: "Новая категория")
            fetchCategory()
            collectionView.reloadData()
            updateUI()
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func filteredTrackers() {
        isSearching = true
        let calendar = Calendar.current
        let selectedWeekDay = calendar.component(.weekday, from: currentDate) - 1
        let selectedDayString = WeekDay(rawValue: selectedWeekDay)?.stringValue ?? ""
        
        currentCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return tracker.schedule.contains(selectedDayString)
            }
            return !filteredTrackers.isEmpty ? TrackerCategory(title: category.title, trackers: filteredTrackers) : nil
        }
        updateUI()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        isSearching = false
        filteredTrackers()
        updateUI()
    }
    
    @objc
    private func addTrackerButton() {
        let newViewController = NewTrackersViewController()
        newViewController.delegate = self
        newViewController.navigationItem.title = "Создание трекера"
        navigationController?.isNavigationBarHidden = false
        
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        currentCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCategories[section].trackers.count  //categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackersViewCell else {
            assertionFailure("Не удалось получить ячейку TrackerCollectionViewCell")
            return UICollectionViewCell()
        }
        
        guard indexPath.section < currentCategories.count else {
            assertionFailure("Индекс секции вне диапазона")
            return UICollectionViewCell()
        }
        
        let trackers = currentCategories[indexPath.section].trackers
        guard indexPath.row < trackers.count else {
            assertionFailure("Индекс строки вне диапазона")
            return UICollectionViewCell()
        }
        
        let tracker = currentCategories[indexPath.section].trackers[indexPath.row]
        cell.delegate = self
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter {
            $0.trackerID == tracker.id
        }.count
        
        cell.configure(
            with: tracker,
            trackerIsCompleted: isCompletedToday,
            completedDays: completedDays,
            indexPath: indexPath
        )
        
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.trackerID == id && isSameDay
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = HeaderViewController.reuseIdentifier
        default:
            return UICollectionReusableView()
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath
        ) as! HeaderViewController
        
        let title = currentCategories[indexPath.section].title
        view.setTitle(title)
        return view
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingSpace = CGFloat(9)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 148)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
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

extension TrackersViewController: TrackerViewCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        if currentDate <= Date() {
            let trackerRecord = TrackerRecord(trackerID: id, date: datePicker.date)
            completedTrackers.insert(trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        /*      if let trackerRecordToDelete = completedTrackers.first(where: { $0.trackerID == id }) {
         completedTrackers.remove(trackerRecordToDelete)
         collectionView.reloadItems(at: [indexPath])
         }
         */
        completedTrackers = completedTrackers.filter { trackerRecord in
            !isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func record(_ sender: Bool, _ cell: TrackersViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let id = currentCategories[indexPath.section].trackers[indexPath.row].id
        let newRecord = TrackerRecord(trackerID: id, date: currentDate)
        
        switch sender {
        case true:
            completedTrackers.insert(newRecord)
        case false:
            completedTrackers.remove(newRecord)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

extension TrackersViewController: NewTrackerViewControllerDelegate {
    func setDateForNewTracker() -> String {
        return dateFormatter.string(from: currentDate)
    }
    
    func didCreateNewTracker(_ tracker: Tracker) {
        addTracker(tracker, to: 0)
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func didUpdateCategories() {
        collectionView.reloadData()
    }
}

extension TrackersViewController {
    private func fetchCategory() {
        do {
            let coreDataCategories = try trackerCategoryStore.fetchCategories()
            categories = coreDataCategories.compactMap { coreDataCategory in
                trackerCategoryStore.updateTrackerCategory(coreDataCategory)
            }
            
            var trackers = [Tracker]()
            for currentCategories in currentCategories {
                for tracker in currentCategories.trackers {
                    let newTracker = Tracker(
                        id: tracker.id,
                        name: tracker.name,
                        color: tracker.color,
                        emoji: tracker.emoji,
                        schedule: tracker.schedule)
                    trackers.append(newTracker)
                }
            }
            
            self.trackers = trackers
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
    
    private func createCategoryAndTracker(tracker: Tracker, with titleCategory: String) {
        trackerCategoryStore.createCategoryAndTracker(tracker: tracker, with: titleCategory)
    }
}

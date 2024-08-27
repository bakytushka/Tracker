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
    private var originalCategories: [UUID: String] = [:]
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private var stubImageView = UIImageView()
    private var stubLabel = UILabel()
    private var isSearching: Bool = false
    
    private var currentFilter: TrackerFilter = .all
    var currentDate: Date = Date()
    let datePicker = UIDatePicker()
    private var selectedWeekDay: WeekDay = .monday
    private let filterButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        setupNaviBar()
        setupTrackersCollectionView()
        setupStubImage()
        setupStubLabel()
        setupFilterButton()
        syncData()
        updateUI()
        loadCompletedTrackers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsService.shared.logEvent("open")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AnalyticsService.shared.logEvent("close")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            collectionView.backgroundColor = UIColor(named: "BackgroundColor")
        }
    }
    
    private func syncData() {
        trackerCategoryStore.delegate = self
        trackerStore.delegate = self
        fetchCategory()
        currentCategories = categories.filter { !$0.trackers.isEmpty }
        collectionView.reloadData()
        updateUI()
    }
    
    private func loadCompletedTrackers() {
        do {
            completedTrackers = try trackerRecordStore.fetchTrackerRecords()
            collectionView.reloadData()
        } catch {
            print("Error loading completed trackers: \(error)")
        }
    }
    
    private func saveCompletedTracker(_ trackerRecord: TrackerRecord) {
        do {
            try trackerRecordStore.addTrackerRecord(from: trackerRecord)
        } catch {
            print("Error saving completed tracker: \(error)")
        }
    }
    
    private func removeCompletedTracker(_ trackerRecord: TrackerRecord) {
        do {
            try trackerRecordStore.deleteTrackerRecord(trackerRecord: trackerRecord)
        } catch {
            print("Error removing completed tracker: \(error)")
        }
    }
    
    private func updateUI() {
        currentCategories = currentCategories.filter { !$0.trackers.isEmpty }
        if currentCategories.isEmpty {
            filterButton.isHidden = true
            showStub(isSearching: isSearching)
        } else {
            filterButton.isHidden = false
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
    
    private func setupFilterButton() {
        filterButton.setTitle(NSLocalizedString("Filters", comment: "Title for the filter button"), for: .normal)
        filterButton.setTitleColor(.white, for: .normal)
        filterButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        filterButton.backgroundColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1.0)
        filterButton.layer.cornerRadius = 16
        filterButton.layer.masksToBounds = true
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 115),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTrackersCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.register(TrackersViewCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collectionView.register(HeaderViewController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewController.reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(named: "BackgroundColor")
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupNaviBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = NSLocalizedString("Trackers", comment: "Title for the main screen")
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTrackerButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.label
        
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        setupDatePickerAppearance(datePicker)
    }
    
    private func setupDatePickerAppearance(_ datePicker: UIDatePicker) {
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        let textFieldInsideDatePicker = (
            datePicker.subviews[0].subviews[0].subviews[0] as? UITextField
        )
        textFieldInsideDatePicker?.textColor = UIColor.black
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
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) {
        do {
            var newCategories = currentCategories
            if let categoryIndex = newCategories.firstIndex(where: { $0.title == category.title }) {
                var updatedTrackers = newCategories[categoryIndex].trackers
                updatedTrackers.append(tracker)
                let updatedCategory = TrackerCategory(
                    title: category.title,
                    trackers: updatedTrackers
                )
                newCategories[categoryIndex] = updatedCategory
            } else {
                let newCategory = TrackerCategory(
                    title: category.title,
                    trackers: [tracker]
                )
                newCategories.append(newCategory)
                if try trackerCategoryStore.fetchCategories().filter({ $0.title == category.title }).isEmpty {
                    try trackerCategoryStore.addNewCategory(newCategory)
                }
            }
            
            currentCategories = newCategories
            createCategoryAndTracker(tracker: tracker, with: category.title)
            fetchCategory()
            collectionView.reloadData()
            updateUI()
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func searchTrackers(with searchText: String) {
        if searchText.isEmpty {
            applyFilter()
            return
        }
        
        currentCategories = categories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.name.lowercased().contains(searchText.lowercased())
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        
        updateStubVisibility(isSearching: !searchText.isEmpty)
        collectionView.reloadData()
    }
    
    private func updateStubVisibility(isSearching: Bool) {
        let hasResults = !currentCategories.isEmpty
        if hasResults {
            hideStub()
        } else {
            showStub(isSearching: isSearching)
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        if currentFilter == .today {
            currentFilter = .all
        }
        applyFilter()
        updateUI()
    }
    
    @objc
    private func filterButtonTapped() {
        AnalyticsService.shared.logEvent("click", item: "filter")
        let filterViewController = FilterViewController()
        filterViewController.delegate = self
        filterViewController.selectedFilter = currentFilter
        let filterNavController = UINavigationController(rootViewController: filterViewController)
        self.present(filterNavController, animated: true)
    }
    
    @objc
    private func addTrackerButton() {
        AnalyticsService.shared.logEvent("click", item: "add_track")
        let newViewController = NewTrackersViewController()
        newViewController.delegate = self
        newViewController.navigationItem.title = "Создание трекера"
        navigationController?.isNavigationBarHidden = false
        
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func deleteTracker(trackerId: UUID) {
        trackerStore.deleteTracker(trackerId: trackerId)
        syncData()
    }
    
    func isTrackerPinned(at indexPath: IndexPath) -> Bool {
        return currentCategories[indexPath.section].title == "Закрепленные"
    }
    
    func unpinTracker(at indexPath: IndexPath) {
        let tracker = currentCategories[indexPath.section].trackers[indexPath.row]
        try? trackerCategoryStore.deleteTrackerFromCategory(tracker: tracker, from: "Закрепленные")
        if let originalCategory = originalCategories[tracker.id] {
            try? trackerCategoryStore.addNewTrackerToCategory(tracker, to: originalCategory)
            originalCategories.removeValue(forKey: tracker.id)
        }
        syncData()
    }
    
    private func pinTracker(_ tracker: Tracker, from category: String) {
        try? trackerCategoryStore.deleteTrackerFromCategory(tracker: tracker, from: category)
        originalCategories[tracker.id] = category
        try? trackerCategoryStore.addNewTrackerToCategory(tracker, to: "Закрепленные")
        syncData()
    }
    
    func togglePinTracker(tracker: Tracker, at indexPath: IndexPath) {
        if isTrackerPinned(at: indexPath) {
            unpinTracker(at: indexPath)
        } else {
            let currentCategory = currentCategories[indexPath.section]
            pinTracker(tracker, from: currentCategory.title)
        }
        syncData()
    }
    
    func editTracker(at indexPath: IndexPath) {
        let vc = NewHabitViewController()
        vc.delegate = self
        let tracker = self.currentCategories[indexPath.section].trackers[indexPath.row]
        vc.categoryName = self.currentCategories[indexPath.section].title
        vc.selectedCategory = self.currentCategories[indexPath.section]
        vc.setupEditTracker(tracker: tracker)
        vc.isEditingTracker = true
        vc.navigationItem.title = "Редактирование привычки"
        navigationController?.isNavigationBarHidden = false
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        currentCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCategories[section].trackers.count
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
        
        cell.didTapPin = { [weak self] in
            guard let self = self else { return }
            let tracker = self.currentCategories[indexPath.section].trackers[indexPath.row]
            self.togglePinTracker(tracker: tracker, at: indexPath)
        }
        
        cell.didTapDelete = { [weak self] in
            let alert = UIAlertController(
                title: "Уверены, что хотите удалить трекер?",
                message: nil, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(
                title: "Удалить",
                style: .destructive
            ) { [weak self] _ in
                guard let self = self else { return }
                let tracker = self.currentCategories[indexPath.section].trackers[indexPath.row]
                self.deleteTracker(trackerId: tracker.id)
            }
            
            let cancelAction = UIAlertAction(
                title: "Отмена", style: .cancel
            )
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self?.present(alert, animated: true)
        }
        
        cell.didTapEdit = { [weak self] in
            self?.editTracker(at: indexPath)
        }
        
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
            saveCompletedTracker(trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers = completedTrackers.filter { trackerRecord in
            !isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        
        let trackerRecord = TrackerRecord(trackerID: id, date: datePicker.date)
        removeCompletedTracker(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func record(_ sender: Bool, _ cell: TrackersViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let id = currentCategories[indexPath.section].trackers[indexPath.row].id
        let newRecord = TrackerRecord(trackerID: id, date: currentDate)
        
        switch sender {
        case true:
            completedTrackers.insert(newRecord)
            do {
                try trackerRecordStore.addTrackerRecord(from: newRecord)
            } catch {
                print("Failed to save tracker record: \(error)")
            }
        case false:
            completedTrackers.remove(newRecord)
            do {
                try trackerRecordStore.deleteTrackerRecord(trackerRecord: newRecord)
            } catch {
                print("Failed to delete tracker record: \(error)")
            }
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

extension TrackersViewController: NewTrackerViewControllerDelegate {
    func setDateForNewTracker() -> String {
        return dateFormatter.string(from: currentDate)
    }
    
    func didCreateNewTracker(_ tracker: Tracker, _ category: TrackerCategory) {
        addTracker(tracker, to: category)
    }
    
    func didEditTracker(_ tracker: Tracker, _ newCategory: TrackerCategory) {
        var updatedCategories = currentCategories
        var oldCategoryIndex: Int?
        var oldTrackerIndex: Int?
        
        for (categoryIndex, category) in updatedCategories.enumerated() {
            if let trackerIndex = category.trackers.firstIndex(where: { $0.id == tracker.id }) {
                oldCategoryIndex = categoryIndex
                oldTrackerIndex = trackerIndex
                break
            }
        }
        
        if let oldCategoryIndex = oldCategoryIndex, let oldTrackerIndex = oldTrackerIndex {
            let oldCategory = updatedCategories[oldCategoryIndex]
            var updatedTrackers = oldCategory.trackers
            updatedTrackers.remove(at: oldTrackerIndex)
            
            if updatedTrackers.isEmpty {
                updatedCategories.remove(at: oldCategoryIndex)
            } else {
                let updatedCategory = TrackerCategory(
                    title: oldCategory.title,
                    trackers: updatedTrackers
                )
                updatedCategories[oldCategoryIndex] = updatedCategory
            }
        }
        
        if let newCategoryIndex = updatedCategories.firstIndex(where: { $0.title == newCategory.title }) {
            let category = updatedCategories[newCategoryIndex]
            var updatedTrackers = category.trackers
            updatedTrackers.append(tracker)
            let updatedCategory = TrackerCategory(
                title: category.title,
                trackers: updatedTrackers
            )
            updatedCategories[newCategoryIndex] = updatedCategory
        } else {
            updatedCategories.append(newCategory)
        }
        
        if trackerStore.updateTracker(tracker) != nil {
            if let oldCategoryIndex = oldCategoryIndex {
                let oldCategoryTitle = currentCategories[oldCategoryIndex].title
                try? trackerCategoryStore.deleteTrackerFromCategory(tracker: tracker, from: oldCategoryTitle)
            }
            
            try? trackerCategoryStore.addNewTrackerToCategory(tracker, to: newCategory.title)
        }
        
        currentCategories = updatedCategories
        collectionView.reloadData()
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

extension TrackersViewController {
    private func applyFilter() {
        let calendar = Calendar.current
        let selectedWeekDay = calendar.component(.weekday, from: currentDate) - 1
        let selectedDayString = WeekDay(rawValue: selectedWeekDay)?.stringValue ?? ""
        
        currentCategories = categories.compactMap { category in
            let filteredTrackers: [Tracker]
            
            switch currentFilter {
            case .all:
                filteredTrackers = category.trackers.filter { tracker in
                    return tracker.schedule.contains(selectedDayString)
                }
            case .today:
                datePicker.date = Date()
                let todayWeekDay = calendar.component(.weekday, from: datePicker.date) - 1
                let todayDayString = WeekDay(rawValue: todayWeekDay)?.stringValue ?? ""
                
                filteredTrackers = category.trackers.filter { tracker in
                    return tracker.schedule.contains(todayDayString)
                }
            case .completed:
                filteredTrackers = category.trackers.filter { tracker in
                    let trackerCompleted = completedTrackers.contains { $0.trackerID == tracker.id && calendar.isDate($0.date, inSameDayAs: currentDate) }
                    return trackerCompleted && tracker.schedule.contains(selectedDayString)
                }
            case .uncompleted:
                filteredTrackers = category.trackers.filter { tracker in
                    let trackerCompleted = completedTrackers.contains { $0.trackerID == tracker.id && calendar.isDate($0.date, inSameDayAs: currentDate) }
                    return !trackerCompleted && tracker.schedule.contains(selectedDayString)
                }
            }
            
            return !filteredTrackers.isEmpty ? TrackerCategory(title: category.title, trackers: filteredTrackers) : nil
        }
        updateUI()
    }
}

extension TrackersViewController: FilterViewControllerDelegate {
    func didSelectFilter(_ filter: TrackerFilter) {
        currentFilter = filter
        applyFilter()
    }
}

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        searchTrackers(with: searchText)
    }
}
extension TrackersViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchTrackers(with: "")
        updateUI()
    }
}

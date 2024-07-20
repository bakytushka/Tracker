//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 30.06.2024.
//


 import Foundation
import UIKit

final class TrackersViewController: UIViewController {
    
    private var categories: [TrackerCategory] = []
    /*       TrackerCategory(
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
     ] */
    
    private var completedTrackers: [TrackerRecord] = []
    private var currentСategories: [TrackerCategory] = []
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private var stubImageView = UIImageView()
    private var stubLabel = UILabel()
    
    var currentDate: Date = Date()
    //   private var selectedWeekDay: WeekDay = .Monday
    //  private var selectedWeekDay: WeekDay = .Monday
    private var selectedWeekDay: WeekDay = .none
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupNaviBar()
        showStubOrTrackers()
        
        updateUI()
    }
    
    private func showStubOrTrackers() {
        if categories.isEmpty {
            setUpStubImage()
            setupStubLabel()
            
        } else {
            setupTreckersCollectionView()
        }
    }
    
    private func setupTreckersCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(TrackersViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderViewController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
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
    
    private func setUpStubImage() {
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
        stubLabel.font = UIFont.systemFont(ofSize: 12)
        
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stubLabel)
        
        NSLayoutConstraint.activate([
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8)
        ])
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
    }
    /*     let selectedDate = sender.date
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "dd.MM.yyyy"
     let formattedDate = dateFormatter.string(from: selectedDate)
     print("Выбранная дата: \(formattedDate)")
     
     currentDate = sender.date
     
     
     selectedWeekDay = calculateDayOfWeak(date: sender.date)
     currentСategories = calculateArrayOfWeak(weak: selectedWeekDay, categories: categories)
     
     
     showStubOrTrackers()
     } */
    
    /*   func calculateArrayOfWeak(weak: WeekDay, categories: [TrackerCategory]) -> [TrackerCategory] {
     var resultArray = [TrackerCategory]()
     for category in categories {
     var resultTracersInCategory = [Tracker]()
     for tracer in category.trackers {
     for i in tracer.schedule {
     if i == weak || i == .none {
     resultTracersInCategory.append(tracer)
     }
     }
     }
     if !resultTracersInCategory.isEmpty {
     let resultOfCategory = TrackerCategory(title: category.title, trackers: resultTracersInCategory)
     resultArray.append(resultOfCategory)
     }
     }
     return resultArray
     } */
    
    
    /*      private func calculateDayOfWeak(date: Date) -> WeekDay {
     let selectedDate = date
     let calendar = Calendar.current
     let weekday = calendar.component(.weekday, from: selectedDate)
     switch weekday {
     case 1:
     return .sunday
     case 2:
     return .monday
     case 3:
     return .tuesday
     case 4:
     return .wednesday
     case 5:
     return .thursday
     case 6:
     return .friday
     case 7:
     return .saturday
     default:
     print("Ошибка получения дня недели")
     return .none
     }
     } */
    
    
    @objc
    private func addTrackerButton() {
        let newViewController = NewTrackersViewController()
        newViewController.delegate = self
        newViewController.navigationItem.title = "Создание трекера"
        navigationController?.isNavigationBarHidden = false
        
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func addTracker(_ tracker: Tracker, to categoryIndex: Int) {
        if categoryIndex < categories.count {
            categories[categoryIndex].trackers.append(tracker)
        } else {
            let newCategory = TrackerCategory(title: "Новая категория", trackers: [tracker])
            categories.append(newCategory)
        }
        currentСategories = categories
        updateUI()
    }
    
    private func updateUI() {
        if currentСategories.isEmpty {
            stubImageView.isHidden = false
            stubLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            stubImageView.isHidden = true
            stubLabel.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        }
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

extension TrackersViewController: NewTrackerViewControllerDelegate {
    func setDateForNewTracker() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: currentDate)
    }
    
    func didCreateNewTracker(_ tracker: Tracker) {
        addTracker(tracker, to: 0)
    }
}



/*

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
 Tracker(id: UUID(), name: "Поливать растения", color: .red, emoji: "🤣", schedule: .friday),
 Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапе", color: .green, emoji: "❤️", schedule: .friday),
 Tracker(id: UUID(), name: "Кошла заслонила камеру на созвоне", color: .blue, emoji: "😎", schedule: .friday)
 ]
 ),
 TrackerCategory(
 title: "Ящеры",
 trackers: [
 Tracker(id: UUID(), name: "Поливать растения", color: .red, emoji: "🤣", schedule: .friday),
 Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапе", color: .brown, emoji: "❤️", schedule: .friday),
 Tracker(id: UUID(), name: "Кошла заслонила камеру на созвоне", color: .blue, emoji: "😎", schedule: .friday)
 ]
 ),
 TrackerCategory(
 title: "Новые",
 trackers: [
 Tracker(id: UUID(), name: "Поливать растения", color: .red, emoji: "🤣", schedule: .friday),
 Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапе", color: .green, emoji: "❤️", schedule: .friday),
 Tracker(id: UUID(), name: "Кошла заслонила камеру на созвоне", color: .gray, emoji: "😎", schedule: .friday)
 ]
 )
 ]
 
 private var completedTrackers: [TrackerRecord] = []
 private var currentCategories: [TrackerCategory] = []
 
 private lazy var collectionView: UICollectionView = {
 let layout = UICollectionViewFlowLayout()
 let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
 collectionView.dataSource = self
 collectionView.delegate = self
 collectionView.register(TrackersViewCell.self, forCellWithReuseIdentifier: "cell")
 collectionView.register(HeaderViewController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
 collectionView.translatesAutoresizingMaskIntoConstraints = false
 return collectionView
 }()
 
 private lazy var stubImageView: UIImageView = {
 let imageView = UIImageView(image: UIImage(named: "stub"))
 imageView.translatesAutoresizingMaskIntoConstraints = false
 return imageView
 }()
 
 private lazy var stubLabel: UILabel = {
 let label = UILabel()
 label.text = "Что будем отслеживать?"
 label.font = UIFont.systemFont(ofSize: 12)
 label.translatesAutoresizingMaskIntoConstraints = false
 return label
 }()
 
 private lazy var datePicker: UIDatePicker = {
 let datePicker = UIDatePicker()
 datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
 datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
 datePicker.preferredDatePickerStyle = .compact
 datePicker.datePickerMode = .date
 datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
 return datePicker
 }()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 view.backgroundColor = .white
 setupNavigationBar()
 showStubOrTrackers()
 }
 
 private func showStubOrTrackers() {
 if categories.isEmpty {
 setupStubView()
 } else {
 setupTrackersCollectionView()
 }
 }
 
 private func setupTrackersCollectionView() {
 view.addSubview(collectionView)
 NSLayoutConstraint.activate([
 collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
 collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
 collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
 collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
 ])
 }
 
 private func setupStubView() {
 view.addSubview(stubImageView)
 view.addSubview(stubLabel)
 NSLayoutConstraint.activate([
 stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
 stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
 stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
 stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8)
 ])
 }
 
 private func setupNavigationBar() {
 navigationController?.navigationBar.prefersLargeTitles = true
 navigationItem.title = "Трекеры"
 
 let searchController = UISearchController(searchResultsController: nil)
 searchController.automaticallyShowsCancelButton = true
 navigationItem.searchController = searchController
 
 navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
 navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTracker))
 navigationItem.leftBarButtonItem?.tintColor = .black
 }
 
 @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
 let dateFormatter = DateFormatter()
 dateFormatter.dateFormat = "dd.MM.yyyy"
 let formattedDate = dateFormatter.string(from: sender.date)
 print("Выбранная дата: \(formattedDate)")
 }
 
 @objc private func addTracker() {
 let newViewController = NewTrackersViewController()
 newViewController.navigationItem.title = "Создание трекера"
 
 let navigationController = UINavigationController(rootViewController: newViewController)
 present(navigationController, animated: true, completion: nil)
 }
 }
 
 extension TrackersViewController: UICollectionViewDataSource {
 func numberOfSections(in collectionView: UICollectionView) -> Int {
 return categories.count
 }
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 return categories[section].trackers.count
 }
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackersViewCell else {
 return UICollectionViewCell()
 }
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
 } */

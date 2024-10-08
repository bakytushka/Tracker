//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 12.07.2024.
//

import Foundation
import UIKit

final class NewHabitViewController: UIViewController, UITextFieldDelegate {
    weak var delegate: NewTrackerViewControllerDelegate?
    
    private let trackerType: TrackerType = .habit
    private var schedule: [String] = []
    
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    var selectedDays: [WeekDay: Bool] = [:]
    
    private let nameTextField = UITextField()
    private let maxLength = 38
    
    private let tableView = UITableView()
    private let categories = ["Категория", "Расписание"]
    
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    var isEditingTracker = false
    private var editedTracker: Tracker?
    
    var selectedCategory: TrackerCategory? {
        didSet {
            if let category = selectedCategory {
                categoryName = category.title
                tableView.reloadData()
            }
        }
    }
    
    var categoryName: String = "" {
        didSet {
            if !categoryName.isEmpty {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        addTapGestureToHideKeyboard()
        updateCreateButtonState()
    }
    
    private func setupUI() {
        setupScrollView()
        setupCollectionView()
        setupTextField()
        setupTableView()
        setupCancelButton()
        setupCreateButton()
        setupConstraints()
    }
    
    private func setupTextField(){
        nameTextField.delegate = self
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.backgroundColor = Colors.textFieldBackground
        nameTextField.layer.cornerRadius = 16
        nameTextField.textColor = .black
        nameTextField.borderStyle = .none
        nameTextField.layer.masksToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTextField.frame.height))
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .always
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        
        tableView.register(NewHabitTableViewCell.self, forCellReuseIdentifier: NewHabitTableViewCell.reuseIdentifier)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 5
        let lineSpacing: CGFloat = 0
        
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = lineSpacing
        collectionView.collectionViewLayout = layout
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(NewTrackerCollectionViewCell.self, forCellWithReuseIdentifier: NewTrackerCollectionViewCell.reuseIdentifier)
        collectionView.register(NewTrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NewTrackerHeaderView.reuseIdentifier)
    }
    
    private func setupCancelButton() {
        cancelButton.setTitleColor(Colors.cancelButtonColor, for: .normal)
        cancelButton.layer.borderColor = Colors.cancelButtonColor.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 16
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupCreateButton(){
        createButton.backgroundColor = Colors.buttonInactive
        createButton.layer.cornerRadius = 16
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        let title = isEditingTracker ? "Сохранить" : "Создать"
        createButton.setTitle(title, for: .normal)
        createButton.isEnabled = false
        createButton.addTarget(
            self,
            action: #selector(createButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupScrollView() {
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        [nameTextField, tableView, collectionView, createButton, cancelButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 27),
            nameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 476),
            
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor,constant: 10),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            
            createButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            createButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor,constant: 10),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
        ])
        containerView.layoutIfNeeded()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= maxLength
    }
    
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupEditTracker(tracker: Tracker) {
        isEditingTracker = true
        editedTracker = tracker
        nameTextField.text = tracker.name
        schedule = tracker.schedule
        selectedEmoji = tracker.emoji
        selectedColor = tracker.color
        selectedDays = [:]
        
        for day in tracker.schedule {
            if let weekDay = WeekDay.from(string: day) {
                selectedDays[weekDay] = true
            }
        }
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    private func updateCreateButtonState() {
        let isNameTextFieldNotEmpty = !(nameTextField.text?.isEmpty ?? true)
        let isCategorySelected = categoryName != ""
        let isScheduleSelected = !selectedDays.isEmpty && selectedDays.values.contains(true)
        let isEmojiSelected = selectedEmoji != nil
        let isColorSelected = selectedColor != nil
        
        let shouldEnableCreateButton = isNameTextFieldNotEmpty &&
        isCategorySelected &&
        isScheduleSelected &&
        isEmojiSelected &&
        isColorSelected
        
        createButton.isEnabled = shouldEnableCreateButton
        createButton.backgroundColor = shouldEnableCreateButton ? .black : Colors.buttonInactive
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateCreateButtonState()
    }
    
    @objc private func cancelButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonTapped() {
        guard let newTrackerName = nameTextField.text else { return }
        guard let date = delegate?.setDateForNewTracker() else { return }
        var newTrackerSchedule: [String] = []
        
        switch trackerType {
        case .habit:
            if selectedDays.values.contains(true) {
                newTrackerSchedule = selectedDays.filter { $0.value }.map { $0.key.stringValue }
            }
        case .event:
            newTrackerSchedule = [date]
        }
        
        if isEditingTracker, let editedTracker = editedTracker {
            let updatedTracker = Tracker(
                id: editedTracker.id,
                name: newTrackerName,
                color: selectedColor ?? editedTracker.color,
                emoji: selectedEmoji ?? editedTracker.emoji,
                schedule: newTrackerSchedule
            )
            let updatedCategory = TrackerCategory(
                title: categoryName,
                trackers: [updatedTracker]
            )
            delegate?.didEditTracker(updatedTracker, updatedCategory)
        } else {
            let newTracker = Tracker(
                id: UUID(),
                name: newTrackerName,
                color: selectedColor ?? .orange,
                emoji: selectedEmoji ?? Constant.randomEmoji(),
                schedule: newTrackerSchedule
            )
            let newCategory = TrackerCategory(title: categoryName, trackers: [newTracker])
            delegate?.didCreateNewTracker(newTracker, newCategory)
        }
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

extension NewHabitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewHabitTableViewCell", for: indexPath) as? NewHabitTableViewCell else {
            return UITableViewCell()
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.setTitle(categories[indexPath.row])
        
        if indexPath.row == 0 {
            cell.setSelectedDays(categoryName)
        } else if indexPath.row == 1 {
            let selectedDaysArray = selectedDays.filter { $0.value }.map { $0.key }
            if selectedDaysArray.isEmpty {
                cell.setSelectedDays("")
            } else if selectedDaysArray.count == WeekDay.allCases.count {
                cell.setSelectedDays("Каждый день")
            } else {
                let selectedDaysString = selectedDaysArray.map { $0.stringValue }.joined(separator: ", ")
                cell.setSelectedDays(selectedDaysString)
            }
        } else {
            cell.setSelectedDays("")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController: UIViewController
        let title: String
        
        switch indexPath.row {
        case 0:
            let trackerCategoryStore = TrackerCategoryStore()
            let categoryViewModel = CategoryViewModel(categoryStore: trackerCategoryStore)
            categoryViewModel.delegate = self
            let categoryVC = CategoryViewController(viewModel: categoryViewModel)
            viewController = categoryVC
            title = "Категория"
        case 1:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.selectedDays = selectedDays
            scheduleViewController.delegate = self
            viewController = scheduleViewController
            title = "Расписание"
        default:
            return
        }
        
        viewController.navigationItem.title = title
        navigationController?.isNavigationBarHidden = false
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
        
        updateCreateButtonState()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

extension NewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Constant.emojies.count
        case 1:
            return Constant.colorSelection.count
        default:
            return 18
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewTrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? NewTrackerCollectionViewCell else {
            assertionFailure("Не удалось получить ячейку NewTrackerCollectionViewCell")
            return UICollectionViewCell()
        }
        
        switch indexPath.section {
        case 0:
            let emoji = Constant.emojies[indexPath.row]
            cell.setEmoji(emoji)
            if emoji == selectedEmoji {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        case 1:
            if let color = Constant.colorSelection[indexPath.row] {
                cell.setColor(color)
                cell.isSelected = (color == selectedColor)
                if color == selectedColor {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                }
            }
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = NewTrackerHeaderView.reuseIdentifier
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath
        ) as? NewTrackerHeaderView else {
            assertionFailure("Не удалось получить header NewTrackerSupplementaryView")
            return UICollectionReusableView()
        }
        
        let title = Constant.collectionViewTitles[indexPath.section]
        view.setTitle(title)
        
        return view
    }
}

extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        let targetSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingCompressedSize.height)
        
        return headerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 6
        let spacing: CGFloat = 5
        
        let totalSpacing = (itemsPerRow - 1) * spacing
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / itemsPerRow
        
        let itemSize = max(itemWidth, 0)
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension NewHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForVisibleItems.filter({
            $0.section == indexPath.section
        }).forEach({
            collectionView.deselectItem(at: $0, animated: true)
        })
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedEmoji = Constant.emojies[indexPath.row]
        case 1:
            selectedColor = Constant.colorSelection[indexPath.row]
        default:
            break
        }
        updateCreateButtonState()
    }
}

extension NewHabitViewController: ScheduleViewControllerDelegate {
    func didSelectDays(_ days: [WeekDay: Bool]) {
        selectedDays = days
        tableView.reloadData()
        updateCreateButtonState()
    }
}

extension NewHabitViewController: CategorySelectionDelegate {
    func didSelectCategory(_ category: String) {
        categoryName = category
        tableView.reloadData()
        updateCreateButtonState()
    }
}

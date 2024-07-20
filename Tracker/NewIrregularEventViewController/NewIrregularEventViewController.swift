//
//  NewIrregularEventViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 13.07.2024.
//

import Foundation
import UIKit

final class NewIrregularEventViewController: UIViewController, UITextFieldDelegate {
    private let nameTextField = UITextField()
    let maxLength = 38
    
    private let tableView = UITableView()
    private let categories = ["Категория"]
    
    
    weak var delegate: NewTrackerViewControllerDelegate?
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setUpScrollView()
        setUpTextField()
        setUpTableView()
        setUpCancelButton()
        setUpCreateButton()
        setupUI()
        setupCollectionView()
    }
    
    func setUpTextField(){
        nameTextField.delegate = self
        //       view.addSubview(nameTextField)
        
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        nameTextField.layer.cornerRadius = 16
        nameTextField.textColor = .black
        nameTextField.borderStyle = .none
        nameTextField.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTextField.frame.height))
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .always
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        /*       nameTextField.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
         nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
         nameTextField.widthAnchor.constraint(equalToConstant: 343),
         nameTextField.heightAnchor.constraint(equalToConstant: 75),
         nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
         ]) */
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.register(NewHabitTableViewCell.self, forCellReuseIdentifier: NewHabitTableViewCell.reuseIdentifier)
        
        /*       tableView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(tableView)
         
         NSLayoutConstraint.activate([
         tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
         tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         tableView.heightAnchor.constraint(equalToConstant: 75)
         ]) */
    }
    
    private func setupCollectionView() {
        collectionView.register(
            NewTrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: NewTrackerCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            NewTrackerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NewTrackerHeaderView.reuseIdentifier
        )
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setUpCancelButton() {
        
        let customColor = UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1.0) // #F56B6C
        cancelButton.setTitleColor(customColor, for: .normal)
        cancelButton.layer.borderColor = customColor.cgColor // Преобразование UIColor в CGColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 16
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
        
        /*      cancelButton.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(cancelButton)
         
         NSLayoutConstraint.activate([
         cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         cancelButton.heightAnchor.constraint(equalToConstant: 60),
         cancelButton.widthAnchor.constraint(equalToConstant: 166),
         cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         
         ]) */
    }
    
    private func setUpCreateButton(){
        createButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        createButton.layer.cornerRadius = 16
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.setTitle("Создать", for: .normal)
        createButton.isEnabled = false
        createButton.addTarget(
            self,
            action: #selector(createButtonTapped),
            for: .touchUpInside
        )
        
        /*       createButton.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(createButton)
         
         NSLayoutConstraint.activate([
         createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         createButton.heightAnchor.constraint(equalToConstant: 60),
         createButton.widthAnchor.constraint(equalToConstant: 166),
         createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8)
         
         ]) */
    }
    
    
    private func setUpScrollView() {
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    
    
    private func setupUI() {
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
            nameTextField.widthAnchor.constraint(equalToConstant: 343),
            
            
            tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 75),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 476),
            
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor,constant: 10),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
     //       createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            createButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor,constant: 10),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        
        return updatedText.count <= maxLength
    }
    
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // Проверяем, есть ли текст в поле
        let hasText = !(textField.text?.isEmpty ?? true)
        // Активируем или деактивируем кнопку в зависимости от наличия текста
        createButton.isEnabled = hasText
        // Меняем цвет кнопки в зависимости от состояния
        createButton.backgroundColor = hasText ? .white : UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0) // #AEAFB4
    }
    
    @objc func cancelButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonTapped() {
        print("кнопка нажата")
        guard let newTrackerName = nameTextField.text else { return }
        let newTracker = Tracker(
            id: UUID(),
            name: newTrackerName,
            color: selectedColor ?? .systemPink,
            emoji: selectedEmoji ?? Constant.randomEmoji(),
            schedule: []
        )
        delegate?.didCreateNewTracker(newTracker)
        dismiss(animated: true)
    }
}

extension NewIrregularEventViewController: UITableViewDataSource, UITableViewDelegate {
    // Количество строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // Настройка ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewHabitTableViewCell", for: indexPath) as? NewHabitTableViewCell else {
            return UITableViewCell()
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.label.text = categories[indexPath.row]
        return cell
    }
    
    // Обработка выбора ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Логика перехода на другой экран или отображения деталей
        print("Selected \(categories[indexPath.row])")
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

extension NewIrregularEventViewController: UICollectionViewDataSource {
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
            assertionFailure("Unable to dequeue NewTrackerCollectionViewCell")
            return UICollectionViewCell()
        }
        
        switch indexPath.section {
        case 0:
            cell.setEmoji(Constant.emojies[indexPath.row])
        default:
            if let color = Constant.colorSelection[indexPath.row] {
                cell.setColor(color)
            }
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
            assertionFailure("Unable to dequeue NewTrackerSupplementaryView")
            return UICollectionReusableView()
        }
        
        let title = Constant.collectionViewTitles[indexPath.section]
        view.setTitle(title)
        
        return view
    }
}

extension NewIrregularEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: 34),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension NewIrregularEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForVisibleItems.filter({
            $0.section == indexPath.section
        }).forEach({
            collectionView.deselectItem(at: $0, animated: true)
        })
        return true
    }
    
}


/*
 
 import Foundation
 import UIKit

 final class NewIrregularEventViewController: UIViewController, UITextFieldDelegate {
     private let nameTextField = UITextField()
     let maxLength = 38
     
     private let tableView = UITableView()
     private let categories = ["Категория"]
     
     weak var delegate: NewTrackerViewControllerDelegate?
     private var selectedColor: UIColor?
     private var selectedEmoji: String?
     
     private let cancelButton = UIButton()
     private let createButton = UIButton()
     
     private let scrollView = UIScrollView()
     private let containerView = UIView()
     
     private let collectionView = UICollectionView(
         frame: .zero,
         collectionViewLayout: UICollectionViewFlowLayout()
     )
     
     override func viewDidLoad() {
         view.backgroundColor = .white
         setUpScrollView()
         setUpTextField()
         setUpTableView()
         setUpCancelButton()
         setUpCreateButton()
         setupUI()
         setupCollectionView()
     }
     
     func setUpTextField(){
         nameTextField.delegate = self
         //       view.addSubview(nameTextField)
         
         nameTextField.placeholder = "Введите название трекера"
         nameTextField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
         nameTextField.layer.cornerRadius = 16
         nameTextField.textColor = .black
         nameTextField.borderStyle = .none
         nameTextField.layer.masksToBounds = true
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTextField.frame.height))
         nameTextField.leftView = paddingView
         nameTextField.leftViewMode = .always
         nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
         
         /*       nameTextField.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
          nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
          nameTextField.widthAnchor.constraint(equalToConstant: 343),
          nameTextField.heightAnchor.constraint(equalToConstant: 75),
          nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
          nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
          ]) */
     }
     
     private func setUpTableView() {
         tableView.dataSource = self
         tableView.delegate = self
         tableView.layer.cornerRadius = 16
         tableView.isScrollEnabled = false
         tableView.register(NewHabitTableViewCell.self, forCellReuseIdentifier: NewHabitTableViewCell.reuseIdentifier)
         
         /*       tableView.translatesAutoresizingMaskIntoConstraints = false
          view.addSubview(tableView)
          
          NSLayoutConstraint.activate([
          tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
          tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
          tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
          tableView.heightAnchor.constraint(equalToConstant: 75)
          ]) */
     }
     
     private func setupCollectionView() {
         collectionView.register(
             NewTrackerCollectionViewCell.self,
             forCellWithReuseIdentifier: NewTrackerCollectionViewCell.reuseIdentifier
         )
         collectionView.register(
             NewTrackerHeaderView.self,
             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
             withReuseIdentifier: NewTrackerHeaderView.reuseIdentifier
         )
         collectionView.backgroundColor = .white
         collectionView.isScrollEnabled = false
         collectionView.allowsMultipleSelection = true
         collectionView.dataSource = self
         collectionView.delegate = self
     }
     
     private func setUpCancelButton() {
         
         let customColor = UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1.0) // #F56B6C
         cancelButton.setTitleColor(customColor, for: .normal)
         cancelButton.layer.borderColor = customColor.cgColor // Преобразование UIColor в CGColor
         cancelButton.layer.borderWidth = 1
         cancelButton.layer.cornerRadius = 16
         cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
         cancelButton.setTitle("Отменить", for: .normal)
         cancelButton.addTarget(
             self,
             action: #selector(cancelButtonTapped),
             for: .touchUpInside
         )
         
         /*      cancelButton.translatesAutoresizingMaskIntoConstraints = false
          view.addSubview(cancelButton)
          
          NSLayoutConstraint.activate([
          cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
          cancelButton.heightAnchor.constraint(equalToConstant: 60),
          cancelButton.widthAnchor.constraint(equalToConstant: 166),
          cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
          
          ]) */
     }
     
     private func setUpCreateButton(){
         createButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0) // #AEAFB4
         createButton.layer.cornerRadius = 16
         createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
         createButton.setTitle("Создать", for: .normal)
         createButton.isEnabled = false
         createButton.addTarget(
             self,
             action: #selector(createButtonTapped),
             for: .touchUpInside
         )
         
         /*       createButton.translatesAutoresizingMaskIntoConstraints = false
          view.addSubview(createButton)
          
          NSLayoutConstraint.activate([
          createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
          createButton.heightAnchor.constraint(equalToConstant: 60),
          createButton.widthAnchor.constraint(equalToConstant: 166),
          createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
          createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8)
          
          ]) */
     }
     
     private func setUpScrollView() {
         scrollView.isScrollEnabled = true
         scrollView.showsHorizontalScrollIndicator = false
     }
     
     private func setupUI() {
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
             nameTextField.widthAnchor.constraint(equalToConstant: 343),
             
             tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
             tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
             tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
             tableView.heightAnchor.constraint(equalToConstant: 75),
             
             collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
             collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
             collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
             collectionView.heightAnchor.constraint(equalToConstant: 476),
             
             cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor,constant: 10),
             cancelButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
 */

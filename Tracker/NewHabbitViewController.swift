//
//  NewHabbitViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 12.07.2024.
//

import Foundation
import UIKit

final class NewHabbitViewController: UIViewController, UITextFieldDelegate {
    private let nameTextField = UITextField()
    private let maxLength = 38
    
    private let tableView = UITableView()
    private let categories = ["Категория", "Расписание"]
    
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setUpTextField()
        setUpTableView()
        setUpCancelButton()
        setUpCreateButton()
    }
    
    private func setUpTextField(){
        nameTextField.delegate = self
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        nameTextField.layer.cornerRadius = 16
        nameTextField.textColor = .black
        nameTextField.borderStyle = .none
        nameTextField.layer.masksToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTextField.frame.height))
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .always
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            nameTextField.widthAnchor.constraint(equalToConstant: 343),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.bounds
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.register(NewHabitTableViewCell.self, forCellReuseIdentifier: NewHabitTableViewCell.reuseIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
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
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
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
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= maxLength
    }
    
    @objc func cancelButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createButtonTapped(){
        
    }
}

extension NewHabbitViewController: UITableViewDataSource, UITableViewDelegate {
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
        if indexPath.row == 1 { // Проверяем, что выбрана ячейка "Расписание"
            
            let newViewController = ScheduleViewController()
                newViewController.navigationItem.title = "Расписание"
            navigationController?.isNavigationBarHidden = false
                
                let navigationController = UINavigationController(rootViewController: newViewController)
                self.present(navigationController, animated: true, completion: nil)
        }
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

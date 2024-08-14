//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 14.08.2024.
//

import Foundation
import UIKit

final class NewCategoryViewController: UIViewController, UITextFieldDelegate {
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Colors.buttonInactive
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameCategoryTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryTextField()
        setupUI()
        addTapGestureToHideKeyboard()
    }
    
   private func setupCategoryTextField() {
        nameCategoryTextField.placeholder = "Введите название категории"
        nameCategoryTextField.backgroundColor = Colors.textFieldBackground
        nameCategoryTextField.layer.cornerRadius = 16
        nameCategoryTextField.textColor = .black
        nameCategoryTextField.borderStyle = .none
        nameCategoryTextField.layer.masksToBounds = true
       nameCategoryTextField.delegate = self 
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameCategoryTextField.frame.height))
        nameCategoryTextField.leftView = paddingView
        nameCategoryTextField.leftViewMode = .always
        
        nameCategoryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        [doneButton, nameCategoryTextField].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            
            nameCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameCategoryTextField.heightAnchor.constraint(equalToConstant: 75),        ])
        
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
    
    @objc func doneButtonTapped() {
        
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
    }
}

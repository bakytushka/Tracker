//
//  NewTrackersViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 11.07.2024.
//

import Foundation
import  UIKit

final class NewTrackersViewController: UIViewController {
    private let habitButton = UIButton()
    private let irregularEventButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        habitButton.layer.cornerRadius = 16
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        habitButton.tintColor = .white
        habitButton.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        habitButton.backgroundColor = UIColor.black
        
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.setTitle("Нерегулярные событие", for: .normal)
        irregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        irregularEventButton.tintColor = .white
        irregularEventButton.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
        irregularEventButton.backgroundColor = UIColor.black
        
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(habitButton)
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(irregularEventButton)
        
        NSLayoutConstraint.activate([
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
    
    @objc func didTapHabitButton(){
        let newViewController = NewHabbitViewController()
        newViewController.navigationItem.title = "Новая привычка"
        navigationController?.isNavigationBarHidden = false
        
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    @objc func didTapIrregularEventButton() {
        let newViewController = NewIrregularEventViewController()
        newViewController.navigationItem.title = "Новое нерегулярное событие"
        navigationController?.isNavigationBarHidden = false
        
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}



/* import Foundation
import UIKit

final class NewTrackersViewController: UIViewController {
    
    // Использование lazy для кнопок
    private lazy var habitButton: UIButton = createButton(title: "Привычка")
    private lazy var irregularEventButton: UIButton = createButton(title: "Нерегулярное событие")
    
    override func viewDidLoad() {
        super.viewDidLoad() // Добавлен вызов super.viewDidLoad()
        setupUI()
    }
    
    // Изменение метода setupUI на private
    private func setupUI() {
        view.backgroundColor = .white
        
        habitButton.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        irregularEventButton.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
        
        // Добавление кнопок к представлению
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
        
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Использование NSLayoutConstraint.activate для активации всех ограничений разом
        NSLayoutConstraint.activate([
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
    
    // Создание функции для кнопок
    private func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .white
        button.backgroundColor = .black
        return button
    }
    
    @objc private func didTapHabitButton() {
        let newViewController = NewHabbitViewController()
        newViewController.navigationItem.title = "Новая привычка"
        navigationController?.isNavigationBarHidden = false
        
        let navigationController = UINavigationController(rootViewController: newViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func didTapIrregularEventButton() {
        let newViewController = NewIrregularEventViewController()
        newViewController.navigationItem.title = "Новое нерегулярное событие"
        navigationController?.isNavigationBarHidden = false
        
        let navigationController = UINavigationController(rootViewController: newViewController)
        present(navigationController, animated: true, completion: nil)
    }
} */

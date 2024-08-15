//
//  NewTrackersViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 11.07.2024.
//

import Foundation
import  UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func setDateForNewTracker() -> String
    func didCreateNewTracker(_ tracker: Tracker, _ category: TrackerCategory)
}

final class NewTrackersViewController: UIViewController {
    private let habitButton = UIButton()
    private let irregularEventButton = UIButton()
    weak var delegate: NewTrackerViewControllerDelegate?
    
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
        let newViewController = NewHabitViewController()
        newViewController.delegate = delegate
        newViewController.navigationItem.title = "Новая привычка"
        navigationController?.isNavigationBarHidden = false
        
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    @objc func didTapIrregularEventButton() {
        let newViewController = NewIrregularEventViewController()
        newViewController.delegate = delegate
        newViewController.navigationItem.title = "Новое нерегулярное событие"
        navigationController?.isNavigationBarHidden = false
        
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}

//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 14.07.2024.
//

import Foundation
import UIKit

final class ScheduleViewController: UIViewController {
    private let doneButton = UIButton()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setUpDoneButton()
        
    }
    
    func setUpDoneButton(){
        doneButton.backgroundColor = .black
        doneButton.layer.cornerRadius = 16
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func doneButtonTapped(){
        
    }
}

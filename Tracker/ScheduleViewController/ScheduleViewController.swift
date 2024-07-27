//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 14.07.2024.
//

import Foundation
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectDays(_ days: [WeekDay: Bool])
}

final class ScheduleViewController: UIViewController {
    private let doneButton = UIButton()
    private let tableView = UITableView()
    private let daysOfWeek = Constant.daysOfWeekTitles
    
    var selectedDays: [WeekDay: Bool] = [:]
    weak var delegate: ScheduleViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        setupTableView()
        setupDoneButton()
        setupConstraints()
        setupInitialValues()
    }
    
    private func setupDoneButton(){
        doneButton.backgroundColor = .black
        doneButton.layer.cornerRadius = 16
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.bounds
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupInitialValues() {
        WeekDay.allCases.forEach { day in
            if selectedDays[day] == nil {
                selectedDays[day] = false
            }
        }
    }
    
    @objc private func switchViewChanged(sender: UISwitch) {
        guard let cell = sender.superview?.superview as? ScheduleTableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }
        
        let day = WeekDay.allCases[indexPath.row]
        selectedDays[day] = sender.isOn
    }
    
    @objc private func doneButtonTapped(){
        delegate?.didSelectDays(selectedDays)
        dismiss(animated: true, completion: nil)
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as? ScheduleTableViewCell else { return UITableViewCell() }
        
        cell.switchView.addTarget(
            self,
            action: #selector(switchViewChanged),
            for: .valueChanged
        )
        
        cell.configureCell(
            title: daysOfWeek[indexPath.row],
            isSwitchOn: selectedDays[WeekDay.allCases[indexPath.row]] ?? false
        )
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        if indexPath.row < daysOfWeek.count - 1 {
            separatorView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        } else {
            separatorView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
            separatorView.isHidden = true
        }
    }
}

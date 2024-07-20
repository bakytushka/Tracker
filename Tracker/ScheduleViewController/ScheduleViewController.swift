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
    private let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    
    
    var selectedDays: [WeekDay: Bool] = [:]
    weak var delegate: ScheduleViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        setUpTableView()
        
        
        WeekDay.allCases.forEach {
            selectedDays[$0] = false
        }
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
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.bounds
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525)
        ])
        
    }
    
    @objc private func switchViewChanged(sender: UISwitch) {
        guard let cell = sender.superview?.superview as? ScheduleTableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }
        
        let day = WeekDay.allCases[indexPath.row]
        selectedDays[day] = sender.isOn
    }
    
    @objc private func doneButtonTapped(){
        print("кнопка нажалась")
        delegate?.didSelectDays(selectedDays)
       
        //     navigationController?.popViewController(animated: true)
   /*     if let navigationController = navigationController {
            print("navigationController exists")
            navigationController.popViewController(animated: true)
        } else {
      */     // print("navigationController does not exist, dismissing instead")
            dismiss(animated: true, completion: nil)
            
            
        }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    // Количество строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    // Настройка ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as? ScheduleTableViewCell else {
            return UITableViewCell()
        }
 /*       cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        //       cell.label.text = daysOfWeek[indexPath.row]
        //        return cell
        cell.switchView.addTarget(
            self,
            action: #selector(switchViewChanged),
            for: .valueChanged
        )
        
        cell.configure(
            title: daysOfWeek[indexPath.row],
            isSwithcOn: selectedDays[WeekDay.allCases[indexPath.row]] ?? false
        )
        
        print("Cell for row \(indexPath.row) configured")
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return cell */
        cell.switchView.addTarget(
            self,
            action: #selector(switchViewChanged),
            for: .valueChanged
        )
        
        cell.configure(
            title: daysOfWeek[indexPath.row],
            isSwitchOn: selectedDays[WeekDay.allCases[indexPath.row]] ?? false
        )
        
//        cell.textLabel?.text = titles[indexPath.row]
        
        print("Cell for row \(indexPath.row) configured")
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return cell
    }
    
    
    
    // Обработка выбора ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Логика перехода на другой экран или отображения деталей
        print("Selected \(daysOfWeek[indexPath.row])")
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
        if indexPath.row == daysOfWeek.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

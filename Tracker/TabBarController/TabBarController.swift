//
//  ToolBarController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 30.06.2024.
//
import UIKit

final class TabBarController: UITabBarController {
    private var border: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBarController()
        addTabBarBorder()
        updateTabBarBorderColor()
    }
    
    private func createTabBarController() {
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill"),
            selectedImage: nil
        )
        
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController())
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill"),
            selectedImage: nil
        )
        viewControllers = [trackersViewController, statisticViewController]
    }
    
    private func addTabBarBorder() {
        border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(border)
        
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            border.topAnchor.constraint(equalTo: tabBar.topAnchor),
            border.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func updateTabBarBorderColor() {
        let borderColor: UIColor
        if traitCollection.userInterfaceStyle == .dark {
            borderColor = .black.withAlphaComponent(0.3)
        } else {
            borderColor = UIColor(red: 174.0 / 255.0, green: 175.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0)
        }
        border.backgroundColor = borderColor
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateTabBarBorderColor()
    }
}

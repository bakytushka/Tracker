//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 05.07.2024.
//
import UIKit

final class StatisticViewController: UIViewController {
    
    private var trackers: [Tracker] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private let trackerRecordStore = TrackerRecordStore()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let placeholderImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "statisticPlug")
        return image
    }()
    
    private let statViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 34, weight: .bold)
        title.textColor = .black
        return title
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.text = "Трекеров завершено"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerRecordStore.delegate = self
        setupUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistic()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statViewContainer.frame = CGRect(x: 16, y: self.view.frame.midY - 45, width: self.view.frame.width - 32, height: 90)
        addGradienBorder(to: statViewContainer, colors: [.red, .green, .blue])
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [placeholderImageView, placeholderLabel, statViewContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        statViewContainer.addSubview(titleLabel)
        statViewContainer.addSubview(subLabel)
        
        NSLayoutConstraint.activate([
            statViewContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statViewContainer.heightAnchor.constraint(equalToConstant: 90),
            
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 10),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: statViewContainer.topAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: statViewContainer.leftAnchor, constant: 12),
            
            subLabel.bottomAnchor.constraint(equalTo: statViewContainer.bottomAnchor, constant: -12),
            subLabel.leftAnchor.constraint(equalTo: statViewContainer.leftAnchor, constant: 12)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Статистика"
    }
    
    private func updateUI() {
        if completedTrackers.isEmpty {
            placeholderImageView.isHidden = false
            placeholderLabel.isHidden = false
            statViewContainer.isHidden = true
        } else {
            placeholderImageView.isHidden = true
            placeholderLabel.isHidden = true
            statViewContainer.isHidden = false
        }
    }
    
    private func updateStatistic() {
        completedTrackers = trackerRecordStore.completedTrackers
        let quantity = completedTrackers.count
        titleLabel.text = String(quantity)
        updateUI()
    }
    
    private func addGradienBorder(to view: UIView, colors: [UIColor], width: CGFloat = 2) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shape = CAShapeLayer()
        shape.lineWidth = width
        shape.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 16).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        view.layer.addSublayer(gradient)
    }
}

extension StatisticViewController: TrackerRecordStoreDelegate {
    func didUpdateRecords() {
        updateStatistic()
    }
}

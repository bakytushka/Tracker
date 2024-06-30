//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 30.06.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    private var trackersLabel = UILabel()
    private var addTrackerButton = UIButton()
    private var stubImageView = UIImageView()
    private var stubLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpTrackersLabel()
        setUpAddTrackerButton()
        setUpStubImage()
        setUpStubLabel()
    }
    
    private func setUpTrackersLabel() {
        trackersLabel.text = "Трекеры"
        trackersLabel.font = UIFont.boldSystemFont(ofSize: 34)
        
        trackersLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersLabel)
        
        NSLayoutConstraint.activate([
            trackersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88)
        ])
    }
    
    private func setUpAddTrackerButton() {
        addTrackerButton = UIButton.systemButton(
            with: UIImage(named: "Add tracker")!,
            target: self,
            action: #selector(didTapButton)
        )
        addTrackerButton.tintColor = UIColor.black
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addTrackerButton)
        
        NSLayoutConstraint.activate([
            addTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
        ])
    }
    private func setUpStubImage() {
        stubImageView.image = UIImage(named: "stub")!
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stubImageView)
        
        NSLayoutConstraint.activate([
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUpStubLabel() {
        stubLabel.text = "Что будем отслеживать?"
        stubLabel.font = UIFont.systemFont(ofSize: 12)
        
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stubLabel)
        
        NSLayoutConstraint.activate([
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8)
        ])
        
    }
    @objc
    private func didTapButton() {
    }
}

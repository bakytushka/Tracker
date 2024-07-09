//
//  TrackersViewCell.swift
//  Tracker
//
//  Created by Bakyt Temishov on 08.07.2024.
//

import Foundation
import UIKit

final class TrackersViewCell: UICollectionViewCell {
    let trackersNameLabel = UILabel()
    let trackersEmojiLabel = UILabel()
    let counterOfDaysLabel = UILabel()
    let colorOfCellView = UIView()
    let completionButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(tracker: Tracker) {
        setUpColorOfCellView(color: tracker.color)
        setUptrackersNameLabe(name: tracker.name)
        setUpTrackersEmojiLabel(emoji: tracker.emoji)
        setUpCompletionButton(color: tracker.color)
        setUpTrackersCounterOfDaysLabel()
    }
    
    private func setUptrackersNameLabe(name: String) {
        
        trackersNameLabel.text = "hello"
        trackersNameLabel.font = UIFont.systemFont(ofSize: 12)
        trackersNameLabel.textColor = .white
        trackersNameLabel.lineBreakMode = .byWordWrapping
        
        trackersNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackersNameLabel.leadingAnchor.constraint(equalTo: colorOfCellView.leadingAnchor, constant: 12),
            trackersNameLabel.trailingAnchor.constraint(equalTo: colorOfCellView.trailingAnchor, constant: -12),
            trackersNameLabel.bottomAnchor.constraint(equalTo: colorOfCellView.bottomAnchor, constant: -12),
            trackersNameLabel.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        addSubview(trackersNameLabel)
    }
    
    private func setUpTrackersEmojiLabel(emoji: String) {
        trackersEmojiLabel.text = emoji
        trackersEmojiLabel.font = UIFont.systemFont(ofSize: 12)
        trackersEmojiLabel.lineBreakMode = .byWordWrapping
        
        trackersEmojiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackersEmojiLabel.leadingAnchor.constraint(equalTo: colorOfCellView.leadingAnchor, constant: 12),
            trackersEmojiLabel.topAnchor.constraint(equalTo: colorOfCellView.topAnchor, constant: 12),
            trackersEmojiLabel.heightAnchor.constraint(equalToConstant: 24),
            trackersEmojiLabel.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        addSubview(trackersEmojiLabel)
        
    }
    
    private func setUpTrackersCounterOfDaysLabel() {
        counterOfDaysLabel.text = "1"
        counterOfDaysLabel.font = UIFont.systemFont(ofSize: 12)
        counterOfDaysLabel.lineBreakMode = .byWordWrapping
        
        counterOfDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            counterOfDaysLabel.leadingAnchor.constraint(equalTo: colorOfCellView.leadingAnchor, constant: 12),
            counterOfDaysLabel.trailingAnchor.constraint(equalTo: colorOfCellView.trailingAnchor, constant: -54),
            counterOfDaysLabel.topAnchor.constraint(equalTo: colorOfCellView.bottomAnchor, constant: 16),
            counterOfDaysLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        addSubview(counterOfDaysLabel)
        
        
    }
    
    private func setUpColorOfCellView(color: UIColor ) {
        addSubview(colorOfCellView)
        colorOfCellView.backgroundColor = color
        colorOfCellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorOfCellView.widthAnchor.constraint(equalToConstant: 167),
            colorOfCellView.heightAnchor.constraint(equalToConstant: 90),
        ])
        colorOfCellView.layer.cornerRadius = 16
    }
    
    private func setUpCompletionButton(color: UIColor) {
        completionButton.backgroundColor = .green
        completionButton.layer.cornerRadius = 16
        completionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        completionButton.tintColor = .white
        completionButton.addTarget(self, action: #selector(didTapcompletionButton), for: .touchUpInside)
        addSubview(completionButton)
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completionButton.topAnchor.constraint(equalTo: colorOfCellView.bottomAnchor, constant: 8),
            completionButton.trailingAnchor.constraint(equalTo: colorOfCellView.trailingAnchor, constant: -12),
            completionButton.widthAnchor.constraint(equalToConstant: 34),
            completionButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        addSubview(completionButton)
    }
    
    @objc func didTapcompletionButton() {
        print("press button")
    }
}

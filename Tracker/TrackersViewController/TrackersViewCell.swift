import Foundation
import UIKit

final class TrackersViewCell: UICollectionViewCell {
    let trackersNameLabel = UILabel()
    let trackersEmojiLabel = UILabel()
    let counterOfDaysLabel = UILabel()
    let colorOfCellView = UIView()
    let completionButton = UIButton()
    private var trackerIsCompleted = false
    var counterOfDays: Int = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(tracker: Tracker) {
        trackersNameLabel.text = tracker.name
        trackersEmojiLabel.text = tracker.emoji
        colorOfCellView.backgroundColor = tracker.color
        completionButton.backgroundColor = tracker.color
        setupCounterOfDaysLabel()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        [colorOfCellView, trackersNameLabel, trackersEmojiLabel, counterOfDaysLabel, completionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(colorOfCellView)
        contentView.addSubview(trackersEmojiLabel)
        contentView.addSubview(completionButton)
        contentView.addSubview(counterOfDaysLabel)
        contentView.addSubview(trackersNameLabel)
        
        NSLayoutConstraint.activate([
            colorOfCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorOfCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorOfCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorOfCellView.heightAnchor.constraint(equalToConstant: 90),
            
            trackersEmojiLabel.topAnchor.constraint(equalTo: colorOfCellView.topAnchor, constant: 12),
            trackersEmojiLabel.leadingAnchor.constraint(equalTo: colorOfCellView.leadingAnchor, constant: 12),
            trackersEmojiLabel.heightAnchor.constraint(equalToConstant: 24),
            trackersEmojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            trackersNameLabel.bottomAnchor.constraint(equalTo: colorOfCellView.bottomAnchor, constant: -12),
            trackersNameLabel.leadingAnchor.constraint(equalTo: colorOfCellView.leadingAnchor, constant: 12),
            trackersNameLabel.trailingAnchor.constraint(equalTo: colorOfCellView.trailingAnchor, constant: -12),
            
            completionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            completionButton.trailingAnchor.constraint(equalTo: colorOfCellView.trailingAnchor, constant: -12),
            completionButton.heightAnchor.constraint(equalToConstant: 34),
            completionButton.widthAnchor.constraint(equalToConstant: 34),
            
            counterOfDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterOfDaysLabel.trailingAnchor.constraint(equalTo: completionButton.leadingAnchor, constant: -8),
            counterOfDaysLabel.centerYAnchor.constraint(equalTo: completionButton.centerYAnchor)
        ])
        
        colorOfCellView.layer.cornerRadius = 16
        trackersNameLabel.font = UIFont.systemFont(ofSize: 12)
        trackersNameLabel.textColor = .white
        trackersNameLabel.lineBreakMode = .byWordWrapping
        
        trackersEmojiLabel.font = UIFont.systemFont(ofSize: 12)
        trackersEmojiLabel.lineBreakMode = .byWordWrapping
        
        counterOfDaysLabel.font = UIFont.systemFont(ofSize: 12)
        counterOfDaysLabel.lineBreakMode = .byWordWrapping
        
        completionButton.layer.cornerRadius = 16
        completionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        completionButton.tintColor = .white
        completionButton.addTarget(self, action: #selector(didTapCompletionButton), for: .touchUpInside)
    }
    
    func setupCounterOfDays(_ sender: Int) {
        counterOfDays = sender
        setupCounterOfDaysLabel()
    }
    
    @objc private func didTapCompletionButton() {
        trackerIsCompleted.toggle()
        
        if trackerIsCompleted {
            completionButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completionButton.alpha = 0.3
            counterOfDays -= 1
            setupCounterOfDaysLabel()
        } else {
            completionButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completionButton.alpha = 1
            counterOfDays += 1
            setupCounterOfDaysLabel()
        }
    }
    
    private func setupCounterOfDaysLabel() {
        switch counterOfDays{
        case 1:
            counterOfDaysLabel.text = "\(counterOfDays) день"
        case 2...4:
            counterOfDaysLabel.text = "\(counterOfDays) дня"
        default:
            counterOfDaysLabel.text = "\(counterOfDays) дней"
        }
    }
}

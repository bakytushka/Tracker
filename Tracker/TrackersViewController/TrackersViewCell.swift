import Foundation
import UIKit


protocol TrackerViewCellDelegate: AnyObject {
    func record(_ sender: Bool, _ cell: TrackersViewCell)
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackersViewCell: UICollectionViewCell {
    let trackersNameLabel = UILabel()
    let trackersEmojiLabel = UILabel()
    let counterOfDaysLabel = UILabel()
    let colorOfCellView = UIView()
    let completionButton = UIButton()
    private var trackerIsCompleted = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    weak var delegate: TrackerViewCellDelegate?
    static let reuseIdentifier = "TrackerCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        setupTrackersNameLabel()
        setupTrackersNameLabel()
        setupTrackersEmojiLabel()
        setupCompletionButton()
        setupCounterOfDaysLabel()
        setupConstraints()
    }
    
    private func setupConstraints() {
        contentView.backgroundColor = .clear
        colorOfCellView.layer.cornerRadius = 16
        
        [colorOfCellView, trackersNameLabel, trackersEmojiLabel, counterOfDaysLabel, completionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
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
    }
    
    private func setupTrackersNameLabel() {
        trackersNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        trackersNameLabel.textColor = .white
        trackersNameLabel.lineBreakMode = .byWordWrapping
        trackersNameLabel.numberOfLines = 2
    }
    
    private func setupTrackersEmojiLabel() {
        trackersEmojiLabel.font = UIFont.systemFont(ofSize: 12)
        trackersEmojiLabel.backgroundColor = .white.withAlphaComponent(0.3)
        trackersEmojiLabel.textAlignment = .center
        trackersEmojiLabel.layer.cornerRadius = 12
        trackersEmojiLabel.layer.masksToBounds = true
    }
    
    private func setupCounterOfDaysLabel() {
        counterOfDaysLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        counterOfDaysLabel.lineBreakMode = .byWordWrapping
  //      counterOfDaysLabel.text = setupCounterOfDaysLabelText(counterOfDays)
    }
    
    private func setupCompletionButton() {
        completionButton.layer.cornerRadius = 16
        completionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        completionButton.tintColor = .white
        completionButton.addTarget(self, action: #selector(didTapCompletionButton), for: .touchUpInside)
    }
    
    func configure(
        with tracker: Tracker,
        trackerIsCompleted: Bool,
        completedDays: Int,
        indexPath: IndexPath
    ) {
        self.trackerIsCompleted = trackerIsCompleted
        self.trackerId = tracker.id
        self.indexPath = indexPath
        
        trackersNameLabel.text = tracker.name
        colorOfCellView.backgroundColor = tracker.color
        completionButton.backgroundColor = tracker.color
        trackersEmojiLabel.text = tracker.emoji
        
        let imageName = trackerIsCompleted ? "checkmark" : "plus"
        if let image = UIImage(systemName: imageName) {
            completionButton.setImage(image, for: .normal)
        }
        
        counterOfDaysLabel.text = setupCounterOfDaysLabelText(completedDays)
        setupCompletionButton(with: tracker)
    }
    
    private func setupCounterOfDaysLabelText(_ count: Int) -> String {
        let daysForms = ["дней", "день", "дня"]
        let remainder100 = count % 100
        let remainder10 = count % 10
        
        let formIndex: Int
        
        if remainder100 >= 11 && remainder100 <= 14 {
            formIndex = 0
        } else {
            switch remainder10 {
            case 1:
                formIndex = 1
            case 2...4:
                formIndex = 2
            default:
                formIndex = 0
            }
        }
        
        return "\(count) \(daysForms[formIndex])"
    }
    
    private func setupCompletionButton(with tracker: Tracker) {
        switch completionButton.currentImage {
        case UIImage(systemName: "plus"):
            colorOfCellView.backgroundColor = tracker.color
        case UIImage(systemName: "checkmark"):
            completionButton.backgroundColor = tracker.color.withAlphaComponent(0.3)
        case .none, .some(_):
            break
        }
    }
    
    @objc private func didTapCompletionButton() {
        guard let trackerId = trackerId, let indexPath = indexPath else {
            assertionFailure("no trackerId and indexPath")
            return
        }
        
        if trackerIsCompleted {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}

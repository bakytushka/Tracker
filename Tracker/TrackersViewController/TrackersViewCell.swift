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
    var counterOfDays: Int = 0
    
    weak var delegate: TrackerViewCellDelegate?
    static let reuseIdentifier = "TrackerCell"
    
    
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
        trackersNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        trackersNameLabel.textColor = .white
        trackersNameLabel.lineBreakMode = .byWordWrapping
        trackersNameLabel.numberOfLines = 2
        
        trackersEmojiLabel.font = UIFont.systemFont(ofSize: 12)
        trackersEmojiLabel.backgroundColor = .white.withAlphaComponent(0.3)
        trackersEmojiLabel.textAlignment = .center
        trackersEmojiLabel.layer.cornerRadius = 12
        trackersEmojiLabel.layer.masksToBounds = true
        
        counterOfDaysLabel.font = UIFont.systemFont(ofSize: 12)
        counterOfDaysLabel.lineBreakMode = .byWordWrapping
//        counterOfDaysLabel.text = "1 день"
        
        completionButton.layer.cornerRadius = 16
        completionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        completionButton.tintColor = .white
        completionButton.addTarget(self, action: #selector(didTapCompletionButton), for: .touchUpInside)
    }
    
    @objc private func didTapCompletionButton() {
        trackerIsCompleted.toggle()
        
        if trackerIsCompleted {
            completionButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completionButton.alpha = 0.3
            counterOfDays += 1
        } else {
            completionButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completionButton.alpha = 1
            counterOfDays -= 1
        }
        setupCounterOfDaysLabel()
    }
    
    private func setupCounterOfDaysLabel() {
        counterOfDaysLabel.text = setQuantityLabelText(counterOfDays)
    }
  
    func configure(
        with tracker: Tracker,
        trackerIsCompleted: Bool,
        completedDays: Int,
        indexPath: IndexPath
    ) {
        self.trackerIsCompleted = trackerIsCompleted
        
        trackersNameLabel.text = tracker.name
        colorOfCellView.backgroundColor = tracker.color
        completionButton.backgroundColor = tracker.color
        trackersEmojiLabel.text = tracker.emoji
        
        let imageName = trackerIsCompleted ? "checkmark" : "plus"
        if let image = UIImage(systemName: imageName) {
            completionButton.setImage(image, for: .normal)
        }
        
        counterOfDays = completedDays
        setupCounterOfDaysLabel()
        setupQuantityButton(with: tracker)
    }
    
    private func setQuantityLabelText(_ count: Int) -> String {
        let daysForms = ["дней", "день", "дня"]
        let remainder100 = count % 100
        let remainder10 = count % 10
        // Индекс формы слова "день" в массиве, который будем использовать
        var formIndex: Int
        
        switch remainder100 {
        case 11...14: // Если остаток от 11 до 14, используем форму "дней"
            formIndex = 0
        default:
            switch remainder10 {
            case 1: // Если остаток равен 1 и число не оканчивается на 11, используем форму "день"
                formIndex = 1
            case 2...4: // Если остаток от 2 до 4 и число не оканчивается на 12, 13, 14, используем форму "дня"
                formIndex = 2
            default: // Во всех остальных случаях, используем форму "дней"
                formIndex = 0
            }
        }
        
        return "\(count) \(daysForms[formIndex])"
    }

    private func setupQuantityButton(with tracker: Tracker) {
        switch completionButton.currentImage {
        case UIImage(systemName: "plus"):
            colorOfCellView.backgroundColor = tracker.color
        case UIImage(systemName: "checkmark"):
            completionButton.backgroundColor = tracker.color.withAlphaComponent(0.3)
        case .none, .some(_):
            break
        }
    }
}

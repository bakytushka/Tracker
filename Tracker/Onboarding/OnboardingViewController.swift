//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 11.08.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    var completionHandler: (() -> Void)?
    
    private lazy var pages: [UIViewController] = {
        return [
            createOnboardingPageViewController(imageName: "Onboarding1", text: "Отслеживайте только то, что хотите"),
            createOnboardingPageViewController(imageName: "Onboarding2", text: "Даже если это не литры воды и йога")
        ]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = pages.count
        control.currentPage = 0
        control.currentPageIndicatorTintColor = Colors.buttonActive
        control.pageIndicatorTintColor = Colors.buttonActive.withAlphaComponent(0.3)
        control.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Colors.buttonActive
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Вот это технологии!", for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        configureInitialPage()
        setupUI()
    }
    
    private func createOnboardingPageViewController(imageName: String, text: String) -> UIViewController {
        return OnboardingPageViewController(imageName: imageName, labelText: text)
    }
    
    private func configureInitialPage() {
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @objc private func nextButtonTapped() {
        completionHandler?()
    }
    
    @objc private func pageControlChanged(_ sender: UIPageControl) {
        updatePageControl(to: sender.currentPage)
    }
    
    private func updatePageControl(to index: Int) {
        let direction: UIPageViewController.NavigationDirection = index > pageControl.currentPage ? .forward : .reverse
        setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
        pageControl.currentPage = index
    }
    
    private func setupUI() {
        [pageControl, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let currentIndex = pages.firstIndex(of: viewController) else {
                return nil
            }
            let previousIndex = (currentIndex - 1 + pages.count) % pages.count
            return pages[previousIndex]
        }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let currentIndex = pages.firstIndex(of: viewController) else {
                return nil
            }
            let nextIndex = (currentIndex + 1) % pages.count
            return pages[nextIndex]
        }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            if completed, let visibleVC = pageViewController.viewControllers?.first,
               let index = pages.firstIndex(of: visibleVC) {
                pageControl.currentPage = index
            }
        }
}

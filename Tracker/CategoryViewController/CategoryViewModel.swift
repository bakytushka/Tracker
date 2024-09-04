//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Bakyt Temishov on 15.08.2024.
//
import Foundation

typealias Binding<T> = (T) -> Void

protocol CategorySelectionDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}

protocol CategoryViewModelProtocol {
    var categories: [TrackerCategory] { get }
    var reloadData: Binding<[TrackerCategory]>? { get set }
    var didSelectCategory: Binding<TrackerCategory>? { get set }
    
    func loadCategories()
    func selectCategory(at index: Int)
    func addNewCategory(with name: String)
}

class CategoryViewModel: CategoryViewModelProtocol {
    weak var delegate: CategorySelectionDelegate?
    
    private let categoryStore: TrackerCategoryStore
    private let pinnedCategoryTitle = "Закрепленные"
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            reloadData?(categories)
        }
    }
    
    var reloadData: Binding<[TrackerCategory]>?
    var didSelectCategory: Binding<TrackerCategory>?
    
    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
        createPinnedCategoryIfNeeded()
        loadCategories()
    }
    
    private func createPinnedCategoryIfNeeded() {
            do {
                let coreDataCategories = try categoryStore.fetchCategories()
                if coreDataCategories.first(where: { $0.title == pinnedCategoryTitle }) == nil {
                    let pinnedCategory = TrackerCategory(title: pinnedCategoryTitle, trackers: [])
                    try categoryStore.addNewCategory(pinnedCategory)
                }
            } catch {
                print("Failed to create pinned category: \(error)")
            }
        }
    
    func loadCategories() {
        do {
            let coreDataCategories = try categoryStore.fetchCategories()
            categories = coreDataCategories
                .compactMap { categoryStore.updateTrackerCategory($0) }
                .filter { $0.title != pinnedCategoryTitle }
        } catch {
            print("Failed to load categories: \(error)")
        }
    }
    
    func selectCategory(at index: Int) {
        guard index >= 0 && index < categories.count else { return }
        let category = categories[index]
        didSelectCategory?(category)
        delegate?.didSelectCategory(category.title)
    }
    
    func addNewCategory(with name: String) {
        let newCategory = TrackerCategory(title: name, trackers: [])
        do {
            try categoryStore.addNewCategory(newCategory)
            loadCategories()
        } catch {
            print("Failed to add category: \(error)")
        }
    }
}

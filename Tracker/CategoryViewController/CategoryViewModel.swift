//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Bakyt Temishov on 15.08.2024.
//
import Foundation

typealias Binding<T> = (T) -> Void

protocol CategoryViewModelProtocol {
    var categories: [TrackerCategory] { get }
    var reloadData: Binding<[TrackerCategory]>? { get set }
    var didSelectCategory: Binding<TrackerCategory>? { get set }
 
    func loadCategories()
    func selectCategory(at index: Int)
    func addNewCategory(with name: String)
}

class CategoryViewModel: CategoryViewModelProtocol {
    private let categoryStore: TrackerCategoryStore
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            reloadData?(categories)
        }
    }
    
    var reloadData: Binding<[TrackerCategory]>?
    var didSelectCategory: Binding<TrackerCategory>?
    
    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
        loadCategories()
    }
    
    func loadCategories() {
        do {
            let coreDataCategories = try categoryStore.fetchCategories()
            categories = coreDataCategories.compactMap { categoryStore.updateTrackerCategory($0) }
        } catch {
            print("Failed to load categories: \(error)")
        }
    }
    
    func selectCategory(at index: Int) {
        guard index >= 0 && index < categories.count else { return }
        let category = categories[index]
        didSelectCategory?(category)
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

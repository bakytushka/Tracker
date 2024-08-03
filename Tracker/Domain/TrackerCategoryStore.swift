//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Bakyt Temishov on 29.07.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    public weak var delegate: TrackerCategoryStoreDelegate?

    private let trackerStore: TrackerStore
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?

    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure("Couldn't get app delegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        self.trackerStore = TrackerStore(context: context)
        super.init()
        setupFetchedResultsController()
    }

    private func setupFetchedResultsController() {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        do {
            try controller.performFetch()
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }

    func addNewCategory(_ categoryName: TrackerCategory) throws {
        guard let trackerCategoryEntity = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context) else { return }
        let newCategory = TrackerCategoryCoreData(entity: trackerCategoryEntity, insertInto: context)
        newCategory.title = categoryName.title
        newCategory.trackers = NSSet(array: [])
        do {
            try context.save()
        } catch {
            throw StoreError.decodeError
        }
    }

    func fetchCategories() throws -> [TrackerCategoryCoreData] {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw StoreError.decodeError
        }
    }

    func updateTrackerCategory(_ category: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let newTitle = category.title, let trackers = category.trackers else { return nil }
        return TrackerCategory(title: newTitle, trackers: trackers.compactMap { coreDataTracker in
            if let coreDataTracker = coreDataTracker as? TrackerCoreData {
                return trackerStore.changeTrackers(from: coreDataTracker)
            }
            return nil
        })
    }

    func createCategoryAndTracker(tracker: Tracker, with titleCategory: String) {
        guard let trackerCoreData = trackerStore.addTracker(from: tracker), let currentCategory = category(with: titleCategory) else { return }
        var currentTrackers = currentCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
        currentTrackers.append(trackerCoreData)
        currentCategory.trackers = NSSet(array: currentTrackers)
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    func addNewTrackerToCategory(_ tracker: Tracker, to trackerCategory: String) throws {
        let newTrackerCoreData = try trackerStore.fetchTrackerCoreData()
        guard let currentCategory = category(with: trackerCategory) else { return }
        var currentTrackers = currentCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
        if let index = newTrackerCoreData.firstIndex(where: { $0.id == tracker.id }) {
            currentTrackers.append(newTrackerCoreData[index])
        }
        currentCategory.trackers = NSSet(array: currentTrackers)
        do {
            try context.save()
        } catch {
            throw StoreError.decodeError
        }
    }

    private func category(with categoryName: String) -> TrackerCategoryCoreData? {
        return try? fetchCategories().first { $0.title == categoryName }
    }

    func deleteCategory(_ category: TrackerCategoryCoreData) throws {
        context.delete(category)
        do {
            try context.save()
        } catch {
            throw StoreError.decodeError
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateCategories()
    }
}

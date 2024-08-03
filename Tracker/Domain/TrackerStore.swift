//
//  TrackerStore.swift
//  Tracker
//
//  Created by Bakyt Temishov on 29.07.2024.
//

import CoreData
import UIKit

enum StoreError: Error {
    case decodeError
}

final class TrackerStore: NSObject {
    public weak var delegate: TrackerCategoryStoreDelegate?

    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?

    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure("Couldn't get app delegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }

    private func setupFetchedResultsController() {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]
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
            print("Failed to fetch trackers: \(error)")
        }
    }

    func addTracker(from tracker: Tracker) -> TrackerCoreData? {
        print("Attempting to add new record: \(tracker)")
        guard let trackerEntity = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: context) else { return nil }
        let newTracker = TrackerCoreData(entity: trackerEntity, insertInto: context)
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.schedule = tracker.schedule.joined(separator: ",")
        newTracker.color = uiColorMarshalling.hexString(from: tracker.color)
        return newTracker
    }

    func fetchTrackers() throws -> [Tracker] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        do {
            let trackerCoreDataArray = try context.fetch(fetchRequest)
            return trackerCoreDataArray.compactMap { trackerCoreData in
                return Tracker(
                    id: trackerCoreData.id ?? UUID(),
                    name: trackerCoreData.name ?? "",
                    color: uiColorMarshalling.color(from: trackerCoreData.color ?? ""),
                    emoji: trackerCoreData.emoji ?? "",
                    schedule: trackerCoreData.schedule?.components(separatedBy: ",") ?? []
                )
            }
        } catch {
            throw StoreError.decodeError
        }
    }

    func fetchTrackerCoreData() throws -> [TrackerCoreData] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw StoreError.decodeError
        }
    }

    func changeTrackers(from trackersCoreData: TrackerCoreData) -> Tracker? {
        guard
            let id = trackersCoreData.id,
            let name = trackersCoreData.name,
            let color = trackersCoreData.color,
            let emoji = trackersCoreData.emoji
        else { return nil }
        return Tracker(
            id: id,
            name: name,
            color: uiColorMarshalling.color(from: color),
            emoji: emoji,
            schedule: trackersCoreData.schedule?.components(separatedBy: ",") ?? []
        )
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateCategories()
    }
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateCategories()
}

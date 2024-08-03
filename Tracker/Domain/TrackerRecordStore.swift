//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Bakyt Temishov on 29.07.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject, NSFetchedResultsControllerDelegate {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure("Couldn't get app delegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        do {
            try self.init(context: context)
        } catch {
            preconditionFailure("Failed to initialize TrackerRecordStore: \(error)")
        }
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.trackerID, ascending: true)
        ]
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
            throw StoreError.decodeError
        }
    }
    
    var completedTrackers: Set<TrackerRecord> {
        guard
            let objects = fetchedResultsController?.fetchedObjects,
            let completedTrackers = try? objects.map({ try completedTracker(from: $0)})
        else { return [] }
        return Set(completedTrackers)
    }
    
    private func completedTracker(from data: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let id = data.trackerID,
            let date = data.date
        else {
            throw StoreError.decodeError
        }
        return TrackerRecord(
            trackerID: id,
            date: date
        )
    }
    
    func addTrackerRecord(from trackerRecord: TrackerRecord) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "TrackerRecordCoreData", in: context) else {
            throw StoreError.decodeError
        }
        let newRecord = TrackerRecordCoreData(entity: entity, insertInto: context)
        newRecord.trackerID = trackerRecord.trackerID
        newRecord.date = trackerRecord.date
        do {
            try context.save()
        } catch {
            throw StoreError.decodeError
        }
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) throws {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "trackerID == %@ AND date == %@",
            trackerRecord.trackerID as CVarArg,
            trackerRecord.date as CVarArg
        )
        
        do {
            let trackerRecordEntities = try context.fetch(fetchRequest)
            for entity in trackerRecordEntities {
                context.delete(entity)
            }
            
            try context.save()
        } catch {
            print("Error deleting tracker record: \(error)")
            throw error
        }
        
    }
    
    func fetchTrackerRecords() throws -> Set<TrackerRecord> {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        do {
            let trackerRecordCoreDataArray = try context.fetch(fetchRequest)
            let trackerRecords = trackerRecordCoreDataArray.compactMap { trackerRecordCoreData in
                TrackerRecord(
                    trackerID: trackerRecordCoreData.trackerID ?? UUID(),
                    date: trackerRecordCoreData.date ?? Date()
                )
            }
            return Set(trackerRecords)
        } catch {
            throw StoreError.decodeError
        }
    }
}

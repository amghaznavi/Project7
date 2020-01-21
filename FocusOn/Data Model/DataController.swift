//
//  DataController.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 04/12/2019.
//  Copyright © 2019 Am GHAZNAVI. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController {
    
    
    private var goal = Data.goal
    private var tasks = Data.todayTasks
    private var data = Data.data
    
    var entityName = StringPlus.focusOnEntity
    var entity : NSEntityDescription?
    var context : NSManagedObjectContext
    
    init() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
    }
    
    //MARK: - Public function
    func logTodayGoal(title: String?) {
        let goal = fetch(date: today)
        updateGoal(goal: goal, title: title)
        saveContext()
    }
    
    // Load today goal if nil create goal and task logs
    func todayGoal() {
        let goal = fetch(date: today)
        if goal == nil {
            createLogsFor(days: 1)
        }
        if goal != nil {
            let goal = goal as! FocusOn?
            Data.todayGoal = goal?.title
        } else {
            Data.todayGoal = StringPlus.goalPlaceHolder
        }
    }
    
    // Create item logs
    private func createLogsFor(days: Int) {
        for i in 0 ..< days {
            let goal = create()
            if let goal = goal as! FocusOn? {
                var date = today
                date.addTimeInterval(-Double(i * 3600 * 24))
                goal.achieved = false
                goal.date = date
                goal.title = StringPlus.goalPlaceHolder
                goal.type = Type.goal.rawValue
            }
            saveContext()
        }
        for i in 0 ..< days {
            for _ in 0 ..< 3 {
                let task = create()
                if let task = task as! FocusOn? {
                    var date = today
                    date.addTimeInterval(-Double(i * 3600 * 24))
                    task.achieved = false
                    task.date = date
                    task.title = StringPlus.taskPlaceHolder
                    task.type = Type.task.rawValue
                }
            }
        }
        
        saveContext()
    }
    
    
    func saveContext() {
        do {
            try context.save()
        }
        catch {
        }
    }
    
    
    private func create() -> NSManagedObject? {
        if let entity = entity {
            return NSManagedObject(entity: entity, insertInto: context)
        }
        return nil
    }
    
    // Fetch today goal
    private func fetch(date: Date) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "date = %@", startOfDay(for: date) as NSDate)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [FocusOn]
            return result.first
        } catch {
        }
        return nil
    }
    
    
    // Request all items by specific date
    func fetchResultsController(date: Date) -> NSFetchedResultsController<FocusOn> {
        let fetchRequest: NSFetchRequest<FocusOn> = FocusOn.fetchRequest()
        let typeSortDescriptor = NSSortDescriptor(key: "type", ascending: false)
        fetchRequest.sortDescriptors = [typeSortDescriptor]
        let predicate = datePredicate(from: date)
        fetchRequest.predicate = predicate
        let fetchedResultsController: NSFetchedResultsController<FocusOn> =
            NSFetchedResultsController(fetchRequest: fetchRequest,
                                       managedObjectContext: context,
                                       sectionNameKeyPath: nil,
                                       cacheName: nil)
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }
    
    

    // Request all items by date
    func fetchResultsController() -> NSFetchedResultsController<FocusOn> {
        let fetchRequest: NSFetchRequest<FocusOn> = FocusOn.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        let fetchedResultsController: NSFetchedResultsController<FocusOn> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "\(StringPlus.focusOnDate)", cacheName: nil)
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }
    
    func todayGoal(isAchieved : Bool) {
        goal?.achieved = isAchieved
        if isAchieved {
            for task in tasks {
                updateAchievedTask(task: task, achieved: isAchieved)
                
            }
        }
    }
    
    
    private func updateGoal(goal: NSManagedObject?, title: String?) {
        if let goal = goal {
            goal.setValue(title, forKey: "title")
        }
    }
    

    func updateTodayTask(task: NSManagedObject?, title: String?) {
        if let task = task {
            task.setValue(title, forKey: "title")
        }
        saveContext()
    }
    
    func updateAchievedTask(task: NSManagedObject?, achieved: Bool) {
        if let task = task {
            task.setValue(achieved, forKey: StringPlus.focusOnAchieved)
        }
        saveContext()
    }
    
    
    func updateAchievedGoal(goal: NSManagedObject?, achieved: Bool) {
        if let goal = goal {
            goal.setValue(achieved, forKey: StringPlus.focusOnAchieved)
        }
        saveContext()
    }
    
    
    
    func deleteAll() {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        }
        catch {
        }
        saveContext()
    }
    
    var today: Date {
        return startOfDay(for: Date())
    }
    
    var yesterday: Date {
        return startOfDay(for: Date(timeInterval: -86400, since: today))
    }
    
    func startOfDay(for date: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: date) // eg. yyyy-mm-dd 00:00:00
    }
    
    func dateCaption(for date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .none
        dateformatter.timeZone = TimeZone.current
        dateformatter.dateFormat = "\(StringPlus.date)"
        return dateformatter.string(from: date)
    }
    
    func dateCaptionMonthly(for date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .none
        dateformatter.timeZone = TimeZone.current
        dateformatter.dateFormat = "\(StringPlus.dateMonthly)"
        return dateformatter.string(from: date)
    }
    
    
}




// Helper function to predicate
extension DataController {
   
    func datePredicate(from date: Date = Date(), to endDate: Date? = nil) -> NSCompoundPredicate {
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        // Get beginning and end
        let dateFrom = calendar.startOfDay(for: date) // eg. 2018-10-10 00:00:00 (for current Time zone but different for UTC +0000)
        let endDate = endDate == nil ? calendar.date(byAdding: .day, value: 1, to: dateFrom) : endDate
        var dateTo = dateFrom
        if let date = endDate {
            dateTo = date
        }
        // Set predicates
        let dateFromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let dateToPredicate = NSPredicate(format: "date < %@", dateTo as NSDate)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [dateFromPredicate, dateToPredicate])
    }
}


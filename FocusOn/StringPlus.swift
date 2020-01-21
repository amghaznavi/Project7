//
//  StringPlus.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 10/11/2019.
//  Copyright © 2019 Am GHAZNAVI. All rights reserved.
//

import UIKit

struct StringPlus {
    
    static let goalPlaceHolder = "Set your goal..."
    static let taskPlaceHolder = "Define task"
    static let empty = ""
    static let achievedGoals = "Achieved goals"
    static let date = "EEEE, d MMMM yyyy"
    static let dateMonthly = "EEEE, d MMMM"
    static let taskCellID = "TaskCellID"
    static let goalCellID = "GoalCellID"
    static let histryGoalCellID = "HistryGoalCellID"
    static let histryTaskCellID = "HistryTaskCellID"
    static let taskCell = "TaskCell"
    static let goalCell = "GoalCell"
    static let histryTaskCell = "HistryTaskCell"
    static let histryGoalCell = "HistryGoalCell"
    static let checkMarkOff = "CheckMarkOff"
    static let checkMarkOn = "CheckMarkOn"
    static let goalHeader = "Goal for the day to focus on:"
    static let taskHeader = "3 tasks to achieve your goal:"
    static let checkingTask = "Great job on making progress!"
    static let uncheckingTask = "ah, no biggie, you’ll get it next time!"
    static let goalCompletion = "Congrats on achieving your goal!"
    static let focusOnDataModel = "FocusOn"
    static let focusOnAchieved = "achieved"
    static let focusOnTitle = "title"
    static let focusOnDate = "date"
    static let focusOnEntity = "FocusOn"
    static let focusOnType = "type"
    static let addGoalButtonTextAdd = "Add"
    static let addGoalButtonTextEdit = "Edit"
    static let achievedIcon = "achieved"
    static let unachievedIcon = "unachieved"
    
    static let monthlySegmentIndex = 0
    static let weeklySegmentIndex = 1
    
    static func monthlyDateFormat(year: Int) -> String {
      return "\(year)-01-01 00:00:00"
    }
    
    static func weeklyDateFormat(year: Int, month: Int) -> String {
      return "\(year)-\(month)-01 00:00:00"
    }
    
    static let today = "Today"
    static let sectionDateFormat = "MMMM dd, yyyy"
    static let titleDateFormat = "MMMM yyyy"
    static let defaultDateFormat = "yyyy-MM-dd HH:mm:ss"
    static let yearDateFormat = "yyyy"
    static let monthShortDateFormat = "MMM"
    static let monthDateFormat = "MMM"
    
    
}


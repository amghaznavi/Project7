//
//  Data.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 01/12/2019.
//  Copyright © 2019 Am GHAZNAVI. All rights reserved.
//


import Foundation

enum Type : String {
  case goal = "Goal", task = "Task"
}

class Data {

    static var goal : FocusOn?
    static var todayGoal : String?
    static var todayTasks = [FocusOn]()
    static var data = [FocusOn]()

}
 

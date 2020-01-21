//
//  TaskCell.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 10/11/2019.
//  Copyright © 2019 Am GHAZNAVI. All rights reserved.
//

import UIKit

protocol TaskCellDelegate {
    func taskCell(_ cell: TaskCell, completionChanged done: Bool)
}

class TaskCell: UITableViewCell {

    var delegate : TaskCellDelegate?
    
    @IBOutlet weak var TaskCellSuperView: UIView!
    @IBOutlet weak var TaskTextLabel: UILabel!
    @IBOutlet weak var TaskNumberLabel: UILabel!
    @IBOutlet weak var TaskCheckMarkButton: UIButton!
    @IBAction func TaskCheckMarkButtonPressed(_ sender: UIButton) {
        
        if TaskTextLabel.text != StringPlus.taskPlaceHolder {
            markDone(!TaskCheckMarkButton.isSelected)
            delegate?.taskCell(self, completionChanged: TaskCheckMarkButton.isSelected)
        }
    }
    
    func markDone(_ done: Bool) {
        TaskCheckMarkButton.isSelected = done
    }
    
    func setTitle(_ title: String?) {
        TaskTextLabel.text = title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configure() {
        
        TaskCellSuperView.addShadowTextLabel()
        TaskNumberLabel.roundButton()
        
        TaskCheckMarkButton.setImage(UIImage.init(named: StringPlus.checkMarkOff), for: .normal)
        TaskCheckMarkButton.setImage(UIImage.init(named: StringPlus.checkMarkOn), for: .selected)
    }

}

// MARK: - Extension 
extension TodayViewController : TaskCellDelegate {
    
    func taskCell(_ cell: TaskCell, completionChanged done: Bool) {
        // identify indexPath for a cell
        if let indexPath = TableView.indexPath(for: cell) {
            // fetch datasource for indexPath
            if let task = dataSource(indexPath: indexPath) {
                // update the completion state
                task.achieved = done
                
                if task.achieved == true {
                    // update today's tasks
                    dataController.updateAchievedTask(task: task, achieved: true)
                    completionChangeCaption = StringPlus.checkingTask
                } else {
                    // update today's tasks
                    dataController.updateAchievedTask(task: task, achieved: false)
                    completionChangeCaption = StringPlus.uncheckingTask
                    // update today's Goal
                    GoalCheckMarkButton.isSelected = false
                    updateTodayGoals(isAchieved: false)
                }
                manageLocalNotifications()
                updateProgress()
                
            }
        }
    }
}




//
//  TodayViewController.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 07/11/2019.
//  Copyright © 2019 Am GHAZNAVI. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class TodayViewController : UIViewController {
    
    let dataController = DataController()
    var completionChangeCaption : String?

    private var data = Data.data
    private var todayGoal = Data.goal
    private var todayTasks = Data.todayTasks

    @IBOutlet weak var AchievementLabelView: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var ProgressLabel: UILabel!
    @IBOutlet weak var AchievementLabel: UILabel!
    @IBOutlet weak var GoalMainView: UIView!
    @IBOutlet weak var GoalTextLabelView: UIView!
    @IBOutlet weak var GoalTextLabel: UILabel!
    @IBOutlet weak var GoalAddButton: UIButton!
    @IBOutlet weak var GoalCheckMarkButton: UIButton!
    
    @IBAction func GoalCheckMarkButtonPressed(_ sender: UIButton) {
        
        if GoalTextLabel.text != StringPlus.goalPlaceHolder {
            markDone(!GoalCheckMarkButton.isSelected)
        }
        GoalCheckMarkButton.isSelected == true ? goalAchieved() : goalNotAchieved()
    }
    
    @IBAction func GoalAddButtonPressed(_ sender: UIButton) {
        
        guard GoalTextLabel?.text != StringPlus.goalPlaceHolder else {
            return addGoalAction()
        }
        editGoalAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }


    func configure() {
        
        populateInitialGoal()
        GoalAddButton.addShadowButton()
        GoalTextLabelView.addShadowTextLabel()
        GoalMainView.addShadowPlusRed()
        addGoalButtonText()
        
        GoalCheckMarkButton.setImage(UIImage.init(named: StringPlus.checkMarkOff), for: .normal)
        GoalCheckMarkButton.setImage(UIImage.init(named: StringPlus.checkMarkOn), for: .selected)
        
        TableView.rowHeight = UITableView.automaticDimension
        TableView.estimatedRowHeight = 100
        
        TableView.dataSource = self
        TableView.delegate = self
        
        // Register custom tableView cell
        TableView.register(UINib(nibName: StringPlus.taskCell, bundle: nil), forCellReuseIdentifier: StringPlus.taskCellID)
        
        updateProgress()
        registerForKeyboardNotifications()
        manageLocalNotifications()
    }
    
    func markDone(_ done: Bool) {
        GoalCheckMarkButton.isSelected = done
    }
    
    func setTitle(_ title: String?) {
        GoalTextLabel.text = title
    }
    
    //Populate today's Goal
    func populateInitialGoal () {
        dataController.todayGoal()
        setTitle(Data.todayGoal)
    }
    
    //Populate today's Tasks
    func populateInitialTasks() {
        loadData()
    }
    
    //Filter and load data
    func loadData() {
        data = dataController.fetchResultsController(date: dataController.today).fetchedObjects ?? []
        if data.isEmpty {
        }
        todayGoal = data.filter { return ($0 as AnyObject).type == Type.goal.rawValue }.first
        todayTasks = data.filter { return ($0 as AnyObject).type == Type.task.rawValue }
    }

    //Reset today goal
    func resetTodayGoals(isAchieved : Bool) {
        todayGoal?.achieved = isAchieved
        if isAchieved {
            dataController.updateAchievedGoal(goal: todayGoal, achieved: isAchieved)
            for task in todayTasks {
                dataController.updateAchievedTask(task: task, achieved: isAchieved)
            }
        } else {
          dataController.updateAchievedGoal(goal: todayGoal, achieved: isAchieved)
            for task in todayTasks {
                dataController.updateAchievedTask(task: task, achieved: isAchieved)
            }
        }
    }
    
    //Update Goals
    func updateTodayGoals(isAchieved : Bool) {
        todayGoal?.achieved = isAchieved
        if isAchieved {
            dataController.updateAchievedGoal(goal: todayGoal, achieved: isAchieved)
        } else {
            dataController.updateAchievedGoal(goal: todayGoal, achieved: isAchieved)
        }
    }
    
    // Goal check and uncheck
    func goalAchieved() {
        resetTodayGoals(isAchieved: true)
        TableView.reloadData()
        updateProgress()
        manageLocalNotifications()
    }
  
    func goalNotAchieved() {
        resetTodayGoals(isAchieved: false)
        TableView.reloadData()
        updateProgress()
        manageLocalNotifications()
        completionChangeCaption = StringPlus.empty
    }
    
    func addGoalButtonText() {
        if GoalTextLabel.text != StringPlus.goalPlaceHolder {
            GoalAddButton.setTitle(StringPlus.addGoalButtonTextEdit, for: .normal)
            populateInitialTasks()
        }
        else if GoalTextLabel.text == StringPlus.goalPlaceHolder {
            GoalAddButton.setTitle(StringPlus.addGoalButtonTextAdd, for: .normal)
        } else {
            GoalAddButton.setTitle(StringPlus.addGoalButtonTextEdit, for: .normal)
            populateInitialTasks()
        }
    }
    

    // MARK: - Tableview update progress
    func updateProgress() {
        // calculate the initial values for task count
        let totalTasks = todayTasks.count
        let completedTasks = todayTasks.filter { (task) -> Bool in
                    return task.achieved == true
                }.count
        var caption : String
        if totalTasks == 0 { // no task added
            caption = "Get started - Add today's goal"
        }
        else if completedTasks == 0 { // nothing completed
            caption = "Get started - \(totalTasks) to go!"
        }
        else if completedTasks == totalTasks { // all completed
            caption = "Well done - \(totalTasks) completed!"
            GoalCheckMarkButton.isSelected = true
            resetTodayGoals(isAchieved: true)
            completionChangeCaption = StringPlus.goalCompletion
        }
        else { // completedTasks less totalTasks
            caption = "\(completedTasks) down \(totalTasks - completedTasks) to go!"
        }
        // assign the progress caption to the label
        ProgressLabel.text = caption
        AchievementLabel.text = completionChangeCaption
    }
    
    
    //MARK: - Manage local notifications
    func manageLocalNotifications() {
        // calculate the initial values for task count
        let totalTasks = todayTasks.count
        let completedTasks = todayTasks.filter { (task) -> Bool in
            return task.achieved == true
        }.count
        var title: String?
        var body: String?
        if totalTasks == 0 { // no tasks
            title = "It's lonely here"
            body = "Add some tasks!"
        }
        else if completedTasks == 0 { // nothing completed
            title = "Get started!"
            body = "You've got \(totalTasks) hot tasks to go!"
        }
        else if completedTasks < totalTasks { // completedTasks less totalTasks
            title = "Progress in action!"
            body = "\(completedTasks) down \(totalTasks - completedTasks) to go!"
        }
        // schedule (or remove) reminders
        scheduleLocalNotification(title: title, body: body)
    }
    
    func scheduleLocalNotification(title: String?, body: String?) {
        let identifier = "HostListSummary"
        let notificationCenter = UNUserNotificationCenter.current()
        // remove previously scheduled notifications
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
        if let newTitle = title, let newBody = body {
            // create content
            let content = UNMutableNotificationContent()
            content.title = newTitle
            content.body = newBody
            content.sound = UNNotificationSound.default
            // create trigger
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: true)
            // create request
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            // schedule notification
            notificationCenter.add(request, withCompletionHandler:nil)
        }
    }
    
    //MARK: - Keyboard managment methods
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        adjustLayoutForKeyboard(targetHeight: keyboardFrame.size.height)
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        adjustLayoutForKeyboard(targetHeight: 0)
    }
    
    func adjustLayoutForKeyboard(targetHeight: CGFloat) {
        TableView.contentInset.bottom = targetHeight
    }
    

    // MARK:- Goal alert actions
    
    //Add goal
    func addGoalAction() {
        let alert = UIAlertController(title: "Add goal", message: "Add today's goal", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let textField = alert.textFields?.first else {
                return
            }
            if let textToEdit = textField.text {
                if textToEdit.count == 0 {
                    return
                }
                
                // action
                self.setTitle(textToEdit)
                self.dataController.logTodayGoal(title: textToEdit)
                self.populateInitialTasks()
                self.TableView.reloadData()
                self.GoalAddButton.setTitle("Edit", for: .normal)
                self.manageLocalNotifications()
                self.updateProgress()
                self.addGoalButtonText()
                
            } else {
                return
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField()
        guard let textField = alert.textFields?.first else {
            return
        }
        textField.placeholder = StringPlus.goalPlaceHolder
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //Edit goal
    func editGoalAction() {
        let alert = UIAlertController(title: "Update goal", message: "Update today's goal", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Update", style: .default) { (action) in
            guard let textField = alert.textFields?.first else {
                return
            }
            if let textToEdit = textField.text {
                if textToEdit.count == 0 {
                    return
                }
                
                // action
                self.setTitle(textToEdit)
                self.dataController.logTodayGoal(title: textToEdit)
                self.populateInitialTasks()
                self.manageLocalNotifications()
                self.updateProgress()
                self.addGoalButtonText()
            
            } else {
                return
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField()
        guard let textField = alert.textFields?.first else {
            return
        }
        textField.placeholder = StringPlus.goalPlaceHolder
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}

// MARK:-  TableView Delegate
extension TodayViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.10 * Double(indexPath.row), animations: {cell.alpha = 1})
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return StringPlus.taskHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let task = todayTasks[indexPath.row]
        guard task.title != StringPlus.taskPlaceHolder else {
            return addTaskAction(task: task, indexPath: indexPath)
        }
        editTaskAction(task: task, indexPath: indexPath)

    }
    
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = todayTasks[indexPath.row]
        let edit = UIContextualAction(style: .normal, title: "Edit") { (contaxtualAction, view, actionPerfomed: (Bool) -> ()) in
            
            self.editTaskAction(task: task, indexPath: indexPath)
            actionPerfomed(true)
        }
        
        edit.backgroundColor = #colorLiteral(red: 0.8119354248, green: 0, blue: 0.003985286225, alpha: 1)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    
    
    //MARK:- Task alert actions
    private func addTaskAction(task : FocusOn, indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Add task", message: "Add today's task", preferredStyle: .alert)
        let saveAction = UIAlertAction (title: "Add", style: .default) { (action) in
            guard let textField = alert.textFields?.first else {
                return
            }
            if let textToEdit = textField.text {
                if textToEdit.count == 0 {
                    return
                }
                
                task.title = textToEdit
                self.dataController.updateTodayTask(task: task, title: textToEdit)
                self.TableView?.reloadRows(at: [indexPath], with: .automatic)
                self.updateProgress()
                
            } else {
                return
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField()
        guard let textField = alert.textFields?.first else {
            return
        }
        textField.placeholder = StringPlus.taskPlaceHolder
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func editTaskAction(task : FocusOn, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Update", message: "Update today's task", preferredStyle: .alert)
        let saveAction = UIAlertAction (title: "Update", style: .default) { (action) in
            guard let textField = alert.textFields?.first else {
                return
            }
            if let textToEdit = textField.text {
                if textToEdit.count == 0 {
                    return
                }
                
                task.title = textToEdit
                self.dataController.updateTodayTask(task: task, title: textToEdit)
                self.TableView?.reloadRows(at: [indexPath], with: .automatic)
                self.updateProgress()
                
            } else {
                return
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField()
        guard let textField = alert.textFields?.first else {
            return
        }
        textField.placeholder = StringPlus.taskPlaceHolder
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
}




// MARK:-  TableView DataSource
extension TodayViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if GoalTextLabel.text == StringPlus.goalPlaceHolder {
            return 0
        } else {
            return 1
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todayTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StringPlus.taskCellID, for: indexPath) as! TaskCell
        let taskData = dataSource(indexPath: indexPath)
        cell.setTitle(taskData?.title)
        cell.TaskNumberLabel.text = "\(indexPath.row + 1)"
        cell.delegate = self
        if taskData?.achieved == true {
            cell.TaskCheckMarkButton.isSelected = true
        } else {
            cell.TaskCheckMarkButton.isSelected = false
        }
        updateProgress()
        manageLocalNotifications()
        return cell
        
    }
    
    func dataSource(indexPath: IndexPath) -> FocusOn? {
        return todayTasks[indexPath.row]
    }

}


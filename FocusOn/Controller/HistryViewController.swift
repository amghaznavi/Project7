//
//  HistryViewController.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 10/11/2019.
//  Copyright © 2019 Am GHAZNAVI. All rights reserved.
//

import UIKit
import CoreData

class HistryViewController : UIViewController {
    
    let dataController = DataController()
    var fetchedRC : NSFetchedResultsController<FocusOn>!
    
    @IBOutlet weak var achievementLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        TableView.reloadData()
        configure()
    }
    
    
    func configure() {
        
        //Fetch data
        fetchedRC = dataController.fetchResultsController()
        dateLabel.text = dataController.dateCaption(for: dataController.today)
        achievementLabel.text = StringPlus.achievedGoals
        
        TableView.reloadData()
        
        TableView.dataSource = self
        TableView.delegate = self
        
        TableView.estimatedRowHeight = 100
        TableView.rowHeight = UITableView.automaticDimension
        
        // Register custom tableView cell
        TableView.register(UINib(nibName: StringPlus.histryGoalCell, bundle: nil), forCellReuseIdentifier: StringPlus.histryGoalCellID)
        TableView.register(UINib(nibName: StringPlus.histryTaskCell, bundle: nil), forCellReuseIdentifier: StringPlus.histryTaskCellID)
    }
}



// MARK:-  TableView DataSource
extension HistryViewController : UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if fetchedRC == nil { return 0 }
        return fetchedRC.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if fetchedRC == nil { return 0 }
        return fetchedRC.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StringPlus.histryGoalCellID, for: indexPath) as! HistryGoalCell
            let data = dataSource(indexPath: indexPath)
            cell.setTitle(data?.title)
            if data?.achieved == true {
                cell.GoalCheckMarkButton.isSelected = true
                cell.HistryGoalTextLabel.textColor = UIColor.focusOnGreen
            } else {
                cell.GoalCheckMarkButton.isSelected = false
                cell.HistryGoalTextLabel.textColor = UIColor.focusOnRed
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: StringPlus.histryTaskCellID, for: indexPath) as! HistryTaskCell
            let data = dataSource(indexPath: indexPath)
            cell.setTitle(data?.title)
            if data?.achieved == true {
                cell.CheckMarkButton.isSelected = true
            } else {
                cell.CheckMarkButton.isSelected = false
            }
            cell.taskNumberLabel .text = "\(indexPath.row + 0)"
            return cell
        }
    }
    
    func dataSource(indexPath: IndexPath) -> FocusOn? {
        return fetchedRC.object(at: indexPath)
        
    }
}



// MARK: - TableViewDelegate
extension HistryViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.07 * Double(indexPath.row), animations: {cell.alpha = 1})
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Today"
        } else {
            let data : FocusOn = fetchedRC.sections?[section].objects?.first as! FocusOn
            let text = dataController.dateCaptionMonthly(for: data.date!)
            return text
            
        }
    }
}







//
//  HistryGoalCell.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 14/11/2019.
//  Copyright © 2019 Am GHAZNAVI. All rights reserved.
//

import UIKit

class HistryGoalCell: UITableViewCell {

    @IBOutlet weak var SubViewA: UIView!
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var subViewB: UIView!
    @IBOutlet weak var HistryGoalTextLabel: UILabel!
    @IBOutlet weak var GoalCheckMarkButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func markDone(_ done: Bool) {
        GoalCheckMarkButton.isSelected = done
    }
    
    func configure() {
     GoalCheckMarkButton.setImage(UIImage.init(named: StringPlus.unachievedIcon), for: .normal)
     GoalCheckMarkButton.setImage(UIImage.init(named: StringPlus.achievedIcon), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setTitle(_ title: String?) {
         HistryGoalTextLabel.text = title
     }
    
}





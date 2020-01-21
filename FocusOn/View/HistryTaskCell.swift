//
//  HistryTaskCell.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 12/11/2019.
//  Copyright © 2019 Am GHAZNAVI. All rights reserved.
//

import UIKit

class HistryTaskCell: UITableViewCell {
    
    @IBOutlet weak var taskNumberLabel: UILabel!
    @IBOutlet weak var HistryTaskTextLabel: UILabel!
    @IBOutlet weak var CheckMarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func configure() {
        
        taskNumberLabel.roundButton()
        
        CheckMarkButton.setImage(UIImage.init(named: StringPlus.unachievedIcon), for: .normal)
        CheckMarkButton.setImage(UIImage.init(named: StringPlus.achievedIcon), for: .selected)
    }
    
    func markDone(_ done: Bool) {
          CheckMarkButton.isSelected = done
      }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setTitle(_ title: String?) {
        HistryTaskTextLabel.text = title
    }
    
}

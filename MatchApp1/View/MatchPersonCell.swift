//
//  MatchPersonCell.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/06.
//

import UIKit
import SDWebImage

class MatchPersonCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    
    static let identifire = "MatchPersonCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MatchPersonCell", bundle: nil)
    }
    
    func configure(nameLabelString: String ,ageLabelString: String, profileImageViewString: String, workLabelString: String, quickWordLabelString: String) {
        
        userNameLabel.text = nameLabelString
        ageLabel.text = ageLabelString
        workLabel.text = workLabelString
        profileImageView.sd_setImage(with: URL(string: profileImageViewString), completed: nil)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

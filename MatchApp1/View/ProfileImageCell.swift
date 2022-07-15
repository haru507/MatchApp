//
//  ProfileImageCell.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/05.
//

import UIKit
import SDWebImage

class ProfileImageCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var prefectureLabel: UILabel!
    @IBOutlet weak var quickWordLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    static let identifire = "ProfileImageCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileImageCell", bundle: nil)
    }
    
    func configure(profileImageString: String, nameLabelString: String, ageLabelString: String, prefectureLabelString: String, quickWordLabelString: String, likeLabelString: String) {
        
        profileImageView.sd_setImage(with: URL(string: profileImageString), completed: nil)
        nameLabel.text = nameLabelString
        ageLabel.text = ageLabelString
        prefectureLabel.text = prefectureLabelString
        quickWordLabel.text = quickWordLabelString
        likeLabel.text = likeLabelString
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = profileImageView.layer.frame.width / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

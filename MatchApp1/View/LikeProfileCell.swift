//
//  LikeProfileCell.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/06.
//

import UIKit
import SDWebImage

class LikeProfileCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var prefectureLabel: UILabel!
    @IBOutlet weak var quickWordLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    var userData = [String: Any]()
    var uid = String()
    var profileImageViewString = String()
    
    static let identifire = "LikeProfileCell"
    
    
    @IBOutlet weak var likeButton: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: "LikeProfileCell", bundle: nil)
    }
    
    func configure(nameLabelString: String, ageLabelString: String, prefectureLabelString: String, bloodLabelString: String, genderLabelString: String, heightLabelString: String, workLabelString: String, quickWordLabelString: String, profileImageViewString: String, uid: String, userData: [String:Any]) {
        
        nameLabel.text = nameLabelString
        ageLabel.text = ageLabelString
        prefectureLabel.text = prefectureLabelString
        bloodLabel.text = bloodLabelString
        genderLabel.text = genderLabelString
        heightLabel.text = heightLabelString
        workLabel.text = workLabelString
        quickWordLabel.text = quickWordLabelString
        profileImageView.sd_setImage(with: URL(string: profileImageViewString), completed: nil)
        self.uid = uid
        self.userData = userData
        self.profileImageViewString = profileImageViewString
        
        Util.rectButton(button: likeButton)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    
    @IBAction func likeAction(_ sender: Any) {
        let sendDBModel = SendDBModel()
        sendDBModel.sendToLikeFromLike(likeFlag: true, thisUserID: self.uid, matchName: nameLabel.text!, matchID: self.uid)
        
        sendDBModel.sendToMatchingList(thisUserID: self.uid, name: nameLabel.text!, age: ageLabel.text!, bloodType: bloodLabel.text!, height: heightLabel.text!, prefecture: prefectureLabel.text!, gender: genderLabel.text!, profile: "後で外部引数で渡す", profileImageString: self.profileImageViewString, uid: self.uid, quickword: quickWordLabel.text!, work: workLabel.text!, userData: self.userData)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

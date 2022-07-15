//
//  ProfileViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/05.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, LikeSendDelegate, GetLikeCountProtcol {
    
    var userDataModel: UserDataModel?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    
    var likeCount = Int()
    var likeFlag = Bool()
    var loadDBModel = LoadDBModel()
    
    let sendDBModel = SendDBModel()
    
    
    @IBOutlet weak var menuOutlet: UIButton!
    @IBOutlet var menuItemsOutlets: [UIButton]!
    
    
    @IBAction func menuAction(_ sender: UIButton) {
        menuItemsOutlets.forEach { (button) in
            button.isHidden = !button.isHidden
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuItemsOutlets.forEach { (button) in
            button.isHidden = true
        }

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ProfileImageCell.nib(), forCellReuseIdentifier: ProfileImageCell.identifire)
        tableView.register(ProfileTextCell.nib(), forCellReuseIdentifier: ProfileTextCell.identifire)
        tableView.register(ProfileDetailCell.nib(), forCellReuseIdentifier: ProfileDetailCell.identifire)
        
        loadDBModel.getLikeCountProtcol = self
        loadDBModel.loadLikeCount(uuid: (userDataModel?.uid)!)
        
    }
    
    
    @IBAction func toViolationSegue(_ sender: Any) {
        
        self.performSegue(withIdentifier: "violationVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        menuItemsOutlets.forEach { (button) in
            button.isHidden = true
        }
        let violationVC = segue.destination as! ViolationViewController

        violationVC.userDataModel = userDataModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        let sendDBModel = SendDBModel()
        sendDBModel.sendAsiato(aitenoUserID: (userDataModel?.uid)!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageCell.identifire, for: indexPath) as! ProfileImageCell
            cell.configure(profileImageString: (userDataModel?.profileImageString)!, nameLabelString: (userDataModel?.name)!, ageLabelString: (userDataModel?.age)!, prefectureLabelString: (userDataModel?.prefecture)!, quickWordLabelString: (userDataModel?.quickWord)!, likeLabelString: String(likeCount))
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextCell.identifire, for: indexPath) as! ProfileTextCell
            
            cell.profileTextView.text = userDataModel?.profile
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDetailCell.identifire, for: indexPath) as! ProfileDetailCell
            
            cell.configure(nameLabelString: (userDataModel?.name)!, ageLabelString: (userDataModel?.age)!, prefectureLabelString: (userDataModel?.prefecture)!, bloodLabelString: (userDataModel?.bloodType)!, genderLabelString:  (userDataModel?.gender)!, heightLabelString:  (userDataModel?.height)!, workLabelString:  (userDataModel?.work)!)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 450
        }else if indexPath.row == 2 {
            return 370
        }else if indexPath.row == 3 {
            return 400
        }
        
        return 1
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if userDataModel?.uid != Auth.auth().currentUser?.uid {
            
            sendDBModel.likeSendDelegate = self
            
            if self.likeFlag == false {
                sendDBModel.sendToLike(likeFlag: true, thisUserID: (userDataModel?.uid)!)
            }else {
                sendDBModel.sendToLike(likeFlag: false, thisUserID: (userDataModel?.uid)!)
            }
        }
    }
    
    func like() {
        Util.startAnimation(name: "heart", view: self.view)
    }
    
    func getLikeCount(likeCount: Int, likeFlag: Bool) {
        self.likeFlag = likeFlag
        self.likeCount = likeCount
        if self.likeFlag == false {
            likeButton.setImage(UIImage(named: "notLike"), for: .normal)
        }else {
            likeButton.setImage(UIImage(named: "like"), for: .normal)
        }
        
        tableView.reloadData()
    }
    
    
    @IBAction func blockUser(_ sender: Any) {
        menuItemsOutlets.forEach { (button) in
            button.isHidden = true
        }
        let alert: UIAlertController = UIAlertController(title: "ブロックしますか？", message:  "一度ブロックすると解除できません。", preferredStyle:  UIAlertController.Style.alert)
        // 確定ボタンの処理
        let confirmAction: UIAlertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default, handler:{ [self]
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.sendDBModel.sendBlockUser(otherUserID: userDataModel!.uid!)
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.navigationController?.popViewController(animated: true)
            }
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            print("キャンセル")
        })
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        // DBに送る
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

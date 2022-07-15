//
//  UserViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/13.
//

import UIKit
import Firebase
import KeychainSwift
import SDWebImage

class UserViewController: UIViewController {
    
    var isConfirmed: Bool = Bool()
    let db = Firestore.firestore()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let userData = KeyChainConfig.getKeyArrayData(key: "userData")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadConfirm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        nameLabel.text = userData["name"] as? String
        
        imageView.sd_setImage(with: URL(string: (userData["profileImageString"] as? String)!), completed: nil)
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    @IBAction func toConfirmSegue(_ sender: Any) {
        
        self.performSegue(withIdentifier: "confirmID", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmID" {
            let confirmVC = segue.destination as! ConfiormViewController

            confirmVC.isConfirmed = self.isConfirmed
        }
    }
    
    
    func loadConfirm() {
        db.collection("Confirm").document(Auth.auth().currentUser!.uid).addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.data(){
                print(snapShotDoc)
                self.isConfirmed = true
            }
            
        }
    }
    
}

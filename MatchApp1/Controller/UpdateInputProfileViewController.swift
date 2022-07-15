//
//  UpdateInputProfileViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/16.
//

import UIKit
import KeychainSwift

class UpdateInputProfileViewController: UIViewController {

    @IBOutlet weak var profileTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    let userDataArray = KeyChainConfig.getKeyArrayData(key: "userData")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Util.rectButton(button: doneButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileTextView.text = (userDataArray["profile"] as! String)
    }
    
    @IBAction func done(_ sender: Any) {
        let manager = Manager.shared
        print(manager.profile)
        manager.profile = profileTextView.text
//        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

}

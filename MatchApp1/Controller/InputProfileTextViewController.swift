//
//  InputProfileTextViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/02.
//

import UIKit

class InputProfileTextViewController: UIViewController {
    
    @IBOutlet weak var profileTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Util.rectButton(button: doneButton)
    }
    
    @IBAction func done(_ sender: Any) {
        let manager = Manager.shared
        print(manager.profile)
        manager.profile = profileTextView.text
        dismiss(animated: true, completion: nil)
    }
    

}

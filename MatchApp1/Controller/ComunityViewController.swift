//
//  ComunityViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/17.
//

import UIKit

class ComunityViewController: UIViewController {
    
    var text1: String = String()
    var text2: String = String()
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var cButton: UIView!
    @IBOutlet weak var comunityView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = text1
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    @IBAction func onTap(_ sender: Any) {
        
    }
}

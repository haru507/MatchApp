//
//  CHomeViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/17.
//

import UIKit

class CHomeViewController: UIViewController {
    
    var text1 = ""
    var text2 = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func musicTouch(_ sender: Any) {
        text1 = "音楽"
        text2 = "music"
        self.performSegue(withIdentifier: "comunityID", sender: nil)
    }
    
    @IBAction func movieTouch(_ sender: Any) {
        text1 = "映画"
        text2 = "movie"
        self.performSegue(withIdentifier: "comunityID", sender: nil)
    }
    
    
    @IBAction func tvTouch(_ sender: Any) {
        text1 = "テレビ"
        text2 = "tv"
        self.performSegue(withIdentifier: "comunityID", sender: nil)
    }
    
    
    @IBAction func gameTouch(_ sender: Any) {
        text1 = "ゲーム"
        text2 = "game"
        self.performSegue(withIdentifier: "comunityID", sender: nil)
    }
    
    
    @IBAction func bookTouch(_ sender: Any) {
        text1 = "本・漫画"
        text2 = "book"
        self.performSegue(withIdentifier: "comunityID", sender: nil)
    }
    
    
    @IBAction func artTouch(_ sender: Any) {
        text1 = "アート"
        text2 = "art"
        self.performSegue(withIdentifier: "comunityID", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "comunityID" {
            let comunityVC = segue.destination as! ComunityViewController

            comunityVC.text1 = self.text1
            comunityVC.text2 = self.text2
        }
    }
}

//
//  ViolationViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/13.
//

import UIKit


class ViolationViewController: UIViewController {
    
    var userDataModel: UserDataModel?
    
    let sendDBModel = SendDBModel()
    
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var inputTextField: UITextView!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var senderButton: UIButton!
    
    var maxCount: Int = 100
    let placeholder: String = "違反内容を入力してください。"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        senderButton.isEnabled = false
        
        self.navigationItem.title = "違反報告"
        self.inputTextField.delegate = self
        //タップでキーボードを下げる
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        //下にスワイプでキーボードを下げる
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeDownGesture.direction = .down
        self.view.addGestureRecognizer(swipeDownGesture)
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func sender(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "送信完了", message:  "違反内容を送信しました。", preferredStyle:  UIAlertController.Style.alert)
        // 確定ボタンの処理
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            print("確定")
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
        
        alert.addAction(confirmAction)
        
        sendDBModel.sendViolations(receiverID: (userDataModel?.uid)!, text: inputTextField.text)
        present(alert, animated: true, completion: nil)
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension ViolationViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return inputTextField.text.count <= 1000
    }
        
    func textViewDidChange(_ textView: UITextView) {
        
        if maxCount <= textView.text.count {
            self.senderButton.isEnabled = true
            self.wordCountLabel.text = "0"
        }else {
            self.senderButton.isEnabled = false
            self.wordCountLabel.text = "\(maxCount - textView.text.count)"
        }
    }
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        if inputTextField.text == placeholder {
            inputTextField.text = nil
            inputTextField.textColor = .black
        }
    }
 
    func textViewDidEndEditing(_ textView: UITextView) {
        if inputTextField.text.isEmpty {
            inputTextField.textColor = .black
            inputTextField.text = placeholder
        }
    }
    
}

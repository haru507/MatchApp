//
//  FormViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/13.
//

import UIKit

class FormViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var inputCategory: UITextField!
    @IBOutlet weak var inputTextField: UITextView!
    @IBOutlet weak var senderButton: UIButton!
    
    var dataStringArray: [String] = []
    var categoryPicker = UIPickerView()
    
    var mail = "yarukidenai@tcdigital.jp"
    let placeholder: String = "内容を入力してください。"
    let sendDBModel = SendDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        senderButton.isEnabled = false
        self.navigationItem.title = "お問い合わせ"
        inputCategory.inputView = categoryPicker

        categoryPicker.delegate = self
        categoryPicker.dataSource = self

    }
    
    @IBAction func sender(_ sender: Any) {
//        空判定
        if inputTextField.text == "" {
            return
        }
        
        let alert: UIAlertController = UIAlertController(title: "送信完了", message:  "お問い合わせ内容を送信しました。", preferredStyle:  UIAlertController.Style.alert)
        // 確定ボタンの処理
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            print("確定")
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(confirmAction)
        
        sendDBModel.sendFormData(category: inputCategory.text!, text: inputTextField.text, mail: mail)
        present(alert, animated: true, completion: nil)
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        dataStringArray = ["お支払いについて", "不快なユーザがいる", "技術的な問題について", "その他"]
        return dataStringArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        inputCategory.text = dataStringArray[row]
        inputCategory.resignFirstResponder()
        
        senderButton.isEnabled = true
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataStringArray[row]
    }
    
}

extension FormViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return inputTextField.text.count <= 1000
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

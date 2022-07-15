//
//  ConfiormViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/13.
//

import UIKit

class ConfiormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isConfirmed: Bool?
    var image: UIImageView = UIImageView()
    
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    let sendDBModel = SendDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "会員ステータス"
        
        if isConfirmed! {
            confirmLabel.text = "本人確認済"
            confirmButton.isEnabled = false
            
        }else {
            confirmLabel.text = "未確認"
            confirmButton.isEnabled = true
        }

    }
    
    @IBAction func tap(_ sender: Any) {
        openCamera()
    }
    
    func openCamera(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
//            cameraPicker.showsCameraControls = true
            present(cameraPicker, animated: true, completion: nil)
            
        }else{
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[.editedImage] as? UIImage
        {
            image.image = pickedImage
            
            let alert: UIAlertController = UIAlertController(title: "送信完了", message:  "違反内容を送信しました。", preferredStyle:  UIAlertController.Style.alert)
            // 確定ボタンの処理
            let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                // 確定ボタンが押された時の処理をクロージャ実装する
                (action: UIAlertAction!) -> Void in
                //実際の処理
                print("確定")
            })
            
            alert.addAction(confirmAction)
            
            // DBに送る
            sendDBModel.sendConfirmData(image: (image.image?.jpegData(compressionQuality: 0.4))!)
            
            self.confirmLabel.text = "本人確認済"
            confirmButton.isEnabled = false
            //閉じる処理
            picker.dismiss(animated: true, completion: nil)
            present(alert, animated: true, completion: nil)
        }
 
    }
 
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

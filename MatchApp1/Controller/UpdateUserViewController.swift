//
//  CreateNewUserViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/02.
//

import UIKit
import Firebase
import AVFoundation
import SDWebImage
import KeychainSwift

class UpdateUserViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var quickWordTextField: UITextField!
    
    
    
    @IBOutlet weak var toProfileButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var player = AVPlayer()
    
    var agePicker = UIPickerView()
    var heightPicker = UIPickerView()
    var bloodPicker = UIPickerView()
    var prefecturePicker = UIPickerView()
    
    var dataStringArray = [String]()
    var dataIntArray = [Int]()
    
    let userDataArray = KeyChainConfig.getKeyArrayData(key: "userData")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpVideo()
        
        textField2.inputView = agePicker
        textField3.inputView = heightPicker
        textField4.inputView = bloodPicker
        textField5.inputView = prefecturePicker

        agePicker.delegate = self
        agePicker.dataSource = self
        
        heightPicker.delegate = self
        heightPicker.dataSource = self
        
        bloodPicker.delegate = self
        bloodPicker.dataSource = self
        
        prefecturePicker.delegate = self
        prefecturePicker.dataSource = self
        
        agePicker.tag = 1
        heightPicker.tag = 2
        bloodPicker.tag = 3
        prefecturePicker.tag = 4
        
        Util.rectButton(button: toProfileButton)
        Util.rectButton(button: doneButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.sd_setImage(with: (URL(string: userDataArray["profileImageString"] as! String)), completed: nil)
        textField1.text = (userDataArray["name"] as! String)
        textField2.text = (userDataArray["age"] as! String)
        textField3.text = (userDataArray["height"] as! String)
        textField4.text = (userDataArray["bloodType"] as! String)
        textField5.text = (userDataArray["prefecture"] as! String)
        textField6.text = (userDataArray["work"] as! String)
        quickWordTextField.text = (userDataArray["quickWord"] as! String)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
            dataIntArray = ([Int])(18...80)
            return dataIntArray.count
            
        case 2:
            dataIntArray = ([Int])(130...200)
            return dataIntArray.count
        
        case 3:
            dataStringArray = ["A", "B", "O", "AB"]
            return dataStringArray.count
            
        case 4:
            dataStringArray = Util.prefectures()
            return dataStringArray.count
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            textField2.text = String(dataIntArray[row]) + "歳"
            textField2.resignFirstResponder()
            break
        case 2:
            textField3.text = String(dataIntArray[row]) + "cm"
            textField3.resignFirstResponder()
            break
        case 3:
            textField4.text = dataStringArray[row] + "型"
            textField4.resignFirstResponder()
            break
        case 4:
            textField5.text = dataStringArray[row]
            textField5.resignFirstResponder()
            break
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return String(dataIntArray[row]) + "歳"
        case 2:
            return String(dataIntArray[row]) + "cm"
            
        case 3:
            return dataStringArray[row] + "型"
        case 4:
            return dataStringArray[row]
        default:
            return ""
        }
    }
    
    @IBAction func done(_ sender: Any) {
        let manager = Manager.shared.profile
        
        Auth.auth().signInAnonymously { result, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            if let range1 = self.textField2.text?.range(of: "歳"){
                self.textField2.text?.replaceSubrange(range1, with: "歳")
            }
            
            if let range2 = self.textField3.text?.range(of: "cm"){
                self.textField3.text?.replaceSubrange(range2, with: "cm")
            }
            
            let userData = UserDataModel(name: self.textField1.text, age: self.textField2.text, height: self.textField3.text, bloodType: self.textField4.text, prefecture: self.textField5.text, gender: (self.userDataArray["gender"] as! String), profile: manager, profileImageString: "", uid: Auth.auth().currentUser?.uid, quickWord: self.quickWordTextField.text, work: self.textField6.text, date: Date().timeIntervalSince1970, onlineORNot: true)
            
            let sendDBModel = SendDBModel()
//            sendDBModel.sendProfileData(userData: userData, profileImageData: (self.imageView.image?.jpegData(compressionQuality: 0.4))!)
            sendDBModel.sendUpdateProfile(userData: userData, profileImageData: (self.imageView.image?.jpegData(compressionQuality: 0.4))!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigationController?.popViewController(animated: true)
            }
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
            imageView.image = pickedImage
            //閉じる処理
            picker.dismiss(animated: true, completion: nil)
         }
 
    }
 
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setUpVideo(){
        //ファイルパス
        player = AVPlayer(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/matchapp1-62ad9.appspot.com/o/backVideo.mp4?alt=media&token=71b178f2-1973-4d21-b922-4519d418343a")!)

               //AVPlayer用のレイヤーを生成
               let playerLayer = AVPlayerLayer(player: player)
               playerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)

               playerLayer.videoGravity = .resizeAspectFill
               playerLayer.repeatCount = 0 //無限ループ(終わったらまた再生のイベント後述)
               playerLayer.zPosition = -1
               view.layer.insertSublayer(playerLayer, at: 0)

               //終わったらまた再生
               NotificationCenter.default.addObserver(
                   forName: .AVPlayerItemDidPlayToEndTime, //終わったr前に戻す
                   object: player.currentItem,
                   queue: .main) { (_) in

                       self.player.seek(to: .zero)//開始時間に戻す
                       self.player.play()

               }

               self.player.play()

    }
        
    
}

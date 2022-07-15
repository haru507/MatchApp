//
//  SearchViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/11.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GetSearchResultProtocol {
    
    @IBOutlet weak var ageMinTextField: UITextField!
    @IBOutlet weak var ageMaxTextField: UITextField!
    @IBOutlet weak var heightMinTextField: UITextField!
    @IBOutlet weak var heightMaxTextField: UITextField!
    @IBOutlet weak var bloodTextField: UITextField!
    @IBOutlet weak var prefectureTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    var ageMinPicker = UIPickerView()
    var ageMaxPicker = UIPickerView()
    var heightMinPicker = UIPickerView()
    var heightMaxPicker = UIPickerView()
    var bloodPicker = UIPickerView()
    var prefecturesPicker = UIPickerView()

    var dataStringArray = [String]()
    var dataIntArray = [Int]()
    
    var userDataModelArray = [UserDataModel]()
    var userData = String()
    // 遷移元から処理を受け取るクロージャのプロパティを用意
    var resultHandler: (([UserDataModel],Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageMinTextField.inputView = ageMinPicker
        ageMaxTextField.inputView = ageMaxPicker
        heightMinTextField.inputView = heightMinPicker
        heightMaxTextField.inputView = heightMaxPicker
        bloodTextField.inputView = bloodPicker
        prefectureTextField.inputView = prefecturesPicker
        
        ageMinPicker.delegate = self
        ageMinPicker.dataSource = self
        heightMinPicker.delegate = self
        heightMinPicker.dataSource = self
        ageMaxPicker.delegate = self
        ageMaxPicker.dataSource = self
        heightMaxPicker.delegate = self
        heightMaxPicker.dataSource = self
        bloodPicker.delegate = self
        bloodPicker.dataSource = self
        prefecturesPicker.delegate = self
        prefecturesPicker.dataSource = self
        
        ageMinPicker.tag = 1
        ageMaxPicker.tag = 11
        heightMinPicker.tag = 2
        heightMaxPicker.tag = 22
        bloodPicker.tag = 3
        prefecturesPicker.tag = 4
        
        Util.rectButton(button: searchButton)
    }
    
    //PickerViewのコンポーネント内の行数を決めるメソッド
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
            dataIntArray = ([Int])(18...80)
            return dataIntArray.count
        case 11:
            dataIntArray = ([Int])(18...80)
            return dataIntArray.count
        case 2:
            dataIntArray = ([Int])(130...220)
            return dataIntArray.count
        case 22:
            dataIntArray = ([Int])(130...220)
            return dataIntArray.count
        case 3:
            dataStringArray = ["A","B","O","AB"]
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
            ageMinTextField.text = String(dataIntArray[row]) + "歳"
            ageMinTextField.resignFirstResponder()
            break
        case 11:
            ageMaxTextField.text = String(dataIntArray[row]) + "歳"
            ageMaxTextField.resignFirstResponder()
            break
        case 2:
            heightMinTextField.text = String(dataIntArray[row]) + "cm"
            heightMinTextField.resignFirstResponder()
            break
        case 22:
            heightMaxTextField.text = String(dataIntArray[row]) + "cm"
            heightMaxTextField.resignFirstResponder()
            break
        case 3:
            bloodTextField.text = dataStringArray[row] + "型"
            bloodTextField.resignFirstResponder()
            break
        case 4:
            prefectureTextField.text = dataStringArray[row]
            prefectureTextField.resignFirstResponder()
            break
        default:
            break
        }
        
        
    }
    
    //PickerViewのコンポーネントに表示するデータを決めるメソッド
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return String(dataIntArray[row]) + "歳"
        case 11:
            return String(dataIntArray[row]) + "歳"
        case 2:
            return String(dataIntArray[row]) + "cm"
        case 22:
            return String(dataIntArray[row]) + "cm"
        case 3:
            return dataStringArray[row] + "型"
        case 4:
            return dataStringArray[row]
            
        default:
            return ""
        }
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func search(_ sender: Any) {
        let loadDBModel = LoadDBModel()
        loadDBModel.getSearchResultProtocol = self
        loadDBModel.loadSearch(ageMin: ageMinTextField.text!, ageMax: ageMaxTextField.text!, heightMin: heightMinTextField.text!, heightMax: heightMaxTextField.text!, blood: bloodTextField.text!, prefecture: prefectureTextField.text!, userData: userData)
    }
    
    func getSearchResultProtocol(userDataModelArray: [UserDataModel], searchDone: Bool) {
        self.userDataModelArray = []
        self.userDataModelArray = userDataModelArray
        
        if let handler = self.resultHandler {
            handler(self.userDataModelArray, searchDone)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

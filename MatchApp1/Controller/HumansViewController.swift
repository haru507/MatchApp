//
//  HumansViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/03.
//

import UIKit
import Firebase
import SDWebImage

class HumansViewController: UIViewController, GetProfileDataProtcol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GetLikeDataProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var asiatoButton: UIButton!
    
    var db = Firestore.firestore()
    var searchORNot = Bool()
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    let itemsPerRow: CGFloat = 2
    var userDataModelArray = [UserDataModel]()
    
    var loadShitaLikeArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Util.rectButton(button: searchButton)
        Util.rectButton(button: asiatoButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillEnterForeground(_:)), name: UIScene.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(_:)), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if Auth.auth().currentUser?.uid != nil && searchORNot == false {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            
            let loadDBModel = LoadDBModel()
            loadDBModel.getProfileDataProtcol = self
            loadDBModel.getLikeDataProtocol = self
//            loadDBModel.loadUsersProfile(gender: userData["gender"] as! String)
            loadDBModel.loadBloackUser()
            
            loadDBModel.loadLikeList()
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).setData(
                ["gender": userData["gender"] as Any, "uid": userData["uid"] as Any, "age": userData["age"] as Any, "height": userData["height"] as Any, "profileImageString": userData["profileImageString"] as Any, "prefecture": userData["prefecture"] as Any, "name": userData["name"] as Any, "quickWord": userData["quickWord"] as Any, "profile": userData["profile"] as Any, "bloodType": userData["bloodType"] as Any, "work": userData["work"] as Any]
            )
            
            loadDBModel.loadMatchingPersonData()            
        }else if Auth.auth().currentUser?.uid != nil && searchORNot == true {
            collectionView.reloadData()
        }else {
            performSegue(withIdentifier: "inputVC", sender: nil)
        }
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification?) {
        Util.updateOnlineStatus(onlineORNot: true)
    }
    
    @objc func didEnterBackground(_ notification: Notification?) {
        Util.updateOnlineStatus(onlineORNot: false)
    }
    
    func getProfileData(userDataModelArray: [UserDataModel]) {
        var deleteArray = [Int]()
        var count = 0
        
        loadShitaLikeArray = []
        self.userDataModelArray = userDataModelArray
        loadShitaLikeArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
        
        for i in 0..<self.userDataModelArray.count {
            if loadShitaLikeArray.contains(self.userDataModelArray[i].uid!) == true {
                deleteArray.append(i)
            }
        }
        
        for i in 0..<deleteArray.count {
            self.userDataModelArray.remove(at: deleteArray[i] - count)
            count += 1
        }
        
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userDataModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        print((itemsPerRow + 1) * sectionInsets.left)
        
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 42)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
//        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = true
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.sd_setImage(with: URL(string: userDataModelArray[indexPath.row].profileImageString!), completed: nil)
        
        imageView.layer.cornerRadius = imageView.frame.width / 2
        
        let ageLabel = cell.contentView.viewWithTag(2) as! UILabel
        ageLabel.text = userDataModelArray[indexPath.row].age
        
        let prefectureLabel = cell.contentView.viewWithTag(3) as! UILabel
        prefectureLabel.text = userDataModelArray[indexPath.row].prefecture
        
        let onLineMarkImageView = cell.contentView.viewWithTag(4) as! UIImageView
        onLineMarkImageView.layer.cornerRadius = onLineMarkImageView.frame.width / 2
        
        if userDataModelArray[indexPath.row].onlineORNot == true {
            onLineMarkImageView.image = UIImage(named: "online")
        }else {
            onLineMarkImageView.image = UIImage(named: "offLine")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as! ProfileViewController
        
        profileVC.userDataModel = userDataModelArray[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    @IBAction func search(_ sender: Any) {
        performSegue(withIdentifier: "searchVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchVC" {
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            
            let searchVC = segue.destination as? SearchViewController
            searchVC?.userData = userData["gender"] as! String
            
            searchVC?.resultHandler = { userDataModelArray, searchDone in
                self.searchORNot = searchDone
                self.userDataModelArray = userDataModelArray
                self.collectionView.reloadData()
            }
        }
    }
    
    func getLikeDataProtocol(userDataModelArray: [UserDataModel]) {
        var count = 0
        var likeArray = [Int]()
        
        for i in 0..<userDataModelArray.count {
            if self.userDataModelArray.contains(userDataModelArray[i]) == true {
                likeArray.append(i)
            }
        }
        
        for i in 0..<likeArray.count {
            self.userDataModelArray.remove(at: likeArray[i] - count)
            count += 1
        }
        
        self.collectionView.reloadData()
    }
    
}

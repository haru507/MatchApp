//
//  LoadDBModel.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/03.
//

import Foundation
import Firebase
import KeychainSwift

protocol GetProfileDataProtcol {
    func getProfileData(userDataModelArray: [UserDataModel])
}

protocol GetLikeCountProtcol {
    func getLikeCount(likeCount: Int, likeFlag: Bool)
}

protocol GetLikeDataProtocol {
    func getLikeDataProtocol(userDataModelArray: [UserDataModel])
}

protocol GetWhoisMatchListProtocol {
    func getWhoisMatchListProtocol(userModelArray: [UserDataModel])
}

protocol GetAsiatoDataProtocol {
    func getAsiatoDataProtocol(userDataModelArray: [UserDataModel])
}

protocol GetSearchResultProtocol {
    func getSearchResultProtocol(userDataModelArray: [UserDataModel], searchDone: Bool)
}

class LoadDBModel {
    var db = Firestore.firestore()
    var profileModelArray = [UserDataModel]()
    var getProfileDataProtcol: GetProfileDataProtcol?
    var getLikeCountProtcol: GetLikeCountProtcol?
    var getLikeDataProtocol: GetLikeDataProtocol?
    var getWhoisMatchListProtocol: GetWhoisMatchListProtocol?
    var getAsiatoDataProtocol: GetAsiatoDataProtocol?
    var getSearchResultProtocol: GetSearchResultProtocol?
    
    var matchingIDArray = [String]()
    var blockUserID = [String]()
    
    let userData = KeyChainConfig.getKeyArrayData(key: "userData")
    
    func loadBloackUser() {
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("block").addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                self.blockUserID = []
                
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let id = data["blockID"] as? String {
                        self.blockUserID.append(id)
                    }
                }
            }
            self.loadUsersProfile(gender: self.userData["gender"] as! String)
        }
    }
    
    func loadUsersProfile(gender: String) {
        let ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
        
        db.collection("Users").whereField("gender", isNotEqualTo: gender).addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                self.profileModelArray = []
                
                for doc in snapShotDoc {
                    let data = doc.data()
                    
                   
                    if ownLikeListArray.contains(data["uid"] as! String) != true {
                        
                        if let name = data["name"] as? String, let age = data["age"] as? String, let height = data["height"] as? String, let bloodType = data["bloodType"] as? String, let prefecture = data["prefecture"] as? String, let gender = data["gender"] as? String, let profile = data["profile"] as? String, let profileImageString = data["profileImageString"] as? String, let uid = data["uid"] as? String, let quickWord = data["quickWord"] as? String, let work = data["work"] as? String, let onlineORNot = data["onlineORNot"] as? Bool {
                            
                            if self.blockUserID.contains(data["uid"] as! String) != true {
                                let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineORNot: onlineORNot)
                                
                                self.profileModelArray.append(userDataModel)
                                self.getProfileDataProtcol?.getProfileData(userDataModelArray: self.profileModelArray)
                            }
                        }
                    }else {
                        if let name = data["name"] as? String, let age = data["age"] as? String, let height = data["height"] as? String, let bloodType = data["bloodType"] as? String, let prefecture = data["prefecture"] as? String, let gender = data["gender"] as? String, let profile = data["profile"] as? String, let profileImageString = data["profileImageString"] as? String, let uid = data["uid"] as? String, let quickWord = data["quickWord"] as? String, let work = data["work"] as? String, let onlineORNot = data["onlineORNot"] as? Bool {
                            
                            if self.blockUserID.contains(data["uid"] as! String) != true {
                                let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineORNot: onlineORNot)
                                
                                self.profileModelArray.append(userDataModel)
                                self.getProfileDataProtcol?.getProfileData(userDataModelArray: self.profileModelArray)
                            }
                        }
                    }
                    
                }
            }
                    
//                    if ownLikeListArray.contains(data["uid"] as! String) != true {
//
//                        if let name = data["name"] as? String, let age = data["age"] as? String, let height = data["height"] as? String, let bloodType = data["bloodType"] as? String, let prefecture = data["prefecture"] as? String, let gender = data["gender"] as? String, let profile = data["profile"] as? String, let profileImageString = data["profileImageString"] as? String, let uid = data["uid"] as? String, let quickWord = data["quickWord"] as? String, let work = data["work"] as? String, let onlineORNot = data["onlineORNot"] as? Bool {
//
//                            if self.blockUserID.contains(data["uid"] as! String) != true {
//                                let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineORNot: onlineORNot)
//
//                                self.profileModelArray.append(userDataModel)
//                                self.getProfileDataProtcol?.getProfileData(userDataModelArray: self.profileModelArray)
//                            }
//                        }
//                    }
        }
        
    }
    
    func loadLikeCount(uuid: String) {
        var likeFlag = Bool()
        db.collection("Users").document(uuid).collection("like").addSnapshotListener { snapShot, error in
            if error != nil {
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                for doc in snapShotDoc {
                    let data = doc.data()
                    if doc.documentID == Auth.auth().currentUser?.uid {
                        if let like = data["like"] as? Bool {
                            likeFlag = like
                        }
                    }
                }
                
                let docCount = snapShotDoc.count
                self.getLikeCountProtcol?.getLikeCount(likeCount: docCount, likeFlag: likeFlag)
            }
        }
    }
    
    func loadLikeList() {
//        self.profileModelArray = []
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                self.profileModelArray = []
                
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let name = data["name"] as? String, let age = data["age"] as? String, let height = data["height"] as? String, let bloodType = data["bloodType"] as? String, let prefecture = data["prefecture"] as? String, let gender = data["gender"] as? String, let profile = data["profile"] as? String, let profileImageString = data["profileImageString"] as? String, let uid = data["uid"] as? String, let quickWord = data["quickWord"] as? String, let work = data["work"] as? String {
                        
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineORNot: true)
                        
                        self.profileModelArray.append(userDataModel)
                        
                    }
                }
                
                self.getLikeDataProtocol?.getLikeDataProtocol(userDataModelArray: self.profileModelArray)
            }
        }
    }
    
    func loadMatchingPersonData() {
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").addSnapshotListener { snapShot, error in
            if error != nil {
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                self.profileModelArray = []
                
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let name = data["name"] as? String, let age = data["age"] as? String, let height = data["height"] as? String, let bloodType = data["bloodType"] as? String, let prefecture = data["prefecture"] as? String, let gender = data["gender"] as? String, let profile = data["profile"] as? String, let profileImageString = data["profileImageString"] as? String, let uid = data["uid"] as? String, let quickWord = data["quickWord"] as? String, let work = data["work"] as? String {
                        
                        self.matchingIDArray = KeyChainConfig.getKeyArrayListData(key: "matchingID")
                        
                        if self.matchingIDArray.contains(where: {$0 == uid}) == false {
                            
                            if uid == Auth.auth().currentUser?.uid {
                                self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
                            }else {
                                Util.matchNotificatin(name: name, id: uid)
                                
                                self.matchingIDArray.append(uid)
                                KeyChainConfig.setKeyArrayData(value: self.matchingIDArray, key: "matchingID")
                            }
                        }
                        
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineORNot: true)
                        
                        self.profileModelArray.append(userDataModel)
                    }
                    
                }
                
                self.getWhoisMatchListProtocol?.getWhoisMatchListProtocol(userModelArray: self.profileModelArray)
            }
        }
    }
    
    func loadAsiatoData() {
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("asiato").order(by: "date").addSnapshotListener { snapShot, error in
            if error != nil {
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                self.profileModelArray = []
                for doc in snapShotDoc {
                    let data = doc.data()
                    
                    if let name = data["name"] as? String, let age = data["age"] as? String, let height = data["height"] as? String, let bloodType = data["bloodType"] as? String, let prefecture = data["prefecture"] as? String, let gender = data["gender"] as? String, let profile = data["profile"] as? String, let profileImageString = data["profileImageString"] as? String, let uid = data["uid"] as? String, let quickWord = data["quickWord"] as? String, let work = data["work"] as? String, let date = data["date"] as? Double {
                        
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: date, onlineORNot: true)
                        
                        self.profileModelArray.append(userDataModel)
                    }
                }
                
                self.getAsiatoDataProtocol?.getAsiatoDataProtocol(userDataModelArray: self.profileModelArray)
            }
        }
    }
    
    func loadSearch(ageMin: String, ageMax: String, heightMin: String, heightMax: String, blood: String, prefecture: String, userData: String) {
        db.collection("Users").whereField("age", isLessThan: ageMax).addSnapshotListener { snapShot, error in
            if error != nil {
                print(error as Any)
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                self.profileModelArray = []
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let name = data["name"] as? String, let age = data["age"] as? String, let height = data["height"] as? String, let bloodType = data["bloodType"] as? String, let prefecture = data["prefecture"] as? String, let gender = data["gender"] as? String, let profile = data["profile"] as? String, let profileImageString = data["profileImageString"] as? String, let uid = data["uid"] as? String, let quickWord = data["quickWord"] as? String, let work = data["work"] as? String, let onlineORNot = data["onlineORNot"] as? Bool {
                        
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineORNot: onlineORNot)
                        
                        self.profileModelArray.append(userDataModel)
                    }
                }
                self.profileModelArray = self.profileModelArray.filter({
                    $0.bloodType == blood && $0.prefecture == prefecture && $0.age! >= ageMin && $0.age! <= ageMin && $0.height! >= heightMin && $0.height! <= heightMax && $0.gender != userData
                    
                })
                
                self.getSearchResultProtocol?.getSearchResultProtocol(userDataModelArray: self.profileModelArray, searchDone: true)
            }
        }
    }
    
}

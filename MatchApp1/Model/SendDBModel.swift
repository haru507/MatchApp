//
//  sendDBModel.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/02.
//

import Foundation
import Firebase

protocol ProfileSendDone {
    func profileSendDone()
}

protocol LikeSendDelegate {
    func like()
}

protocol GetAttachProtocol {
    func getAttachProtocol(attachImageString: String)
}

class SendDBModel {
    
    let db  = Firestore.firestore()
    var profileSendDone: ProfileSendDone?
    var likeSendDelegate: LikeSendDelegate?
    var getAttachProtocol: GetAttachProtocol?
    
    func sendProfileData(userData: UserDataModel, profileImageData: Data) {
        let imageRef = Storage.storage().reference().child("ProfileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(profileImageData, metadata: nil) { metaData, error in
            if error != nil {
                return
            }
            
            imageRef.downloadURL { url, error in
                if error != nil {
                    return
                }
                
                if url != nil {
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
                        ["name": userData.name as Any, "age": userData.age as Any, "height": userData.height as Any, "bloodType": userData.bloodType as Any, "prefecture": userData.prefecture as Any, "gender": userData.gender as Any, "profile": userData.profile as Any, "profileImageString": url?.absoluteString as Any, "uid": Auth.auth().currentUser!.uid as Any, "quickWord": userData.quickWord as Any, "work": userData.work as Any, "onlineORNot": userData.onlineORNot as Any]
                    )
                    
                    KeyChainConfig.setKeyData(value: ["name": userData.name as Any, "age": userData.age as Any, "height": userData.height as Any, "bloodType": userData.bloodType as Any, "prefecture": userData.prefecture as Any, "gender": userData.gender as Any, "profile": userData.profile as Any, "profileImageString": url?.absoluteString as Any, "uid": Auth.auth().currentUser!.uid as Any, "quickWord": userData.quickWord as Any, "work": userData.work as Any], key: "userData")
                    
                    
                    
                    self.profileSendDone?.profileSendDone()
                }
            }
        }
    }
    
    func sendToLike(likeFlag: Bool, thisUserID: String) {
        if likeFlag == false {
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like": false])
            
            deleteToLike(thisUserID: thisUserID)
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.removeAll(where: {$0 == thisUserID})
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            print(ownLikeListArray.debugDescription)
            
            
            
            
        }else if likeFlag == true {
            
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like": true, "gender": userData["gender"] as Any, "uid": userData["uid"] as Any, "age": userData["age"] as Any, "height": userData["height"] as Any, "profileImageString": userData["profileImageString"] as Any, "prefecture": userData["prefecture"] as Any, "name": userData["name"] as Any, "quickWord": userData["quickWord"] as Any, "profile": userData["profile"] as Any, "bloodType": userData["bloodType"] as Any, "work": userData["work"] as Any])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).setData(["like": true, "gender": userData["gender"] as Any, "uid": userData["uid"] as Any, "age": userData["age"] as Any, "height": userData["height"] as Any, "profileImageString": userData["profileImageString"] as Any, "prefecture": userData["prefecture"] as Any, "name": userData["name"] as Any, "quickWord": userData["quickWord"] as Any, "profile": userData["profile"] as Any, "bloodType": userData["bloodType"] as Any, "work": userData["work"] as Any])
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.append(thisUserID)
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            self.likeSendDelegate?.like()
            
        }
    }
    
    func deleteToLike(thisUserID: String) {
        self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).delete()
        
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(thisUserID).delete()
        
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).delete()
    }
    
    
    func sendToLikeFromLike(likeFlag: Bool, thisUserID: String, matchName: String, matchID: String){
        if likeFlag == false {
            
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like": false])
            
            deleteToLike(thisUserID: thisUserID)
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.removeAll(where: {$0 == thisUserID})
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
        }else if likeFlag == true {
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like": true, "gender": userData["gender"] as Any, "uid": userData["uid"] as Any, "age": userData["age"] as Any, "height": userData["height"] as Any, "profileImageString": userData["profileImageString"] as Any, "prefecture": userData["prefecture"] as Any, "name": userData["name"] as Any, "quickWord": userData["quickWord"] as Any, "profile": userData["profile"] as Any, "bloodType": userData["bloodType"] as Any, "work": userData["work"] as Any  ])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLiked").document(thisUserID).setData(["like": true, "gender": userData["gender"] as Any, "uid": userData["uid"] as Any, "age": userData["age"] as Any, "height": userData["height"] as Any, "profileImageString": userData["profileImageString"] as Any, "prefecture": userData["prefecture"] as Any, "name": userData["name"] as Any, "quickWord": userData["quickWord"] as Any, "profile": userData["profile"] as Any, "bloodType": userData["bloodType"] as Any, "work": userData["work"] as Any  ])
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.append(thisUserID)
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            Util.matchNotificatin(name: matchName, id: matchID)
            
            deleteToLike(thisUserID: Auth.auth().currentUser!.uid)
            deleteToLike(thisUserID: matchID)
            
            self.db.collection("Users").document(matchID).collection("matching").document(matchID).delete()
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).delete()
            
            self.likeSendDelegate?.like()
        }
        
    }
    
    func sendToMatchingList(thisUserID: String, name: String, age: String, bloodType: String, height: String, prefecture: String, gender: String, profile: String, profileImageString: String, uid: String, quickword: String, work: String, userData: [String: Any]) {
        
        if thisUserID == uid {
            self.db.collection("Users").document(thisUserID).collection("matching").document(Auth.auth().currentUser!.uid).setData(
                ["gender": userData["gender"] as Any, "uid": userData["uid"] as Any, "age": userData["age"] as Any, "height": userData["height"] as Any, "profileImageString": userData["profileImageString"] as Any, "prefecture": userData["prefecture"] as Any, "name": userData["name"] as Any, "quickWord": userData["quickWord"] as Any, "profile": userData["profile"] as Any, "bloodType": userData["bloodType"] as Any, "work": userData["work"] as Any]
            )
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(thisUserID).setData(
                ["gender": gender as Any, "uid": uid as Any, "age": age as Any, "height": height as Any, "profileImageString": profileImageString as Any, "prefecture": prefecture as Any, "name": name as Any, "quickWord": quickword as Any, "profile": profile as Any, "bloodType": bloodType as Any, "work": work as Any  ]
            )
            
        }else {
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(thisUserID).setData(
                ["gender": gender as Any, "uid": uid as Any, "age": age as Any, "height": height as Any, "profileImageString": profileImageString as Any, "prefecture": prefecture as Any, "name": name as Any, "quickWord": quickword as Any, "profile": profile as Any, "bloodType": bloodType as Any, "work": work as Any  ]
            )
        }
        
        self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).delete()
        
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(thisUserID).delete()
        
        
    }
    
    func sendAsiato(aitenoUserID: String) {
        
        let userData = KeyChainConfig.getKeyArrayData(key: "userData")
        
        self.db.collection("Users").document(aitenoUserID).collection("asiato").document(Auth.auth().currentUser!.uid).setData(["like": true, "gender": userData["gender"] as Any, "uid": userData["uid"] as Any, "age": userData["age"] as Any, "height": userData["height"] as Any, "profileImageString": userData["profileImageString"] as Any, "prefecture": userData["prefecture"] as Any, "name": userData["name"] as Any, "quickWord": userData["quickWord"] as Any, "profile": userData["profile"] as Any, "bloodType": userData["bloodType"] as Any, "work": userData["work"] as Any, "date": Date().timeIntervalSince1970 ])
    }
    
    func sendImageData(image: UIImage, senderID: String, toID: String){
        let userData = KeyChainConfig.getKeyArrayData(key: "userData")
        
        let imageRef = Storage.storage().reference().child("ChatImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(image.jpegData(compressionQuality: 0.3)!, metadata: nil) { metaData, error in
            if error != nil {
                return
            }
            
            imageRef.downloadURL { url, error in
                if error != nil {
                    return
                }
                
                if url != nil {
                    self.db.collection("Users").document(senderID).collection("matching").document(toID).collection("chat").document().setData(
                        ["senderID": senderID, "displayName": userData["name"] as Any, "imageURLString": userData["profileImageString"] as Any, "date": Date().timeIntervalSince1970, "attachImageString": url?.absoluteString as Any]
                    )
                    
                    self.db.collection("Users").document(toID).collection("matching").document(senderID).collection("chat").document().setData(
                        ["senderID": senderID, "displayName": userData["name"] as Any, "imageURLString": userData["profileImageString"] as Any, "date": Date().timeIntervalSince1970, "attachImageString": url?.absoluteString as Any]
                    )
                    
                    self.getAttachProtocol?.getAttachProtocol(attachImageString: url!.absoluteString)
                }
            }
        }
    }
    
    func sendMessage(senderID: String, toID: String, text: String, displayName: String, imageURLString: String) {
        self.db.collection("Users").document(senderID).collection("matching").document(toID).collection("chat").document().setData(
            ["text": text as Any, "senderID": senderID as Any, "displayName": displayName as Any, "imageURLString": imageURLString as Any, "date": Date().timeIntervalSince1970]
        )
        
        self.db.collection("Users").document(toID).collection("matching").document(senderID).collection("chat").document().setData(
            ["text": text as Any, "senderID": Auth.auth().currentUser!.uid as Any, "displayName": displayName as Any, "imageURLString": imageURLString as Any, "date": Date().timeIntervalSince1970]
        )
    }
    
    func sendViolations(receiverID: String, text: String) {
        self.db.collection("Violations").document(Auth.auth().currentUser!.uid).setData(
            ["senderID": Auth.auth().currentUser!.uid as Any, "receiverID": receiverID as Any, "text": text as Any]
        )
    }
    
    func sendFormData(category: String, text: String, mail: String) {
        self.db.collection("Form").document(Auth.auth().currentUser!.uid).setData(
            ["uid": Auth.auth().currentUser!.uid as Any, "category": category as Any, "text": text as Any, "mail": mail as Any]
        )
    }
    
    func sendConfirmData(image: Data) {
        
        let imageRef = Storage.storage().reference().child("ConfirmImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(image, metadata: nil) { metaData, error in
            if error != nil {
                return
            }
            
            imageRef.downloadURL { url, error in
                if error != nil {
                    return
                }
                
                if url != nil {
                    self.db.collection("Confirm").document(Auth.auth().currentUser!.uid).setData(
                        ["uid": Auth.auth().currentUser!.uid as Any, "imageURLString": url?.absoluteString as Any]
                    )
                }
            }
        }
    }
    
    func sendBlockUser(otherUserID: String) {
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("block").document(otherUserID).setData(
            ["blockID": otherUserID as Any]
        )
        
        self.db.collection("Users").document(otherUserID).collection("block").document(Auth.auth().currentUser!.uid).setData(
            ["blockID": Auth.auth().currentUser!.uid as Any]
        )
    }
    
    func sendUpdateProfile(userData: UserDataModel, profileImageData: Data){
        let imageRef = Storage.storage().reference().child("ProfileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(profileImageData, metadata: nil) { metaData, error in
            if error != nil {
                return
            }
            
            imageRef.downloadURL { url, error in
                if error != nil {
                    return
                }
                
                if url != nil {
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
                        ["name": userData.name as Any, "age": userData.age as Any, "height": userData.height as Any, "bloodType": userData.bloodType as Any, "prefecture": userData.prefecture as Any, "gender": userData.gender as Any, "profile": userData.profile as Any, "profileImageString": url?.absoluteString as Any, "uid": Auth.auth().currentUser!.uid as Any, "quickWord": userData.quickWord as Any, "work": userData.work as Any, "onlineORNot": userData.onlineORNot as Any]
                    )
                    
                    KeyChainConfig.setKeyData(value: ["name": userData.name as Any, "age": userData.age as Any, "height": userData.height as Any, "bloodType": userData.bloodType as Any, "prefecture": userData.prefecture as Any, "gender": userData.gender as Any, "profile": userData.profile as Any, "profileImageString": url?.absoluteString as Any, "uid": Auth.auth().currentUser!.uid as Any, "quickWord": userData.quickWord as Any, "work": userData.work as Any], key: "userData")
                    
                    
                    
//                    self.profileSendDone?.profileSendDone()
                }
            }
        }
    }
}

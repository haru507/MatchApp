//
//  KeyChainConfig.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/03.
//

import Foundation
import KeychainSwift

class KeyChainConfig {
    
    
    
    static func getKeyData(key: String) -> String {
        let keyChain = KeychainSwift()
        let keyString = keyChain.get(key)
        return keyString!
    }
    
    static func setKeyData(value: [String:Any], key: String){
        let keyChain = KeychainSwift()
        let archiveData = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        keyChain.set(archiveData, forKey: key)
    }
    
    static func getKeyArrayData(key: String) -> [String:Any] {
        let keyChain = KeychainSwift()
        let keyData = keyChain.getData(key)
        if keyData != nil {
            let unarchiveObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keyData!) as! [String:Any]
            return unarchiveObject
        }else {
            return [:]
        }
    }
    
    static func getKeyArrayListData(key: String) -> [String] {
        let keyChain = KeychainSwift()
        let keyData = keyChain.getData(key)
        if keyData != nil {
            let unarchiveObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keyData!) as! [String]
            return unarchiveObject
        }else {
            return []
        }
    }
    
    static func setKeyArrayData(value: [String], key: String) {
        let keyChain = KeychainSwift()
        let archiveData = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        keyChain.set(archiveData, forKey: key)
    }
    
}

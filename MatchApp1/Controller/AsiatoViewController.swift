//
//  AsiatoViewController.swift
//  MatchApp1
//
//  Created by 石井治樹 on 2021/08/06.
//

import UIKit

class AsiatoViewController: MatchListViewController, GetAsiatoDataProtocol {
    
    var loadDBModel = LoadDBModel()
    var userDataModelArray = [UserDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        loadDBModel.getAsiatoDataProtocol = self
        loadDBModel.loadAsiatoData()
        
        tableView.register(MatchPersonCell.nib(), forCellReuseIdentifier: MatchPersonCell.identifire)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userDataModelArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchPersonCell.identifire, for: indexPath) as? MatchPersonCell
        
        cell?.configure(nameLabelString: userDataModelArray[indexPath.row].name!, ageLabelString: userDataModelArray[indexPath.row].age!, profileImageViewString: userDataModelArray[indexPath.row].profileImageString!, workLabelString: userDataModelArray[indexPath.row].work!, quickWordLabelString: userDataModelArray[indexPath.row].quickWord!)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC2") as! ProfileViewController
        
        profileVC.userDataModel = userDataModelArray[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func getAsiatoDataProtocol(userDataModelArray: [UserDataModel]) {
        
        self.userDataModelArray = userDataModelArray
        tableView.reloadData()
    }

}

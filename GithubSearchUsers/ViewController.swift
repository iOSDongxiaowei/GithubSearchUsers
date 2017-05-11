//
//  ViewController.swift
//  GithubSearchUsers
//
//  Created by dongxiaowei on 2017/5/8.
//  Copyright © 2017年 iOSDongxiaowei. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UISearchBarDelegate {
    
    

    let searchBar = UISearchBar(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
    let tableView = UITableView(frame:CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
    
    var usersDict = Dictionary<String, Any>()
    var reposArray = Array<Dictionary<String, Any>>()
    var maxLanguage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.createUI()
        
    }
    
    func createUI() -> Void{
        
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        let cellNib = UINib(nibName:"GSUUsersTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "usersTableViewCell")
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : GSUUsersTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "usersTableViewCell", for: indexPath) as! GSUUsersTableViewCell
        
        if self.usersDict.isEmpty
        {
            return cell
        }
        
        
        cell.insertCell(userItem:(self.usersDict["login"] as! String?, self.maxLanguage as String?, self.usersDict["avatar_url"] as! String?))
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        GSUHTTPKit.users(userName: searchBar.text!) { (usersDict, error) -> (Void) in
            guard usersDict != nil else
            {
                print("网络请求失败")
                return
            }
            self.usersDict = usersDict!
            self.needReloadTableView()
        }
        
        GSUHTTPKit.repos(userName: searchBar.text!) { (reposArray, error) -> (Void) in
            guard reposArray != nil else
            {
                print("网络请求失败")
                return
            }
            
            self.reposArray = reposArray!
            var languageArray = Array<String>()
            
            
            
            for repos in self.reposArray
            {
                if ((repos["language"] as? String) == nil)
                {
                    self.maxLanguage = "无"
                    self.needReloadTableView()
                    return
                }
                languageArray.append(repos["language"] as! String)
            }

            var languageDic : Dictionary<String, Int> = Dictionary.init()
            for languageStr in languageArray
            {
                if (languageDic[languageStr] != nil)
                {
                    languageDic[languageStr]! += 1
                }
                else
                {
                    languageDic[languageStr] = 1
                }
            }

            for (z,j)in languageDic
            {
                print("\(z)语言使用了\(j)次")
            }
            
            let numbersArray = languageDic.values
            let maxNumber = numbersArray.max()
            
            for (language,number) in languageDic
            {
                if number ==  maxNumber
                {
                    self.maxLanguage += language
                }
            }
            
            self.needReloadTableView()
        }
    }
    
    var reloadflag = 0
    
    func needReloadTableView()
    {
        reloadflag += 1
        
        if reloadflag == 2
        {
            self.tableView.reloadData()
            reloadflag = 0
        }
        
        
    }

}


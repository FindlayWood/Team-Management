//
//  ViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 22/08/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import CloudKit




class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var addTextBar: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var tableView1: UITableView!
    
    
    let database = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "mySharingZone")
    
    
    var list = [CKRecord]()
    var teamName: String!
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return list.count
    }
    
    @IBAction func addData(_ sender: Any) {
        let alert = UIAlertController(title: "Add Team", message: "Enter the team name.", preferredStyle: .alert)
        alert.addTextField { (teamName) in
            teamName.placeholder = "Enter team name here"
            teamName.autocapitalizationType = .words
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let team = alert.textFields?.first?.text else {return}
            self.saveToCloud(team: team)
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
        
        
        
        
        
        
        
//
//        if addTextBar.text == ""{
//            let alert = UIAlertController(title: "Oops!", message: "You must enter a teamname first.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//        }
//        self.saveToCloud(team: addTextBar.text!)
//        addTextBar.text = ""
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row].value(forKey: "TeamName") as? String
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    func saveToCloud(team: String){
        //let newTeam = CKRecord(recordType: "Teams", zoneID: zone.zoneID)
        let newTeam = CKRecord(recordType: "Teams")
        newTeam.setValue(team, forKey: "TeamName")
        
        
//        database.save(newTeam) { (record, error) in
//            if error != nil{
//                DispatchQueue.main.sync {
//                    print("there was an error: \(error)")
//                }
//            }else{
//                DispatchQueue.main.sync {
//                    print("record saved to sharingzone")
//                }
//            }
//        }
        
        database.save(newTeam) { (record, error) in
            //print(error)
            guard record != nil else {return}
            print("saved record")
        }
        tableView1.reloadData()
    }
    
    @objc func queryDatabase(){
        let query = CKQuery(recordType: "Teams", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (record, error) in
            //query.sortDescriptors = [NSSortDescriptor(key: "teamName", ascending: false)]
            guard let record = record else {return}
            let sortedRecords = record.sorted(by: { $0.creationDate! > $1.creationDate! })
            self.list = sortedRecords
            DispatchQueue.main.async {
                self.tableView1.refreshControl?.endRefreshing()
                self.tableView1?.reloadData()
            }
        }
    }
    
    
    func deleteRecord(at indexPath: IndexPath){
        let record = list[indexPath.row]
        
        
        database.delete(withRecordID: record.recordID) { (recordID, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }else{
                    print("Record was deleted")
                    
                    self.list.remove(at: indexPath.row)
                    
                    self.tableView1.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteRecord(at: indexPath)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(queryDatabase), for: .valueChanged)
        self.tableView1.refreshControl = refreshControl
        queryDatabase()
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController

        SVC.teamLabel = list[indexPath.row].value(forKey: "TeamName") as! String

        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    

}


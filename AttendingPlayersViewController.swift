//
//  AttendingPlayersViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 07/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import CloudKit

class AttendingPlayersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cellLabel: UILabel!
    @IBOutlet var cellButton: UIButton!
    
    var players = [CKRecord]()
    var event: CKRecord!
    var attendees = [String]()
    var alreadyAttending = [String]()
    
    let database = CKContainer.default().privateCloudDatabase
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell") as! TableViewCell
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        
        let first = players[indexPath.row].value(forKey: "FirstName") as! String
        let last = players[indexPath.row].value(forKey: "LastName") as! String
        //cell.textLabel?.text = "\(first) \(last)"
        let name = "\(first) \(last)"
        
        if alreadyAttending.contains(name){
            cell.attendButton.isSelected = true
            cell.backgroundColor = UIColor.green
        }
        
        cell.attendButton.tag = indexPath.row
            
        cell.attendButton.addTarget(self, action: "attendPressed:", for: .touchUpInside)
        
        cell.titleLable.text = "\(first) \(last)"
        
        
        
        
        return cell
    }
    
    @IBAction func attendPressed(_ sender:UIButton){
        let first = self.players[sender.tag].value(forKey: "FirstName") as! String
        let last = self.players[sender.tag].value(forKey: "LastName") as! String
        let name = "\(first) \(last)"
        if sender.isSelected{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        
        
        if alreadyAttending.contains(name){
            let index = alreadyAttending.index(of: name)
            alreadyAttending.remove(at: index!)
            save()
        }
        else{
            alreadyAttending.append(name)
            save()
            
        }
        
        
//        print("attended")
//        let first = self.players[sender.tag].value(forKey: "FirstName") as! String
//        let last = self.players[sender.tag].value(forKey: "LastName") as! String
//        let name = "\(first) \(last)"
//        self.alreadyAttending.append(name)
//        print(first)
//        sender.isHidden = true
        

    }
    func save(){
        self.event.setValue(self.alreadyAttending, forKey: "Attendees")
        
        database.save(event) { (record, error) in
            guard record != nil else {return}
            print("saved record")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        queryDatabase()
        
        
        navigationItem.title = "\(self.event.value(forKey: "Date") as! String) \(self.event.value(forKey: "Event") as! String)"
        
        
        if event.value(forKey: "Attendees") != nil{
            alreadyAttending = (event.value(forKey: "Attendees") as? [String])!
        }
        
        print(alreadyAttending)

        // Do any additional setup after loading the view.
    }
    
    @objc func queryDatabase(){
        let query = CKQuery(recordType: "Players", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (record, error) in
            guard let record = record else {return}
            let sortedRecords = record.sorted(by: { $1.value(forKey: "LastName") as! String > $0.value(forKey: "LastName") as! String})
            for record in sortedRecords{
                if (record.value(forKey: "Availability") as! String) == "Available"{
                    self.players.append(record)
                }
            }
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView?.reloadData()
            }
        }
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

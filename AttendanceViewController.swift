//
//  AttendanceViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 06/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import CloudKit

class AttendanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var events = [CKRecord]()
    
    let database = CKContainer.default().privateCloudDatabase
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func addEvent(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Game", message: "Enter the date of the Game.", preferredStyle: .alert)
        alert.addTextField { (date) in
            let formatter : DateFormatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            let myStr : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
            date.text = "\(myStr)"
            date.keyboardType = .default
            date.returnKeyType = .done
        }
        alert.addTextField { (event) in
            event.placeholder = "Enter event type here."
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let date = alert.textFields?.first?.text else {return}
            guard let event = alert.textFields?.last?.text else {return}
            print(date)
            print(event)
            self.saveToCloud(date: date, event: event)
            
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveToCloud(date: String, event: String){
        let newEvent = CKRecord(recordType: "Events")
        newEvent.setValue(date, forKey: "Date")
        newEvent.setValue(event, forKey: "Event")
        
        database.save(newEvent) { (record, error) in
            //print(error)
            guard record != nil else {return}
            print("saved record")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Events"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent(_:)))
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(queryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        queryDatabase()
        
//        if event.value(forKey: "Attendees") != nil{
//            alreadyAttending = (event.value(forKey: "Attendees") as? [String])!
//        }

        // Do any additional setup after loading the view.
    }
    
    @objc func queryDatabase(){
        let query = CKQuery(recordType: "Events", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (record, error) in
            guard let record = record else {return}
            let sortedRecords = record.sorted(by: { $0.creationDate! > $1.creationDate!})
            self.events = sortedRecords
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let date = events[indexPath.row].value(forKey: "Date") as! String
        let event = events[indexPath.row].value(forKey: "Event")as! String
        cell.accessoryType = .disclosureIndicator
        if events[indexPath.row].value(forKey: "Attendees") != nil{
            let attendees = (events[indexPath.row].value(forKey: "Attendees") as? [String])!
            cell.textLabel?.text = "\(date) \(event) (\(attendees.count))"
        }
        else{
            cell.textLabel?.text = "\(date) \(event) (0)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "AttendingPlayersViewController") as! AttendingPlayersViewController
        SVC.event = events[indexPath.row]
        
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    func deleteRecord(at indexPath: IndexPath){
        let record = events[indexPath.row]
        
        database.delete(withRecordID: record.recordID) { (recordID, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }else{
                    print("Record was deleted")
                    
                    self.events.remove(at: indexPath.row)
                    
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteRecord(at: indexPath)
        }
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

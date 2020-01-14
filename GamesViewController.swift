//
//  GamesViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 02/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import CloudKit

class GamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    let database = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "mySharingZone")
    
    var games = [CKRecord]()
    var players = [String]()
    var looseheads = [String]()
    var tightheads = [String]()
    var frontRow = [String]()
    var secondRow = [String]()
    var backRow = [String]()
    var halfBacks = [String]()
    var centres = [String]()
    var backThree = [String]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addGame(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Game", message: "Enter the date of the Game.", preferredStyle: .alert)
        alert.addTextField { (date) in
            let formatter : DateFormatter = DateFormatter()
            formatter.dateFormat = "d/M/yy"
            let myStr : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
            date.text = "\(myStr)"
        }
        alert.addTextField { (opposition) in
            opposition.placeholder = "Enter opposition name here"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let date = alert.textFields?.first?.text else {return}
            guard let opposition = alert.textFields?.last?.text else {return}
            print(date)
            print(opposition)
            self.saveToCloud(date: date, opposition: opposition)
            
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveToCloud(date: String, opposition: String){
        let newGame = CKRecord(recordType: "Games")
        newGame.setValue(date, forKey: "Date")
        newGame.setValue(opposition, forKey: "Opposition")
        
        database.save(newGame) { (record, error) in
            //print(error)
            guard record != nil else {return}
            print("saved record")
        }
    }
    
    
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let date = games[indexPath.row].value(forKey: "Date") as! String
        let opposition = games[indexPath.row].value(forKey: "Opposition") as! String
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "\(date) vs \(opposition)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "buttonPageViewController") as! buttonPageViewController
        
        SVC.game = games[indexPath.row].value(forKey: "Date") as! String
        SVC.players = self.players
        SVC.opponent = games[indexPath.row].value(forKey: "Opposition") as! String
        SVC.team = games[indexPath.row]
        SVC.looseheads = looseheads
        SVC.tightheads = tightheads
        SVC.frontRow = frontRow
        SVC.secondRow = secondRow
        SVC.backRow = backRow
        SVC.halfBacks = halfBacks
        SVC.centres = centres
        SVC.backThree = backThree
        
        
        
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    @objc func queryDatabase(){
        let query = CKQuery(recordType: "Games", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (record, error) in
            guard let record = record else {return}
            let sortedRecords = record.sorted(by: { $0.creationDate! > $1.creationDate! })
            self.games = sortedRecords
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView?.reloadData()
            }
        }
    }
    
    func deleteRecord(at indexPath: IndexPath){
        let record = games[indexPath.row]
        
        database.delete(withRecordID: record.recordID) { (recordID, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }else{
                    print("Record was deleted")
                    
                    self.games.remove(at: indexPath.row)
                    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGame(_:)))
        navigationItem.title = "Games"
        
//        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.blue]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(queryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        queryDatabase()

        // Do any additional setup after loading the view.
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

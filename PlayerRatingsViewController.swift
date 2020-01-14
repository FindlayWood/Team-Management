//
//  PlayerRatingsViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 12/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import CloudKit

class PlayerRatingsViewController: UIViewController {
    
    let database = CKContainer.default().privateCloudDatabase
    
    var players: CKRecord!
    
    @IBOutlet var techLabel: UILabel!
    @IBOutlet var tactLabel: UILabel!
    @IBOutlet var physLabel: UILabel!
    @IBOutlet var mentLabel: UILabel!
    
    @IBOutlet var p1name: UITextField!
    @IBOutlet var p2name: UITextField!
    @IBOutlet var p3name: UITextField!
    @IBOutlet var p4name: UITextField!
    @IBOutlet var p5name: UITextField!
    
    @IBOutlet var p1tech: UITextField!
    @IBOutlet var p1tact: UITextField!
    @IBOutlet var p1phys: UITextField!
    @IBOutlet var p1ment: UITextField!
    @IBOutlet var p2tech: UITextField!
    @IBOutlet var p2tact: UITextField!
    @IBOutlet var p2phys: UITextField!
    @IBOutlet var p2ment: UITextField!
    @IBOutlet var p3tech: UITextField!
    @IBOutlet var p3tact: UITextField!
    @IBOutlet var p3phys: UITextField!
    @IBOutlet var p3ment: UITextField!
    @IBOutlet var p4tech: UITextField!
    @IBOutlet var p4tact: UITextField!
    @IBOutlet var p4phys: UITextField!
    @IBOutlet var p4ment: UITextField!
    @IBOutlet var p5tech: UITextField!
    @IBOutlet var p5tact: UITextField!
    @IBOutlet var p5phys: UITextField!
    @IBOutlet var p5ment: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePressed(_:)))
        
        techLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        tactLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        physLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        mentLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        display(shirtnumber: 1, namefield: p1name, techfield: p1tech, tactfield: p1tact, physfield: p1phys, mentfield: p1ment)
        display(shirtnumber: 2, namefield: p2name, techfield: p2tech, tactfield: p2tact, physfield: p2phys, mentfield: p2ment)
        display(shirtnumber: 3, namefield: p3name, techfield: p3tech, tactfield: p3tact, physfield: p3phys, mentfield: p3ment)
        display(shirtnumber: 4, namefield: p4name, techfield: p4tech, tactfield: p4tact, physfield: p4phys, mentfield: p4ment)
        display(shirtnumber: 5, namefield: p5name, techfield: p5tech, tactfield: p5tact, physfield: p5phys, mentfield: p5ment)
        

        // Do any additional setup after loading the view.
    }
    
    func display(shirtnumber: Int, namefield: UITextField, techfield: UITextField, tactfield: UITextField, physfield: UITextField, mentfield: UITextField){
        namefield.text = players.value(forKey: "P\(shirtnumber)") as? String
        techfield.text = players.value(forKey: "P\(shirtnumber)TechnicalRating") as? String
        tactfield.text = players.value(forKey: "P\(shirtnumber)TacticalRating") as? String
        physfield.text = players.value(forKey: "P\(shirtnumber)PhysicalRating") as? String
        mentfield.text = players.value(forKey: "P\(shirtnumber)MentalRating") as? String
    }
    
    @IBAction func savePressed(_ sender:Any){
        ratings(shirtnumber: 1, techField: p1tech, tactField: p1tact, physField: p1phys, mentField: p1ment)
        ratings(shirtnumber: 2, techField: p2tact, tactField: p2tact, physField: p2phys, mentField: p2ment)
        ratings(shirtnumber: 3, techField: p3tact, tactField: p3tact, physField: p3phys, mentField: p3ment)
        ratings(shirtnumber: 4, techField: p4tact, tactField: p4tact, physField: p4phys, mentField: p4ment)
        ratings(shirtnumber: 5, techField: p5tact, tactField: p5tact, physField: p5phys, mentField: p5ment)
        
        database.save(players){ (record, error) in
            print(error)
            guard record != nil else {return}
            print("updated record")
        }
        
    }
    func ratings(shirtnumber: Int, techField: UITextField, tactField: UITextField, physField: UITextField, mentField: UITextField){
        if techField.text != nil{
            players.setValue(techField.text, forKey: "P\(shirtnumber)TechnicalRating")
        }
        if tactField.text != nil{
            players.setValue(tactField.text, forKey: "P\(shirtnumber)TacticalRating")
        }
        if physField.text != nil{
            players.setValue(physField.text, forKey: "P\(shirtnumber)PhysicalRating")
        }
        if mentField.text != nil{
            players.setValue(mentField.text, forKey: "P\(shirtnumber)MentalRating")
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

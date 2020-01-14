//
//  GameCommentsViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 03/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import CloudKit

class GameCommentsViewController: UIViewController {
    
    var game: CKRecord!
    
    let database = CKContainer.default().privateCloudDatabase
    
    @IBOutlet var goodPoints: UITextView!
    @IBOutlet var workOns: UITextView!
    @IBOutlet var refComments: UITextView!
    
    @IBAction func savePressed(_ sender:Any){
        game.setValue(goodPoints.text, forKey: "GoodPoints")
        game.setValue(workOns.text, forKey: "WorkOns")
        game.setValue(refComments.text, forKey: "RefComments")
        
        database.save(game) { (record, error) in
            print(error)
            guard record != nil else {return}
            print("updated record")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        goodPoints.text = game.value(forKey: "GoodPoints") as? String
        workOns.text = game.value(forKey: "WorkOns") as? String
        refComments.text = game.value(forKey: "RefComments") as? String

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

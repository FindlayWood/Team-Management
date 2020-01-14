//
//  GameInfoViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 02/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import CloudKit

class GameInfoViewController: UIViewController {
    
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var oppositionTextField: UITextField!
    @IBOutlet var scoreTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var triesTextField: UITextField!
    @IBOutlet var convTextfield: UITextField!
    @IBOutlet var penaltyTextField: UITextField!
    @IBOutlet var dropTextField: UITextField!
    @IBOutlet var yellowTextField: UITextField!
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var pensWonTextField: UITextField!
    @IBOutlet var pensConTextField: UITextField!
    
    var date:String!
    var opponent:String!
    var game: CKRecord!
    
    let database = CKContainer.default().privateCloudDatabase

    
    
    @IBAction func editPressed(_ sender:Any){
        dateTextField.isUserInteractionEnabled = true
        oppositionTextField.isUserInteractionEnabled = true
        scoreTextField.isUserInteractionEnabled = true
        locationTextField.isUserInteractionEnabled = true
        triesTextField.isUserInteractionEnabled = true
        convTextfield.isUserInteractionEnabled = true
        penaltyTextField.isUserInteractionEnabled = true
        dropTextField.isUserInteractionEnabled = true
        yellowTextField.isUserInteractionEnabled = true
        redTextField.isUserInteractionEnabled = true
        pensWonTextField.isUserInteractionEnabled = true
        pensConTextField.isUserInteractionEnabled = true
        saveButton.isHidden = false
    }
    
    @IBAction func savePressed(_ sender:Any){
        dateTextField.isUserInteractionEnabled = false
        oppositionTextField.isUserInteractionEnabled = false
        scoreTextField.isUserInteractionEnabled = false
        locationTextField.isUserInteractionEnabled = false
        triesTextField.isUserInteractionEnabled = false
        convTextfield.isUserInteractionEnabled = false
        penaltyTextField.isUserInteractionEnabled = false
        dropTextField.isUserInteractionEnabled = false
        yellowTextField.isUserInteractionEnabled = false
        redTextField.isUserInteractionEnabled = false
        pensWonTextField.isUserInteractionEnabled = false
        pensConTextField.isUserInteractionEnabled = false
        saveButton.isHidden = true
        
        game.setValue(scoreTextField.text, forKey: "Score")
        game.setValue(locationTextField.text, forKey: "Location")
        game.setValue(triesTextField.text, forKey: "Tries")
        game.setValue(convTextfield.text, forKey: "Conversions")
        game.setValue(penaltyTextField.text, forKey: "Penalties")
        game.setValue(dropTextField.text, forKey: "DropGoals")
        game.setValue(yellowTextField.text, forKey: "YellowCards")
        game.setValue(redTextField.text, forKey: "RedCards")
        game.setValue(pensWonTextField.text, forKey: "PenaltiesWon")
        game.setValue(pensConTextField.text, forKey: "PenaltiesConceded")
        
        database.save(game) { (record, error) in
            print(error)
            guard record != nil else {return}
            print("updated record")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
        dateTextField.text = date
        oppositionTextField.text = opponent
        locationTextField.text = game.value(forKey: "Location") as? String
        triesTextField.text = game.value(forKey: "Tries") as? String
        convTextfield.text = game.value(forKey: "Conversions") as? String
        penaltyTextField.text = game.value(forKey: "Penalties") as? String
        dropTextField.text = game.value(forKey: "DropGoals") as? String
        yellowTextField.text = game.value(forKey: "YellowCards") as? String
        redTextField.text = game.value(forKey: "RedCards") as? String
        pensWonTextField.text = game.value(forKey: "PenaltiesWon") as? String
        pensConTextField.text = game.value(forKey: "PenaltiesConceded") as? String
        
        if game.value(forKey: "Score") != nil{
            scoreTextField.text = game.value(forKey: "Score") as? String
        }
        else{
            var home = String()
            var away = String()
            if game.value(forKey: "HomeScore") != nil{
                home = game.value(forKey: "HomeScore") as! String
            }
            if game.value(forKey: "AwayScore") != nil{
                away = game.value(forKey: "AwayScore") as! String
            }
            
            scoreTextField.text = "\(home) - \(away)"
        }
        
        
        navigationItem.title = "Game Info"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPressed(_:)))
        

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

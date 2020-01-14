//
//  ThirdViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 26/08/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import CloudKit

class ThirdViewController: SecondViewController{
    
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var age: UITextField!
    @IBOutlet var position: UITextField!
    @IBOutlet var secondaryPosition: UITextField!
    
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var availability: UITextField!
    
    @IBOutlet var technical: UITextField!
    @IBOutlet var tactical: UITextField!
    @IBOutlet var physical: UITextField!
    @IBOutlet var mental: UITextField!
    @IBOutlet var overall: UITextField!
    @IBOutlet var sruNumber: UITextField!
    
    
    
    let database3 = CKContainer.default().privateCloudDatabase
    
    var newDatabase2 = String()
    var availabilitySelections = ["Available", "Not Available", "Injured"]
    var positions = ["", "Loosehead Prop", "Hooker", "Tighthead Prop", "Second Row", "Flanker", "Number 8", "Scrum Half", "Fly Half", "Inside Centre", "Outside Centre", "Winger", "Fullback"]
    
    @IBAction func techPressed(_sender: Any){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! TechPopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func tactPressed(_sender: Any){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tactPopUpID") as! TactPopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func physPressed(_sender: Any){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "physPopUpID") as! PhysPopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func mentPressed(_sender: Any){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mentPopUpID") as! MenPopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    
    
    
    
    
    
    
    @IBAction func addPlayerButton(_ sender: Any) {
        if firstName.text == "" || lastName.text == ""{
            let alert = UIAlertController(title: "Oops!", message: "You must fill in atleast First and Last name to add player.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            addPlayerToCloud()
            firstName.text = ""
            lastName.text = ""
            age.text = ""
            position.text = ""
            secondaryPosition.text = ""
            phoneNumber.text = ""
            email.text = ""
            availability.text = ""
            sruNumber.text = ""
            technical.text = ""
            tactical.text = ""
            physical.text = ""
            mental.text = ""
            overall.text = ""
            team.text = "Player added!"
        }
        
    }
    
    
    
    

    var teamNames:String = ""
    @IBOutlet var team: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.returnKeyType = UIReturnKeyType.done
        firstName.delegate = self as UITextFieldDelegate
        lastName.delegate = self as UITextFieldDelegate
        email.delegate = self as UITextFieldDelegate
        technical.delegate = self as UITextFieldDelegate
        tactical.delegate = self as UITextFieldDelegate
        mental.delegate = self as UITextFieldDelegate
        physical.delegate = self as UITextFieldDelegate
        overall.delegate = self as UITextFieldDelegate
        
        
        let availabilityPicker = UIPickerView() 
        availability.inputView = availabilityPicker
        position.inputView = availabilityPicker
        secondaryPosition.inputView = availabilityPicker
        
        availabilityPicker.delegate = self
        
        team.text = teamNames
        print(teamNames)
        newDatabase2 = "\(teamNames)Players"
        print(newDatabase2)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height:40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(TeamListViewController.donePressed))
        
        toolBar.setItems([doneButton], animated: true)
        
        availability.inputAccessoryView = toolBar
        position.inputAccessoryView = toolBar
        secondaryPosition.inputAccessoryView = toolBar
        //firstName.inputAccessoryView = toolBar
        //lastName.inputAccessoryView = toolBar
        age.inputAccessoryView = toolBar
        //email.inputAccessoryView = toolBar
        phoneNumber.inputAccessoryView = toolBar
        sruNumber.inputAccessoryView = toolBar
        //technical.inputAccessoryView = toolBar
        //tactical.inputAccessoryView = toolBar
        //physical.inputAccessoryView = toolBar
        //mental.inputAccessoryView = toolBar
        //overall.inputAccessoryView = toolBar
        
        availability.text = "Available"
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        availability.resignFirstResponder()
        position.resignFirstResponder()
        secondaryPosition.resignFirstResponder()
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        age.resignFirstResponder()
        email.resignFirstResponder()
        phoneNumber.resignFirstResponder()
        sruNumber.resignFirstResponder()
        technical.resignFirstResponder()
        tactical.resignFirstResponder()
        physical.resignFirstResponder()
        mental.resignFirstResponder()
        overall.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func addPlayerToCloud(){
        let newPlayer = CKRecord(recordType: "Players")
        newPlayer.setValue(firstName.text, forKey: "FirstName")
        newPlayer.setValue(lastName.text, forKey: "LastName")
        newPlayer.setValue(Int(age.text!), forKey: "Age")
        newPlayer.setValue(position.text, forKey: "Position")
        newPlayer.setValue(secondaryPosition.text, forKey: "SecondaryPosition")
        newPlayer.setValue(phoneNumber.text, forKey: "PhoneNumber")
        newPlayer.setValue(email.text, forKey: "Email")
        newPlayer.setValue(availability.text, forKey: "Availability")
        newPlayer.setValue(sruNumber.text, forKey: "SRUNumber")
        newPlayer.setValue(Double(technical.text!), forKey: "Technical")
        newPlayer.setValue(Double(tactical.text!), forKey: "Tactical")
        newPlayer.setValue(Double(physical.text!), forKey: "Physical")
        newPlayer.setValue(Double(mental.text!), forKey: "Mental")
        newPlayer.setValue(Double(overall.text!), forKey: "Overall")
        
        
        database3.save(newPlayer) { (record, error) in
            print(error)
            guard record != nil else {return}
            print("saved record")
            
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

extension ThirdViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if availability.isEditing == true{
            return availabilitySelections.count
        }else{
            return positions.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if availability.isEditing == true{
            return availabilitySelections[row]
        }else{
            return positions[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if availability.isEditing == true{
            availability.text = availabilitySelections[row]
        }else if position.isEditing == true{
            position.text = positions[row]
        }else if secondaryPosition.isEditing == true{
            secondaryPosition.text = positions[row]
        }
    }
}
extension ThirdViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//
//  PlayerInfoViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 27/08/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import MessageUI
import CloudKit

class PlayerInfoViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var first: UITextField!
    @IBOutlet var last: UITextField!
    @IBOutlet var age: UITextField!
    @IBOutlet var position: UITextField!
    @IBOutlet var secondaryPosition: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var availability: UITextField!
    @IBOutlet var sruNumber: UITextField!
    
    @IBOutlet var technical: UITextField!
    @IBOutlet var tactical: UITextField!
    @IBOutlet var physical: UITextField!
    @IBOutlet var mental: UITextField!
    @IBOutlet var overall: UITextField!
    
    @IBAction func edit(_ sender: Any) {
        saveButton.isHidden = false
        first.isUserInteractionEnabled = true
        last.isUserInteractionEnabled = true
        age.isUserInteractionEnabled = true
        position.isUserInteractionEnabled = true
        secondaryPosition.isUserInteractionEnabled = true
        email.isUserInteractionEnabled = true
        phone.isUserInteractionEnabled = true
        availability.isUserInteractionEnabled = true
        sruNumber.isUserInteractionEnabled = true
        technical.isUserInteractionEnabled = true
        tactical.isUserInteractionEnabled = true
        physical.isUserInteractionEnabled = true
        mental.isUserInteractionEnabled = true
        overall.isUserInteractionEnabled = true
    }
    
    @IBAction func savePressed(_ sender: Any) {
        first.isUserInteractionEnabled = false
        last.isUserInteractionEnabled = false
        age.isUserInteractionEnabled = false
        position.isUserInteractionEnabled = false
        secondaryPosition.isUserInteractionEnabled = false
        email.isUserInteractionEnabled = false
        phone.isUserInteractionEnabled = false
        availability.isUserInteractionEnabled = false
        sruNumber.isUserInteractionEnabled = false
        technical.isUserInteractionEnabled = false
        tactical.isUserInteractionEnabled = false
        physical.isUserInteractionEnabled = false
        mental.isUserInteractionEnabled = false
        overall.isUserInteractionEnabled = false
        
        player.setValue(first.text, forKey: "FirstName")
        player.setValue(last.text, forKey: "LastName")
        player.setValue(Int(age.text!), forKey: "Age")
        player.setValue(position.text, forKey: "Position")
        player.setValue(secondaryPosition.text, forKey: "SecondaryPosition")
        player.setValue(email.text, forKey: "Email")
        player.setValue(phone.text, forKey: "PhoneNumber")
        player.setValue(availability.text, forKey: "Availability")
        player.setValue(sruNumber.text, forKey: "SRUNumber")
        player.setValue(Double(technical.text!), forKey: "Technical")
        player.setValue(Double(tactical.text!), forKey: "Tactical")
        player.setValue(Double(physical.text!), forKey: "Physical")
        player.setValue(Double(mental.text!), forKey: "Mental")
        player.setValue(Double(overall.text!), forKey: "Overall")
        
        database4.save(player) { (record, error) in
            print(error)
            guard record != nil else {return}
            print("updated record")
        }
        saveButton.isHidden = true
        
    }
    
    @IBOutlet var saveButton: UIButton!
    
    
    
    var player: CKRecord!
    
    let database4 = CKContainer.default().privateCloudDatabase
    
    var availabilitySelections = ["Available", "Not Available", "Injured"]
    var positions = ["", "Loosehead Prop", "Hooker", "Tighthead Prop", "Second Row", "Flanker", "Number 8", "Scrum Half", "Fly Half", "Inside Centre", "Outside Centre", "Winger", "Fullback"]
    
    
    @IBAction func whatsApp(_ sender:Any){
        if phone.text != ""{
            number = pn
            number.remove(at: number.startIndex)
            let num = number as String?
            whatsAppNumber = "\(prefix)\(num as! String)"
            phoneNum = Int(whatsAppNumber)
            UIApplication.shared.open(URL(string:"https://api.whatsapp.com/send?phone=\(phoneNum)")!)
        }else{
            print("cannot send whatsapp")
        }
        
    }
    
    
    @IBAction func makeCall(_ sender: Any) {
        print(phone.text!)
        phoneNum = Int(pn)
    
        let url:NSURL = URL(string: "TEL://\(phoneNum)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        if MFMessageComposeViewController.canSendText(){
            let controller = MFMessageComposeViewController()
            controller.recipients = [phone.text!]
            controller.messageComposeDelegate = self
            
            self.present(controller, animated: true, completion: nil)
        }
        else{
            print("cannot send text")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func sendEmail(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail(){
            let controller = MFMailComposeViewController()
            controller.setToRecipients(["\(email.text!)"])
            controller.mailComposeDelegate = self
            
            self.present(controller, animated: true, completion: nil)
        }
        else{
            print("cannot send email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    var f: String = ""
    var l: String = ""
    var a: Int = 0
    var p: String = ""
    var s: String = ""
    var e: String = ""
    var pn: String = ""
    var avail: String = ""
    var sruNum: String = ""
    var tech: Double = 0
    var tact: Double = 0
    var phys: Double = 0
    var ment: Double = 0
    var over: Double = 0
    
    var number: String!
    var prefix: String = "44"
    var whatsAppNumber: String!
    var phoneNum: Int!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isHidden = true
        
        let availabilityPicker = UIPickerView()
        availability.inputView = availabilityPicker
        position.inputView = availabilityPicker
        secondaryPosition.inputView = availabilityPicker
        
        availabilityPicker.delegate = self
        
        
        first.text = "\(f)"
        last.text = "\(l)"
        age.text = "\(a)"
        position.text = "\(p)"
        secondaryPosition.text = "\(s)"
        email.text = "\(e)"
        phone.text = "\(pn)"
        availability.text = "\(avail)"
        sruNumber.text = "\(sruNum)"
        technical.text = "\(tech)"
        tactical.text = "\(tact)"
        physical.text = "\(phys)"
        mental.text = "\(ment)"
        overall.text = "\(over)"
        
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
        first.inputAccessoryView = toolBar
        last.inputAccessoryView = toolBar
        age.inputAccessoryView = toolBar
        email.inputAccessoryView = toolBar
        phone.inputAccessoryView = toolBar
        sruNumber.inputAccessoryView = toolBar
        technical.inputAccessoryView = toolBar
        tactical.inputAccessoryView = toolBar
        physical.inputAccessoryView = toolBar
        mental.inputAccessoryView = toolBar
        overall.inputAccessoryView = toolBar
        
        
        
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
        first.resignFirstResponder()
        last.resignFirstResponder()
        age.resignFirstResponder()
        email.resignFirstResponder()
        phone.resignFirstResponder()
        sruNumber.resignFirstResponder()
        technical.resignFirstResponder()
        tactical.resignFirstResponder()
        physical.resignFirstResponder()
        mental.resignFirstResponder()
        overall.resignFirstResponder()

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

extension PlayerInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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


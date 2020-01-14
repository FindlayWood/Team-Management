//
//  TeamListViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 29/08/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import CloudKit

class TeamListViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UICloudSharingControllerDelegate{
    
    var actualNames = [String]()
    var looseheads = [String]()
    var tightheads = [String]()
    var frontRow = [String]()
    var secondRow = [String]()
    var backRow = [String]()
    var halfBacks = [String]()
    var centres = [String]()
    var backThree = [String]()
    
    var datePicker:UIDatePicker?
    var record: CKRecord!
    var records = [CKRecord]()
    
    
    
    let database = CKContainer.default().privateCloudDatabase
    
    @IBAction func savePressed(_ sender: Any){
        if textBox1.text != ""{
            record.setValue(textBox1.text, forKey: "P1")
        }
        if textBox2.text != ""{
            record.setValue(textBox2.text, forKey: "P2")
        }
        if textBox3.text != ""{
            record.setValue(textBox3.text, forKey: "P3")
        }
        if textBox4.text != ""{
            record.setValue(textBox4.text, forKey: "P4")
        }
        if textBox5.text != ""{
            record.setValue(textBox5.text, forKey: "P5")
        }
        if textBox6.text != ""{
            record.setValue(textBox6.text, forKey: "P6")
        }
        if textBox7.text != ""{
            record.setValue(textBox7.text, forKey: "P7")
        }
        if textBox8.text != ""{
            record.setValue(textBox8.text, forKey: "P8")
        }
        if textBox9.text != ""{
            record.setValue(textBox9.text, forKey: "P9")
        }
        if textBox10.text != ""{
            record.setValue(textBox10.text, forKey: "P10")
        }
        if textBox11.text != ""{
            record.setValue(textBox11.text, forKey: "P11")
        }
        if textBox12.text != ""{
            record.setValue(textBox12.text, forKey: "P12")
        }
        if textBox13.text != ""{
            record.setValue(textBox13.text, forKey: "P13")
        }
        if textBox14.text != ""{
            record.setValue(textBox14.text, forKey: "P14")
        }
        if textBox15.text != ""{
            record.setValue(textBox15.text, forKey: "P15")
        }
        if textBox16.text != ""{
            record.setValue(textBox16.text, forKey: "P16")
        }
        if textBox17.text != ""{
            record.setValue(textBox17.text, forKey: "P17")
        }
        if textBox18.text != ""{
            record.setValue(textBox18.text, forKey: "P18")
        }
        if textBox19.text != ""{
            record.setValue(textBox19.text, forKey: "P19")
        }
        if textBox20.text != ""{
            record.setValue(textBox20.text, forKey: "P20")
        }
        if textBox21.text != ""{
            record.setValue(textBox21.text, forKey: "P21")
        }
        if textBox22.text != ""{
            record.setValue(textBox22.text, forKey: "P22")
        }
        if textBox23.text != ""{
            record.setValue(textBox23.text, forKey: "P23")
        }
        
        database.save(record) { (record, error) in
            print(error)
            guard record != nil else {return}
            print("updated record")
        }
    }
    
    @IBAction func share(_ sender: UIButton){
        let share = CKShare(rootRecord: record)
        let opp = record.value(forKey: "Opposition") as! String
        
        share[CKShareTitleKey] = "Sharing \(opp) to teemsheet."
        
        share[CKShareTypeKey] = "com.FindlayWood.Sports-Profiling" as CKRecordValue
        prepareToShare(share: share, record: record)
        
    }
    
    private func prepareToShare(share: CKShare, record: CKRecord){
        
        let sharingViewController = UICloudSharingController(preparationHandler: {(UICloudSharingController, handler: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
            
            let modRecordsList = CKModifyRecordsOperation(recordsToSave: [record, share], recordIDsToDelete: nil)
            
            modRecordsList.modifyRecordsCompletionBlock = {
                (record, recordID, error) in
                
                handler(share, CKContainer.default(), error)
            }
            CKContainer.default().privateCloudDatabase.add(modRecordsList)
        })
        
        sharingViewController.delegate = self
        
        sharingViewController.availablePermissions = [.allowReadWrite,
                                                      .allowPrivate]
        self.navigationController?.present(sharingViewController, animated:true, completion:nil)
    }
    
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("saved successfully")
    }
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("failed to save: \(error.localizedDescription)")
    }
    
    func itemThumbnailData(for csc: UICloudSharingController) -> Data? {
        return nil //You can set a hero image in your share sheet. Nil uses the default.
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return "Teamsheet"
    }
    
    func fetchShare(_ cloudKitShareMetadata: CKShareMetadata){
        let op = CKFetchRecordsOperation(
            recordIDs: [cloudKitShareMetadata.rootRecordID])
        
        op.perRecordCompletionBlock = { record, _, error in
            guard error == nil, record != nil else{
                print("error \(error?.localizedDescription ?? "")")
                return
            }
            DispatchQueue.main.async {
                self.record = record
            }
        }
        op.fetchRecordsCompletionBlock = { _, error in
            guard error != nil else{
                print("error \(error?.localizedDescription ?? "")")
                return
            }
        }
        CKContainer.default().sharedCloudDatabase.add(op)
    }
    
    
    
    
    @IBOutlet var textBox1: UITextField!
    @IBOutlet var textBox2: UITextField!
    @IBOutlet var textBox3: UITextField!
    @IBOutlet var textBox4: UITextField!
    @IBOutlet var textBox5: UITextField!
    @IBOutlet var textBox6: UITextField!
    @IBOutlet var textBox7: UITextField!
    @IBOutlet var textBox8: UITextField!
    @IBOutlet var textBox9: UITextField!
    @IBOutlet var textBox10: UITextField!
    @IBOutlet var textBox11: UITextField!
    @IBOutlet var textBox12: UITextField!
    @IBOutlet var textBox13: UITextField!
    @IBOutlet var textBox14: UITextField!
    @IBOutlet var textBox15: UITextField!
    @IBOutlet var textBox16: UITextField!
    @IBOutlet var textBox17: UITextField!
    @IBOutlet var textBox18: UITextField!
    @IBOutlet var textBox19: UITextField!
    @IBOutlet var textBox20: UITextField!
    @IBOutlet var textBox21: UITextField!
    @IBOutlet var textBox22: UITextField!
    @IBOutlet var textBox23: UITextField!
    
    @IBOutlet var dateText: UITextField!
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if textBox1.isEditing{
            return looseheads.count
        }
        else if textBox2.isEditing{
            return frontRow.count
        }
        else if textBox3.isEditing{
            return tightheads.count
        }
        else if textBox4.isEditing || textBox5.isEditing{
            return secondRow.count
        }
        else if textBox6.isEditing || textBox7.isEditing || textBox8.isEditing{
            return backRow.count
        }
        else if textBox9.isEditing || textBox10.isEditing{
            return halfBacks.count
        }
        else if textBox12.isEditing || textBox13.isEditing{
            return centres.count
        }
        else if textBox11.isEditing || textBox14.isEditing || textBox15.isEditing{
            return backThree.count
        }
        else{
            return actualNames.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if textBox1.isEditing{
            return looseheads[row]
        }
        else if textBox2.isEditing{
            return frontRow[row]
        }
        else if textBox3.isEditing{
            return tightheads[row]
        }
        else if textBox4.isEditing || textBox5.isEditing{
            return secondRow[row]
        }
        else if textBox6.isEditing || textBox7.isEditing || textBox8.isEditing{
            return backRow[row]
        }
        else if textBox9.isEditing || textBox10.isEditing{
            return halfBacks[row]
        }
        else if textBox12.isEditing || textBox13.isEditing{
            return centres[row]
        }
        else if textBox11.isEditing || textBox14.isEditing || textBox15.isEditing{
            return backThree[row]
        }else{
            return actualNames[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if textBox1.isEditing{
            textBox1.text = looseheads[row]
        }
        else if textBox2.isEditing{
            textBox2.text = frontRow[row]
        }
        else if textBox3.isEditing{
            textBox3.text = tightheads[row]
        }
        else if textBox4.isEditing{
            textBox4.text = secondRow[row]
        }
        else if textBox5.isEditing{
            textBox5.text = secondRow[row]
        }
        else if textBox6.isEditing{
            textBox6.text = backRow[row]
        }
        else if textBox7.isEditing{
            textBox7.text = backRow[row]
        }
        else if textBox8.isEditing{
            textBox8.text = backRow[row]
        }
        else if textBox9.isEditing{
            textBox9.text = halfBacks[row]
        }
        else if textBox10.isEditing{
            textBox10.text = halfBacks[row]
        }
        else if textBox11.isEditing{
            textBox11.text = backThree[row]
        }
        else if textBox12.isEditing{
            textBox12.text = centres[row]
        }
        else if textBox13.isEditing{
            textBox13.text = centres[row]
        }
        else if textBox14.isEditing{
            textBox14.text = backThree[row]
        }
        else if textBox15.isEditing{
            textBox15.text = backThree[row]
        }
        else if textBox16.isEditing{
            textBox16.text = actualNames[row]
        }
        else if textBox17.isEditing{
            textBox17.text = actualNames[row]
        }
        else if textBox18.isEditing{
            textBox18.text = actualNames[row]
        }
        else if textBox19.isEditing{
            textBox19.text = actualNames[row]
        }
        else if textBox20.isEditing{
            textBox20.text = actualNames[row]
        }
        else if textBox21.isEditing{
            textBox21.text = actualNames[row]
        }
        else if textBox22.isEditing{
            textBox22.text = actualNames[row]
        }
        else if textBox23.isEditing{
            textBox23.text = actualNames[row]
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        queryDatabase()
        
        
        textBox1.text = record.value(forKey: "P1") as? String
        textBox2.text = record.value(forKey: "P2") as? String
        textBox3.text = record.value(forKey: "P3") as? String
        textBox4.text = record.value(forKey: "P4") as? String
        textBox5.text = record.value(forKey: "P5") as? String
        textBox6.text = record.value(forKey: "P6") as? String
        textBox7.text = record.value(forKey: "P7") as? String
        textBox8.text = record.value(forKey: "P8") as? String
        textBox9.text = record.value(forKey: "P9") as? String
        textBox10.text = record.value(forKey: "P10") as? String
        textBox11.text = record.value(forKey: "P11") as? String
        textBox12.text = record.value(forKey: "P12") as? String
        textBox13.text = record.value(forKey: "P13") as? String
        textBox14.text = record.value(forKey: "P14") as? String
        textBox15.text = record.value(forKey: "P15") as? String
        textBox16.text = record.value(forKey: "P16") as? String
        textBox17.text = record.value(forKey: "P17") as? String
        textBox18.text = record.value(forKey: "P18") as? String
        textBox19.text = record.value(forKey: "P19") as? String
        textBox20.text = record.value(forKey: "P20") as? String
        textBox21.text = record.value(forKey: "P21") as? String
        textBox22.text = record.value(forKey: "P22") as? String
        textBox23.text = record.value(forKey: "P23") as? String
        
        
        
        
        let playerPicker = UIPickerView()
        textBox1.inputView = playerPicker
        textBox2.inputView = playerPicker
        textBox3.inputView = playerPicker
        textBox4.inputView = playerPicker
        textBox5.inputView = playerPicker
        textBox6.inputView = playerPicker
        textBox7.inputView = playerPicker
        textBox8.inputView = playerPicker
        textBox9.inputView = playerPicker
        textBox10.inputView = playerPicker
        textBox11.inputView = playerPicker
        textBox12.inputView = playerPicker
        textBox13.inputView = playerPicker
        textBox14.inputView = playerPicker
        textBox15.inputView = playerPicker
        textBox16.inputView = playerPicker
        textBox17.inputView = playerPicker
        textBox18.inputView = playerPicker
        textBox19.inputView = playerPicker
        textBox20.inputView = playerPicker
        textBox21.inputView = playerPicker
        textBox22.inputView = playerPicker
        textBox23.inputView = playerPicker
        
        playerPicker.delegate = self
        print(actualNames)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height:40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(TeamListViewController.donePressed))
        
        toolBar.setItems([doneButton], animated: true)
        
        textBox1.inputAccessoryView = toolBar
        textBox2.inputAccessoryView = toolBar
        textBox3.inputAccessoryView = toolBar
        textBox4.inputAccessoryView = toolBar
        textBox5.inputAccessoryView = toolBar
        textBox6.inputAccessoryView = toolBar
        textBox7.inputAccessoryView = toolBar
        textBox8.inputAccessoryView = toolBar
        textBox9.inputAccessoryView = toolBar
        textBox10.inputAccessoryView = toolBar
        textBox11.inputAccessoryView = toolBar
        textBox12.inputAccessoryView = toolBar
        textBox13.inputAccessoryView = toolBar
        textBox14.inputAccessoryView = toolBar
        textBox15.inputAccessoryView = toolBar
        textBox16.inputAccessoryView = toolBar
        textBox17.inputAccessoryView = toolBar
        textBox18.inputAccessoryView = toolBar
        textBox19.inputAccessoryView = toolBar
        textBox20.inputAccessoryView = toolBar
        textBox21.inputAccessoryView = toolBar
        textBox22.inputAccessoryView = toolBar
        textBox23.inputAccessoryView = toolBar
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(TeamListViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        
        dateText.inputView = datePicker
        dateText.inputAccessoryView = toolBar
        
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        
        textBox1.resignFirstResponder()
        textBox2.resignFirstResponder()
        textBox3.resignFirstResponder()
        textBox4.resignFirstResponder()
        textBox5.resignFirstResponder()
        textBox6.resignFirstResponder()
        textBox7.resignFirstResponder()
        textBox8.resignFirstResponder()
        textBox9.resignFirstResponder()
        textBox10.resignFirstResponder()
        textBox11.resignFirstResponder()
        textBox12.resignFirstResponder()
        textBox13.resignFirstResponder()
        textBox14.resignFirstResponder()
        textBox15.resignFirstResponder()
        textBox16.resignFirstResponder()
        textBox17.resignFirstResponder()
        textBox18.resignFirstResponder()
        textBox19.resignFirstResponder()
        textBox20.resignFirstResponder()
        textBox21.resignFirstResponder()
        textBox22.resignFirstResponder()
        textBox23.resignFirstResponder()
        dateText.resignFirstResponder()
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateText.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func queryDatabase(){
        let query = CKQuery(recordType: "Games", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (record, error) in
            guard let record = record else {return}
            let sortedRecords = record.sorted(by: { $0.creationDate! > $1.creationDate! })
            self.records = sortedRecords
            DispatchQueue.main.async {
                
            }
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

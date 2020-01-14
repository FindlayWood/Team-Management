//
//  TimerViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 14/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import CloudKit
import AudioToolbox

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    let database = CKContainer.default().privateCloudDatabase
    
    var game: CKRecord!
    
    @IBOutlet var tableView:UITableView!
    weak var timer: Timer?
    weak var yellowTimer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var status: Bool = false
    
    //yellow card varibales
    var yellowStartTime: Double = 600
    var yellowTime: Double = 600
    var yellowElapsed: Double = 600
    var yellowStatus: Bool = true
    
    var players = [""]
    var scoreType = ["", "Try", "Conversion", "Penalty", "Drop Goal", "Penalty Try"]
    var scores = [String]()
    var score: UITextField!
    var player: UITextField!
    @IBOutlet var startStop: UIButton!

    
    var scoringTeam: Bool = false
    
    @IBOutlet weak var labelMinute: UILabel!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var labelMillisecond: UILabel!
    @IBOutlet weak var yellowLabel: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    var homeScoreNumber: Int = 0
    var awayScoreNumber: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        
        for player in 1..<23{
            if game.value(forKey: "P\(player)") != nil{
                players.append(game.value(forKey: "P\(player)") as! String)
            }
        }
        if game.value(forKey: "GameScores") != nil{
            self.scores = game.value(forKey: "GameScores") as! [String]
        }
        if game.value(forKey: "HomeScore") != nil{
            self.homeScore.text = game.value(forKey: "HomeScore") as? String
        }
        if game.value(forKey: "AwayScore") != nil{
            self.awayScore.text = game.value(forKey: "AwayScore") as? String
        }
        
        


        // Do any additional setup after loading the view.
    }
    
    @IBAction func scorePressed(_ sender: UIButton){
        //startStop.titleLabel?.text = "STOP"
        let playerPicker = UIPickerView()
        let scorePicker = UIPickerView()
        let alert = UIAlertController(title: "Score!", message: "Enter the player and score type.", preferredStyle: .alert)
        alert.addTextField { (score) in
            score.inputView = scorePicker
            score.placeholder = "Type of score?"
            if score.isEditing{
                playerPicker.reloadAllComponents()
            }
            self.score = score
//            self.score.placeholder = "Type of score?"
//            self.score.inputView = playerPicker
        }
        alert.addTextField { (player) in
            player.placeholder = "Who scored?"
            player.inputView = playerPicker
            if player.isEditing{
                playerPicker.reloadAllComponents()
            }
            self.player = player
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let score = alert.textFields?.first?.text else {return}
            guard let player = alert.textFields?.last?.text else {return}
            print(score)
            print(player)
            self.scoringTeam = true
            if score == "Try"{
                self.homeScoreNumber = self.homeScoreNumber + 5
                self.homeScore.text = "\(self.homeScoreNumber)"
            }else if score == "Penalty" || score == "Drop Goal"{
                self.homeScoreNumber = self.homeScoreNumber + 3
                self.homeScore.text = "\(self.homeScoreNumber)"
            }else if score == "Conversion"{
                self.homeScoreNumber = self.homeScoreNumber + 2
                self.homeScore.text = "\(self.homeScoreNumber)"
            }else if score == "Penalty Try"{
                self.homeScoreNumber = self.homeScoreNumber + 7
                self.homeScore.text = "\(self.homeScoreNumber)"
            }
            
            print("\(self.labelMinute.text!):\(self.labelSecond.text!)")
            self.scores.insert("\(self.labelMinute.text!)' \(score) \(player)", at: 0)
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
            
            
            
        }
        playerPicker.delegate = self
        scorePicker.delegate = self
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height:40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(TeamListViewController.donePressed))
        
        toolBar.setItems([doneButton], animated: true)
        
        score.inputAccessoryView = toolBar
        player.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        score.resignFirstResponder()
        player.resignFirstResponder()
    }
    
    @IBAction func awayScore(_ sender: UIButton){
        let scorePicker = UIPickerView()
        //let playerPicker = UIPickerView()
        let alert = UIAlertController(title: "Score!", message: "Enter the score type.", preferredStyle: .alert)
        alert.addTextField { (score) in
            score.inputView = scorePicker
            score.placeholder = "Type of score?"
            self.score = score
            //            self.score.placeholder = "Type of score?"
            //            self.score.inputView = playerPicker
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let score = alert.textFields?.first?.text else {return}
            print(score)
            
            self.scoringTeam = false
            if score == "Try"{
                self.awayScoreNumber = self.awayScoreNumber + 5
                self.awayScore.text = "\(self.awayScoreNumber)"
            }else if score == "Penalty" || score == "Drop Goal"{
                self.awayScoreNumber = self.awayScoreNumber + 3
                self.awayScore.text = "\(self.awayScoreNumber)"
            }else if score == "Conversion"{
                self.awayScoreNumber = self.awayScoreNumber + 2
                self.awayScore.text = "\(self.awayScoreNumber)"
            }else if score == "Penalty Try"{
                self.awayScoreNumber = self.awayScoreNumber + 7
                self.awayScore.text = "\(self.awayScoreNumber)"
            }
            
            print("\(self.labelMinute.text!):\(self.labelSecond.text!)")
            //self.scores.append("\(self.labelMinute.text!)' \(score) \(player)")
            self.scores.insert("\(self.labelMinute.text!)' \(score) Opposition", at: 0)
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
            
            
            
        }
        scorePicker.delegate = self
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height:40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(TeamListViewController.donePressed))
        
        toolBar.setItems([doneButton], animated: true)
        
        score.inputAccessoryView = toolBar
    }
    
    
    @IBAction func toggleStartStop(_ sender: UIButton!) {
        
//        if players.count == 0{
//            let alert = UIAlertController(title: "Alert!", message: "Your teamsheet is empty therfore you wont be able to add player names to scores.", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(ok)
//            present(alert, animated: true, completion: nil)
//        }
        
        // If button status is true use stop function, relabel button and enable reset button
        if (status) {
            stop()
            //sender.setTitle("START", for: .normal)
            resetBtn.isEnabled = true
            
            // If button status is false use start function, relabel button and disable reset button
        } else {
            start()
            //sender.setTitle("STOP", for: .normal)
            resetBtn.isEnabled = false
        }
        
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Reset!", message: "Are you sure you want to reset the game?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Yes", style: .default) { (_) in
            // Invalidate timer
            self.timer?.invalidate()
            
            // Reset timer variables
            self.startTime = 0
            self.time = 0
            self.elapsed = 0
            self.status = false
            
            // Reset scores
            self.homeScoreNumber = 0
            self.homeScore.text = "\(self.homeScoreNumber)"
            self.awayScoreNumber = 0
            self.awayScore.text = "\(self.awayScoreNumber)"
            self.scores.removeAll()
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
            
            
            // Reset all three labels to 00
            let strReset = String("00")
            self.labelMinute.text = strReset
            self.labelSecond.text = strReset
            //self.labelMillisecond.text = strReset
        }
        
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
        
        
        
        
        
    }
    
    @IBAction func halfTime(_ sender:UIButton){
        stop()
        labelMinute.text = "40"
        labelSecond.text = "00"
        //labelMillisecond.text = "00"
        startTime = (40*60)
        time = (40*60)
        elapsed = (40*60)
    }
    
    @IBAction func endGame(_ sender: UIButton){
        let alert = UIAlertController(title: "Full Time!", message: "Are you sure you want to end the game and save the information on screen?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Yes", style: .default) { (_) in
            self.stop()
            self.game.setValue(self.scores, forKey: "GameScores")
            self.game.setValue(self.homeScore.text, forKey: "HomeScore")
            self.game.setValue(self.awayScore.text, forKey: "AwayScore")
            self.database.save(self.game){ (record, error) in
                guard record != nil else {return}
                print("saved record")
            }
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func yellowPressed(_ sender: UIButton){
        if (yellowStatus){
            let alert = UIAlertController(title: "Yellow Card!", message: "Would you like to start the timer for a yellow card?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            let post = UIAlertAction(title: "Yes", style: .default) { (_) in
                self.yellowStart()
                self.yellowStatus = false
                self.scores.insert("\(self.labelMinute.text!)' Yellow Card", at: 0)
                self.tableView.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(post)
            present(alert, animated: true, completion: nil)
        }else{
        }
        
    }
    
    func yellowStart(){
        yellowTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateYellow), userInfo: nil, repeats: true)
        
        //yellowStartTime = Date().timeIntervalSinceReferenceDate - yellowElapsed
        
    }
    
    func start() {
        
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        if yellowStatus == false{
            yellowStart()
        }
        
        // Set Start/Stop button to true
        status = true
        
    }
    
    func stop() {
        
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
        yellowTimer?.invalidate()
        
        // Set Start/Stop button to false
        status = false
        
    }
    
    @objc func updateYellow(){
        if yellowStartTime > 0{
            yellowStartTime -= 1
            secondsToMinutesSeconds(seconds: Int(yellowStartTime))
        }else{
            yellowTimer?.invalidate()
            //AudioServicesPlayAlertSound(SystemSoundID(1330))
            let alert = UIAlertController(title: "Yellow Card Over!", message: "The time on the yellow card is over.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { (_) in
                self.yellowStartTime = 600
                self.yellowStatus = true
                self.yellowLabel.text = "10:00"
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    func secondsToMinutesSeconds (seconds : Int){
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        let sec = String(format: "%02d", seconds)
        
        yellowLabel.text = "\(minutes):\(sec)"
        
        //(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc func updateCounter() {
        
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        //let milliseconds = UInt8(time * 100)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        //let strMilliseconds = String(format: "%02d", milliseconds)
        
        // Add time vars to relevant labels
        labelMinute.text = strMinutes
        labelSecond.text = strSeconds
        //labelMillisecond.text = strMilliseconds
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if player != nil{
            if player.isEditing{
                return players.count
            }
        }
        if score.isEditing{
            return scoreType.count
        }
        else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if score.isEditing{
            return scoreType[row]
        }
        else{
            if players.count == 0{
                return "No players in team sheet"
            }else{
                return players[row]
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if score.isEditing{
            score.text = scoreType[row]
        }else if player.isEditing{
            if players.count != 0{
                player.text = players[row]
            }else{
                player.text = ""
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if scores[indexPath.row].contains("Opposition"){
            let name = scores[indexPath.row]
            let endIndex = name.index(name.endIndex, offsetBy: -11)
            let truncated = name.prefix(upTo: endIndex)
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! Timer2TableViewCell
            cell.rightLabel.text = "\(truncated)"
            cell.rightLabel.adjustsFontSizeToFitWidth = true
            return cell
        }else{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimerTableViewCell
            cell.leftLabel.text = "\(scores[indexPath.row])"
            cell.leftLabel.adjustsFontSizeToFitWidth = true
            return cell
        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit", message: "Edit the score.", preferredStyle: .alert)
        alert.addTextField{ (score) in
            score.text = "\(self.scores[indexPath.row])"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Yes", style: .default) { (_) in
            
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
    
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

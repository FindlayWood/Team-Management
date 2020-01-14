//
//  buttonPageViewController.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 02/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import CloudKit

class buttonPageViewController: UIViewController {
    
    
    @IBOutlet var gameID: UILabel!
    var game: String = ""
    var players = [String]()
    var opponent: String = ""
    var team: CKRecord!
    var looseheads = [String]()
    var tightheads = [String]()
    var frontRow = [String]()
    var secondRow = [String]()
    var backRow = [String]()
    var halfBacks = [String]()
    var centres = [String]()
    var backThree = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "\(game) \(opponent)"
        
        gameID.text = "\(game) \(opponent)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTeam"{
            let vc = segue.destination as! TeamListViewController
            vc.actualNames = self.players
            vc.record = self.team
            vc.looseheads = looseheads
            vc.tightheads  = tightheads
            vc.frontRow = frontRow
            vc.secondRow = secondRow
            vc.backRow = backRow
            vc.halfBacks = halfBacks
            vc.centres = centres
            vc.backThree = backThree
            
            
        }
        if segue.identifier == "showGameInfo"{
            let vc = segue.destination as! GameInfoViewController
            vc.date = self.game
            vc.opponent = self.opponent
            vc.game = self.team
        }
        if segue.identifier == "showComments"{
            let vc = segue.destination as! GameCommentsViewController
            vc.game = self.team
        }
        if segue.identifier == "showRatings"{
            let vc = segue.destination as! PlayerRatingsViewController
            vc.players = self.team
        }
        if segue.identifier == "showLiveGame"{
            let vc = segue.destination as! TimerViewController
            vc.game = self.team
            
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

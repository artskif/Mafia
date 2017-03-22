//
//  PlayController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 11.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit
import os.log

class PlayController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var playersTableView: UITableView!
    
    //var arrayPlayers = [Player]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "PlayerTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? PlayerTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlayerTableViewCell.")
        }
        
        // Fetches the appropriate player for the data source layout.
        let player = game.players[indexPath.row]
        
        cell.killButton.tag = indexPath.row
        cell.nameLabel.text = player.name
        
        return cell
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            game.players.remove(at: indexPath.row)
            savePlayers()
            playersTableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Load any saved players, otherwise load sample data.
        if let savedPlayers = loadPlayers() {
            game.players += savedPlayers
        } else {
            // Load the sample data.
            loadSamplePlayers()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new player.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let playerDetailViewController = segue.destination as? AddController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPlayerCell = sender as? PlayerTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = playersTableView.indexPath(for: selectedPlayerCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedPlayer = game.players[indexPath.row]
            playerDetailViewController.player = selectedPlayer
        default:
            break            
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToPlayerList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddController, let player = sourceViewController.player {
            
            if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
                // Update an existing meal.
                game.players[selectedIndexPath.row] = player
                playersTableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: game.players.count, section: 0)
                
                game.players.append(player)
                playersTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            savePlayers()
        }               
    }
    
    @IBAction func unwindCancelToPlayerList(sender: UIStoryboardSegue) {
        if let selectedIndexPath = playersTableView.indexPathForSelectedRow {
            // Deselect a selected row on cancel.
            playersTableView.deselectRow(at: selectedIndexPath, animated: false)
        }
    }
    
    @IBAction func pushMafiaKill(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        game.players.remove(at: sender.tag)
        savePlayers()
        playersTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    // Load testing debug data for Player table view 
    private func loadSamplePlayers() {
        guard let player1 = Player(name: "Игрок 1")
        else {
            fatalError("Unable to instantiate player1")
        }
        
        guard let player2 = Player(name: "Игрок 2")
            else {
                fatalError("Unable to instantiate player2")
        }
        
        guard let player3 = Player(name: "Игрок 3")
            else {
                fatalError("Unable to instantiate player3")
        }
        
        game.players += [player1, player2, player3]
    }
    
    //MARK: Private Methods
    
    private func savePlayers() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(game.players, toFile: Account.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Players successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save players...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPlayers() -> [Player]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Player.ArchiveURL.path) as? [Player]
    }
}

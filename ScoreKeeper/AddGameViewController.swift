//
//  AddGameViewController.swift
//  ScoreKeeper
//
//  Created by Everett Brothers on 10/17/23.
//

import UIKit

class AddGameViewController: UITableViewController {

    var game: Game?
    var newGame: Game!
    var setting: Setting?
    var edit = false
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false
        if let game = game {
            edit = true
            nameField.text = game.name
            var cell: UITableViewCell?
            var indexPath: IndexPath = IndexPath()
            switch game.settings {
            case .highScore:
                indexPath = IndexPath(row: 0, section: 1)
            case .lowScore:
                indexPath = IndexPath(row: 0, section: 1)
            case .none:
                indexPath = IndexPath(row: 0, section: 1)
            }
            cell = tableView.cellForRow(at: indexPath)
            if let cell = cell {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 1 {
            if cell?.accessoryType == .checkmark {
                cell?.accessoryType = .none
            } else {
                cell?.accessoryType = .checkmark
                switch indexPath.row {
                case 0:
                    setting = .highScore
                case 1:
                    setting = .lowScore
                case 2:
                    setting = Setting.none
                default:
                    setting = Setting.none
                }
                checkSave()
            }
        }
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        checkSave()
    }
    
    func checkSave() {
        if let text = nameField.text {
            if text != "" {
                if setting != nil {
                    saveButton.isEnabled = true
                    return
                }
            }
        }
        saveButton.isEnabled = false
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if edit {
            newGame = game
            newGame?.name = nameField.text!
            newGame?.settings = setting!
        } else {
            newGame = Game(name: nameField.text!, players: [], settings: setting!)
        }
        performSegue(withIdentifier: "toGames", sender: nil)
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

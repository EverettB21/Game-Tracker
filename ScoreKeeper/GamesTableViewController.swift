//
//  GamesTableViewController.swift
//  ScoreKeeper
//
//  Created by Everett Brothers on 10/17/23.
//

import UIKit

class GamesTableViewController: UITableViewController, ViewControllerDelegate {

    var games: [Game] = []
    var selectedGame: Game!
    var edit = false {
        didSet {
            if edit {
                editButton.title = "Done"
            } else {
                editButton.title = "Edit"
            }
        }
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        games = Game.loadFromFile()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGame))
    }
    
    func save() {
        Game.saveToFile(games: games)
    }
    
    @objc func addGame() {
        performSegue(withIdentifier: "addGame", sender: nil)
    }
    
    @IBSegueAction func toAddGame(_ coder: NSCoder) -> AddGameViewController? {
        let vc = AddGameViewController(coder: coder)
        
        if edit {
            vc?.game = selectedGame
            edit = false
        }
        
        return vc
    }
    
    @IBAction func unwindToGameTable(segue: UIStoryboardSegue) {
        guard let vc = segue.source as? AddGameViewController else { return }
        if let newGame = vc.newGame {
            if vc.edit {
                guard let index = games.firstIndex(of: vc.game!) else { return }
                games[index] = newGame
            } else {
                games.insert(newGame, at: 0)
            }
            save()
            tableView.reloadData()
        }
    }
    
    func recieve(_: ViewController, players: [Player], for game: Game) {
        guard let index = games.firstIndex(where: {$0 == game}) else { return }
        
        games[index].players = players
        
        save()
        tableView.reloadData()
    }

    @IBSegueAction func toPlayers(_ coder: NSCoder) -> ViewController? {
        let vc = ViewController(coder: coder)
        vc?.delegate = self
        vc?.game = selectedGame
        if selectedGame.players.count > 0 {
            vc?.players = selectedGame.players
        }
        
        return vc
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewController {
            vc.order(game: selectedGame)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGame = games[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        if edit {
            performSegue(withIdentifier: "addGame", sender: nil)
        } else {
            performSegue(withIdentifier: "toPlayers", sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            games.remove(at: indexPath.row)
            save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func editClicked(_ sender: Any) {
        edit.toggle()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        let game = games[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = game.description
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
}

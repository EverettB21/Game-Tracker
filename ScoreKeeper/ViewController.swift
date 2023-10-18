//
//  ViewController.swift
//  ScoreKeeper
//
//  Created by Everett Brothers on 10/16/23.
//

import UIKit

protocol ViewControllerDelegate {
    func recieve(_:ViewController,players:[Player], for game: Game)
}

class ViewController: UITableViewController, PlayerCellDelegate {

    var players: [Player] = []
    var selectedPlayer: Player?
    var selectedIndex: IndexPath?
    var delegate: ViewControllerDelegate?
    var game: Game!
    var allIndexes: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlayer))
    }
    
    @objc func addPlayer() {
        let ac = UIAlertController(title: "Add Player", message: nil, preferredStyle: .alert)
        
        ac.addTextField { text in
            text.placeholder = "Name:"
        }
        
        ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.players.insert(Player(name: text, score: 0), at: 0)
            self?.delegate?.recieve(self!, players: self!.players, for: self!.game)
            self?.tableView.reloadData()
            self?.order(game: self!.game)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            players.remove(at: indexPath.row)
            delegate?.recieve(self, players: players, for: game)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            order(game: game)
        }
    }
    
    func order(game: Game) {
        let temp = players
        switch game.settings {
        case .highScore:
            players = highSort(players: players)
        case .lowScore:
            players = lowSort(players: players)
        case .none:
            break
        }
        if temp != players {
            tableView.reloadRows(at: allIndexes, with: .automatic)
        }
        tableView.reloadData()
    }
    
    func lowSort(players: [Player]) -> [Player] {
        var sort = players
        
        return sort.sorted(by: <)
    }
    
    func highSort(players: [Player]) -> [Player] {
        var sort = players
        
        return sort.sorted(by: >)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PlayerCellTableViewCell else { fatalError("failed to deque cell") }
        cell.delegate = self
        let player = players[indexPath.row]
       
        cell.rowNumSet(player: player, score: player.score, index: indexPath.row)
        allIndexes.insert(indexPath, at: 0)
        
        return cell
    }
    
    func reciveNewScore(_: PlayerCellTableViewCell, score: Int, index: Int) {
        players[index].score = score
        delegate?.recieve(self, players: players, for: game)
        order(game: game)
    }
}


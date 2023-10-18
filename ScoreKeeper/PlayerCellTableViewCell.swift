//
//  PlayerCellTableViewCell.swift
//  ScoreKeeper
//
//  Created by Everett Brothers on 10/18/23.
//

import UIKit

protocol PlayerCellDelegate {
    func reciveNewScore(_:PlayerCellTableViewCell,score:Int,index:Int)
}

class PlayerCellTableViewCell: UITableViewCell {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var delegate: PlayerCellDelegate?
    
    var score = 0
    var text = ""
    var i = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func rowNumSet(player: Player, score: Int, index: Int) {
        self.score = score
        self.i = index
        stepper.value = Double(score)
        text = "\(player.name.capitalized)"
        scoreLabel.text = "\(text), Score: \(score)"
    }
    
    @IBAction func scoreChanged(_ sender: UIStepper) {
        score = Int(sender.value)
        scoreLabel.text = "\(text), Score: \(score)"
        delegate?.reciveNewScore(self, score: score, index: i)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

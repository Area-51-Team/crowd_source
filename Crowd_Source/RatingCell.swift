//
//  RatingCell.swift
//  Crowd_Source
//
//  Created by Ryan Kwong on 4/9/22.
//

import UIKit
import Parse

protocol CellUpdater : AnyObject {
    func updateTableView()
}
class RatingCell: UITableViewCell {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var ratings: UISegmentedControl!
    @IBOutlet weak var result: UILabel!
    weak var delegate: CellUpdater?
    var post : PFObject!
    var selectedRating = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onIndexChanged(_ sender: UISegmentedControl) {
        selectedRating = sender.selectedSegmentIndex + 1
    }
    @IBAction func onSubmit(_ sender: Any) {
        print(selectedRating)
        let voters = post["voters"] as? [String] ?? [String]()
        let current = PFUser.current()?.username ?? ""
        let hasVoter = voters.contains(current)
        if(!hasVoter) {
            post.add(current, forKey: "voters")
            var votes = post["votes"] as? [String:Int] ?? [String:Int]()
            votes[String(selectedRating)] = (votes[String(selectedRating)] ?? 0) + 1
            post["votes"] = votes
            post.saveInBackground { (success, error) in
                if success {
                    print("Saved!")
                    self.setResult()
                    self.delegate?.updateTableView()
                } else {
                    print("Error: \(error?.localizedDescription ?? "")")
                }
            }
        }
    }
    
    func setResult(){
        result.text = ""
        let votes = post["votes"] as? [String:Int] ?? [String:Int]()
        for (rating,vote) in votes.sorted(by: { $0.0 < $1.0 }){
//            print("Rating: \(rating): \(vote)")
            result.text?.append(contentsOf: "\(rating) : \(vote)\n")
        }
        
    }
}

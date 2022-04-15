//
//  PollingCell.swift
//  Crowd_Source
//
//  Created by Ryan Kwong on 4/9/22.
//

import UIKit
import Parse

class PollingCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var optionsPicker: UIPickerView!
    @IBOutlet weak var result: UILabel!
    weak var delegate: CellUpdater?
    var post : PFObject!
    
    var options = [String]()
    var selectedValue : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        optionsPicker.delegate = self
        optionsPicker.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setOptions(options : [String]){
        self.options = options
//        print(self.options.count)
        selectedValue = options[0]
        setResult()
    }
    
    func setResult(){
        result.text = ""
        let votes = post["votes"] as? [String:Int] ?? [String:Int]()
        for (option,vote) in votes.sorted(by: { $0.0 < $1.0 }){
//            print("Rating: \(rating): \(vote)")
            result.text?.append(contentsOf: "\(option) : \(vote)\n")
        }
    }
    @IBAction func onSubmit(_ sender: Any) {
        print(selectedValue)
        let voters = post["voters"] as? [String] ?? [String]()
        let current = PFUser.current()?.username ?? ""
        let hasVoter = voters.contains(current)
        if(!hasVoter) {
            post.add(current, forKey: "voters")
            var votes = post["votes"] as? [String:Int] ?? [String:Int]()
            votes[selectedValue] = (votes[selectedValue] ?? 0) + 1
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = options[row]
    }
    
    
}

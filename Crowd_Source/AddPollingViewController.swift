//
//  AddPollingViewController.swift
//  Crowd_Source
//
//  Created by Ryan Kwong on 4/20/22.
//

import UIKit
import Parse

class AddPollingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var question: UITextField!
    @IBOutlet weak var pollItems: UITableView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View loaded")
        pollItems.delegate = self
        pollItems.dataSource = self
        pollItems.register(UINib.init(nibName: "PollingItemCell", bundle: nil), forCellReuseIdentifier: "PollingItemCell")
        self.pollItems.rowHeight = UITableView.automaticDimension
        self.pollItems.estimatedRowHeight = 50
        // Do any additional setup after loading the view.
        view.isUserInteractionEnabled = true
        pollItems.isScrollEnabled = false
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onAddItem(_ sender: Any) {
//        print("added item")
        if itemName.hasText {
            items.append(itemName.text!)
            itemName.text = ""
            self.tableViewHeight.constant = self.pollItems.contentSize.height + 50
            pollItems.reloadData()
        }
    }
    @IBAction func onSubmit(_ sender: Any) {
        if(!question.hasText || items.count == 0){
            print("Invalid inputs")
            return
        }
        let post = PFObject(className: "Posts")
        let polling = PFObject(className: "PollingPosts")
        polling["question"] = question.text
        let options = items
        polling["options"] = options
        polling["author"] = PFUser.current()
        var votes = [String:Int]()
        for option in options{
            votes[option] = 0
        }
        polling["votes"] = votes
        
        post["polling"] = polling
        polling.saveInBackground { (success, error) in
            if success {
                print("Saved!")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
        post.saveInBackground { (success, error) in
            if success {
                print("Saved!")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(items[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: "PollingItemCell", for:indexPath) as! PollingItemCell
        cell.name.text = items[indexPath.row]
        return cell
    }

}

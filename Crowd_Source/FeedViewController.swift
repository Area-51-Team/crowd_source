//
//  FeedViewController.swift
//  Crowd_Source
//
//  Created by Ryan Kwong on 4/9/22.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellUpdater {
    @IBOutlet weak var tableView: UITableView!
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        // Do any additional setup after loading the view.
//        addRatingPost()
//        addPollingPost()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")
        query.includeKeys(["polling", "rating"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func addPollingPost(){
        let post = PFObject(className: "Posts")
        let polling = PFObject(className: "PollingPosts")
        polling["question"] = "This is a polling question"
        let options = ["Option A", "Option B", "Option C"]
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
                self.tableView.reloadData()
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
        post.saveInBackground { (success, error) in
            if success {
                print("Saved!")
                self.tableView.reloadData()
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    func addRatingPost(){
        let post = PFObject(className: "Posts")
        let rating = PFObject(className: "RatingPosts")
        rating["question"] = "This is a rating question"
        rating["author"] = PFUser.current()
        rating["votes"] = ["1" : 0, "2" : 0, "3" : 0, "4" : 0, "5" : 0]
        post["rating"] = rating
        rating.saveInBackground { (success, error) in
            if success {
                print("Saved!")
                self.tableView.reloadData()
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
        post.saveInBackground { (success, error) in
            if success {
                print("Saved!")
                self.tableView.reloadData()
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    func updateTableView(){
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(posts[indexPath.row])
        let post = posts[indexPath.row]
        if post["polling"] != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollingCell") as! PollingCell
            let polling = post["polling"] as! PFObject
            cell.post = polling
            cell.question.text = polling["question"] as? String
            cell.setOptions(options: polling["options"] as? [String] ?? [])
            cell.delegate = self
            return cell
        }
        else if post["rating"] != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell") as! RatingCell
            let rating = post["rating"] as! PFObject
            cell.question.text = rating["question"] as? String
            cell.post = rating
            cell.delegate = self
            cell.setResult()
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
}

//
//  AddRatingViewController.swift
//  Crowd_Source
//
//  Created by Ryan Kwong on 4/20/22.
//

import UIKit
import Parse

class AddRatingViewController: UIViewController {

    
    @IBOutlet weak var question: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.isUserInteractionEnabled = true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onSubmit(_ sender: Any) {
        if(!question.hasText){
            print("Please enter a question")
            return
        }
        let post = PFObject(className: "Posts")
        let rating = PFObject(className: "RatingPosts")
        rating["question"] = question.text
        rating["author"] = PFUser.current()
        rating["votes"] = ["1" : 0, "2" : 0, "3" : 0, "4" : 0, "5" : 0]
        post["rating"] = rating
        rating.saveInBackground { (success, error) in
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
}

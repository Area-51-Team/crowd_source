//
//  AddPostViewController.swift
//  Crowd_Source
//
//  Created by Ryan Kwong on 4/20/22.
//

import UIKit

class AddPostViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    var viewControllers = [UIViewController]()
    var views = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let rating = AddRatingViewController()
        let polling = AddPollingViewController()
        rating.willMove(toParent: self)
        polling.willMove(toParent: self)
        viewControllers.append(rating)
        viewControllers.append(polling)
        for v in viewControllers {
            views.append(v.view)
            viewContainer.addSubview(v.view)
            self.addChild(v)
            v.didMove(toParent: self)
        }
        
        viewContainer.bringSubviewToFront(views[0])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        self.viewContainer.bringSubviewToFront(views[sender.selectedSegmentIndex])
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

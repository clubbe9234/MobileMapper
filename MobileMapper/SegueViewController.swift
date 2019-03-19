//
//  SegueViewController.swift
//  MobileMapper
//
//  Created by Caroline Lubbe on 3/18/19.
//  Copyright © 2019 John Hersey High School. All rights reserved.
//

import UIKit

class SegueViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    var descriptionOfPlace: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = descriptionOfPlace
        print(description)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func whenDismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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

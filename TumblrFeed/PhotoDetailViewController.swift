//
//  PhotoDetailViewController.swift
//  TumblrFeed
//
//  Created by Chanel Johnson on 6/22/17.
//  Copyright © 2017 Jessica Yeh. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    var photoURL : URL = URL(fileURLWithPath: "")
    @IBOutlet weak var photoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.af_setImage(withURL: photoURL)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

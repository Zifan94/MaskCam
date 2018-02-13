//
//  ResultViewController.swift
//  MaskCam
//
//  Created by Zifan  Yang on 2/12/18.
//  Copyright © 2018 Zifan  Yang. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var mask: UIImageView!
    var photoParam : UIImage?
    var maskParam : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleton = Singleton.sharedInstance()
        
        print(singleton.text)
        self.photo.image = self.photoParam
        self.mask.image = self.maskParam
        self.mask.clipsToBounds = true
        
        self.photo.alpha = 1
        self.mask.alpha = 0

    }

    @IBAction func exchange(_ sender: Any) {
        let tmpAlpha = self.photo.alpha
        self.photo.alpha = self.mask.alpha
        self.mask.alpha = tmpAlpha
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}

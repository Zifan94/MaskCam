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
//        self.photo.image = UIImage(named: "mydish1.jpg")
//        self.photo.backgroundColor = UIColor.black
        self.photo.clipsToBounds = true

    }
    
    ///////// exchange Button ///////////
    @IBAction func exchangeTouchDown(_ sender: Any) {
        self.mask.alpha = 1
        self.photo.alpha = 0
    }
    
    @IBAction func exchangeTouchUp(_ sender: Any) {
        self.mask.alpha = 0
        self.photo.alpha = 1
    }

    ///////// save image Button ///////////
    @IBAction func saveImage(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(self.photo.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Photo has been saved to your album.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}

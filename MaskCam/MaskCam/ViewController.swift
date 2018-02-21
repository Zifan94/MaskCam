//
//  ViewController.swift
//  MaskCam
//
//  Created by Zifan  Yang on 2/9/18.
//  Copyright © 2018 Zifan  Yang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var captureSesssion : AVCaptureSession!
    var cameraOutput : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var MaskImage: UIImageView!
    @IBOutlet weak var OpiqueSlider: UISlider!
 
    @IBOutlet weak var setMask: UIButton!
    @IBOutlet weak var takeShoot: UIButton!
    @IBOutlet weak var getInfo: UIButton!
    
//    @IBOutlet weak var tmpImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMask.clipsToBounds = false
        self.takeShoot.clipsToBounds = false
        self.getInfo.clipsToBounds = false
        self.MaskImage.image = UIImage(named:"nomask.PNG")
        self.MaskImage.alpha = 0
        self.previewView.clipsToBounds = true
        self.MaskImage.clipsToBounds = true
        self.resetSlider()
        captureSesssion = AVCaptureSession()
//        if (UIDevice.current.userInterfaceIdiom == .phone)
//        {
        captureSesssion.sessionPreset = AVCaptureSession.Preset.medium
//        }
        cameraOutput = AVCapturePhotoOutput()
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
//        self.tmpImg.image = UIImage(named: "mydish1.jpg")
//        self.tmpImg.alpha = 0.5
//        self.MaskImage.image = UIImage(named: "mydish2.jpg")
//        self.MaskImage.alpha = 1
//        self.MaskImage.clipsToBounds = true
//        self.tmpImg.clipsToBounds = true
        

        if let input = try? AVCaptureDeviceInput(device: device!) {
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                if (captureSesssion.canAddOutput(cameraOutput)) {
                    captureSesssion.addOutput(cameraOutput)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    previewLayer.frame = previewView.bounds
                    print(previewView.bounds)
                    previewView.clipsToBounds = true
                    previewView.layer.addSublayer(previewLayer)
                    previewView.clipsToBounds = true
                    captureSesssion.startRunning()
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
    }
    
    // Take picture button
    
    @IBAction func didPressTakePhoto(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    /////// Pick mask from Album ////////////////////////////////
    
    @IBAction func selectMask(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("error when open the photoLibrary")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        let image:UIImage!
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.MaskImage.image = image
        self.MaskImage.clipsToBounds = true
        self.previewView.bringSubview(toFront: self.MaskImage)
        self.MaskImage.alpha = CGFloat(self.OpiqueSlider.value)
        

        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
    }
    
    ///////// Set slider ///////////////////////////////////////////
    func resetSlider() {
        self.OpiqueSlider.minimumValue = 0
        self.OpiqueSlider.maximumValue = 1
        self.OpiqueSlider.thumbTintColor = UIColor.red
        self.OpiqueSlider.minimumTrackTintColor = UIColor.red
        self.OpiqueSlider.setThumbImage(UIImage(named: "tint17.PNG"), for: UIControlState.normal)
        self.OpiqueSlider.setThumbImage(UIImage(named: "tint17.PNG"), for: UIControlState.highlighted)
        self.OpiqueSlider.clipsToBounds = false
        self.OpiqueSlider.addTarget(self, action: #selector(changeOpique(OpiqueSlider:)), for: UIControlEvents.valueChanged)
    }
    
    @objc func changeOpique(OpiqueSlider:UISlider){
        let tmpOpique = OpiqueSlider.value
        self.MaskImage.alpha = CGFloat(tmpOpique)
    }
    
    
    // callBack from take picture
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("error occure : \(error.localizedDescription)")
        }
//        AVCapturePhoto.fileDataRepresentation(AVCapturePhoto)   fileDataRepresentation
        if  let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            print(UIImage(data: dataImage)?.size as Any)
            
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
            
            
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let RVC = sb.instantiateViewController(withIdentifier: "ResultVC") as! ResultViewController
            RVC.photoParam = image
            RVC.maskParam = self.MaskImage.image!
            self.present(RVC, animated: true, completion: nil)
            

        } else {
            print("some error here")
        }
    }
    
    // This method you can use somewhere you need to know camera permission   state
    func askPermission() {
        print("here")
        let cameraPermissionStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch cameraPermissionStatus {
        case .authorized:
            print("Already Authorized")
        case .denied:
            print("denied")
            
            let alert = UIAlertController(title: "Sorry :(" , message: "But  could you please grant permission for camera within device settings",  preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel,  handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        case .restricted:
            print("restricted")
        default:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
                [weak self]
                (granted :Bool) -> Void in
                
                if granted == true {
                    // User granted
                    print("User granted")
                    DispatchQueue.main.async(){
                        //Do smth that you need in main thread
                    }
                }
                else {
                    // User Rejected
                    print("User Rejected")
                    
                    DispatchQueue.main.async(){
                        let alert = UIAlertController(title: "WHY?" , message:  "Camera it is the main feature of our application", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            });
        }
    }
}




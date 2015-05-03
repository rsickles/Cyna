//
//  CameraViewController.swift
//  Cyna
//
//  Created by Ryan Sickles on 4/4/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var videoInput:AVCaptureInput!
    var stillImageOutput:AVCaptureStillImageOutput!
    
    @IBOutlet var open: UIBarButtonItem!
    //@IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraView: UIView!
    
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    //holds the image take
    var capturedImage = UIImage()
    var varView = Int()
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        
        //side menu stuff
        open.target = self.revealViewController()
        open.action = Selector("revealToggle:")
        if(varView == 0){
            //log out of app 
        }
        //
        self.captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        //check for device lock
        if(self.captureDevice?.lockForConfiguration(nil) == true){
            if((self.captureDevice?.isFocusModeSupported(AVCaptureFocusMode.AutoFocus)) != nil){
    //            [currentDevice setFocusPointOfInterest:autofocusPoint];
    //            let autofocusPoint = CGPointMake(0.5,0.5)
                self.captureDevice?.focusMode = AVCaptureFocusMode.AutoFocus
                self.captureDevice?.unlockForConfiguration()
            }
        }
        self.videoInput = AVCaptureDeviceInput(device: self.captureDevice, error: nil)
        self.stillImageOutput = AVCaptureStillImageOutput()
        
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) {
                if device.position == AVCaptureDevicePosition.Back {
                    self.captureDevice = (device as! AVCaptureDevice)
                    if self.captureDevice != nil {
                        println("Capture device found")
                    }
                }
            }
        }
        if self.captureDevice != nil {
            beginSession()
        }
}

    func beginSession() {
        var err : NSError? = nil
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { // 1
            self.captureSession.addOutput(self.stillImageOutput)
            self.captureSession.addInput(AVCaptureDeviceInput(device: self.captureDevice, error: &err))
            self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto
            if err != nil {
                println("error: \(err?.localizedDescription)")
            }
            var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            previewLayer?.frame = self.cameraView.layer.bounds
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            dispatch_async(dispatch_get_main_queue(), { // 2
                        // 3
                self.cameraView.layer.addSublayer(previewLayer)
                self.captureSession.startRunning()
                });
            });
    }

    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        var videoConnection:AVCaptureConnection?
        
        for connection in stillImageOutput.connections {
            for port in connection.inputPorts! {
                if port.mediaType == AVMediaTypeVideo {
                    videoConnection = connection as? AVCaptureConnection
                    break
                }
            }
            if videoConnection != nil {
                break
            }
        }
        
        if videoConnection != nil {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (buffer:CMSampleBuffer!, error:NSError!) -> Void in
                var image = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                var data_image = UIImage(data: image)
                //self.imageView.image = data_image
                println("YOOOO")
                println(data_image)
                self.capturedImage = data_image!
                self.captureSession.stopRunning()
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var dest : DialogViewController = segue.destinationViewController as! DialogViewController
        let navVC = segue.destinationViewController as! UINavigationController
        let tableVC = navVC.viewControllers.first as! DialogViewController
        tableVC.picture = self.capturedImage
    }
    
    // captureSession.startRunning() again once we move to the next screen or the picture is dismissed
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

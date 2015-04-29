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
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraView: UIView!
    
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)

        self.videoInput = AVCaptureDeviceInput(device: self.captureDevice, error: nil)
        self.stillImageOutput = AVCaptureStillImageOutput()
        
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) {
                                    println(device)
                if device.position == AVCaptureDevicePosition.Front {
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
        //        self.stillImageOutput = AVCaptureStillImageOutput()
        //        let output_settings = NSDictionary(objectsAndKeys: AVVideoCodecJPEG,AVVideoCodecKey)
        //        self.stillImageOutput.outputSettings = output_settings as [NSObject : AnyObject]
        //        //self.captureSession.addOutput(self.stillImageOutput)
        //
        //
        //        self.captureSession.addInput(AVCaptureDeviceInput(device: self.captureDevice, error: &err))
        //
        //        if err != nil {
        //            println("error: \(err?.localizedDescription)")
        //        }
        //        var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        //        previewLayer?.frame = self.cameraView.layer.bounds
        //        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //        self.cameraView.layer.addSublayer(previewLayer)
        //        captureSession.startRunning()
        
        var err : NSError? = nil
        
        if (self.captureSession.canAddInput(AVCaptureDeviceInput(device: self.captureDevice, error: &err))){
            self.captureSession.addInput(AVCaptureDeviceInput(device: self.captureDevice, error: &err))
        } else {
            println("cant add input")
        }

        self.captureSession.addOutput(self.stillImageOutput)
        
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        if err != nil {
            println("hhhhhhhh")
            println("error: \(err?.localizedDescription)")
        }
        var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        previewLayer?.frame = self.cameraView.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.cameraView.layer.addSublayer(previewLayer)
        self.captureSession.startRunning()
    }

    
    @IBAction func takePhoto(sender: UIButton) {
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
                self.imageView.image = data_image
                self.captureSession.stopRunning()
            })
        }
//        self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)) { (buffer:CMSampleBuffer!, error:NSError!) -> Void in
//            var image = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
//            var data_image = UIImage(data: image)
//            self.imageView.image = data_image
//            self.captureSession.stopRunning()
//        }
    }
    
        // captureSession.startRunning() again once we move to the next screen or the picture is dismissed
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

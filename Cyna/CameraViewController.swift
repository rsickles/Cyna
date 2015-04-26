//
//  CameraViewController.swift
//  Cyna
//
//  Created by Ryan Sickles on 4/4/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    
    var session = AVCaptureSession()
    var still_image_output = AVCaptureStillImageOutput()
    @IBOutlet var frameForCapture: UIView!
    @IBOutlet var imageView: UIImageView!
    
    
    
    
    @IBAction func takePhoto(sender: UIButton) {
        var video_connection = AVCaptureConnection()
        for connection in still_image_output.connections {
            if let connection = AVCaptureConnection() as AVCaptureConnection! {
            for port in connection.inputPorts {
                if(port.mediaType == AVMediaTypeVideo){
                    video_connection = connection
                    break
                }
            }
//                if(video_connection != nil){
//                    break
//                }
            }
        }
        let new_connection = AVCaptureConnection()
        still_image_output.captureStillImageAsynchronouslyFromConnection(AVCaptureConnection()); completionHandler;: { (sampledata:CMSampleBuffer!, error:NSError!) -> Void in
            if(sampledata != nil){
                let image_data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampledata)
                let image = UIImage(data: image_data)
                self.imageView.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        session.sessionPreset = AVCaptureSessionPresetPhoto
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let input_device = AVCaptureDeviceInput(device: device!, error: nil)
        if(session.canAddInput(input_device)){
            session.addInput(input_device)
        }
        let preview_layer = AVCaptureVideoPreviewLayer(session: session)
        preview_layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        let root_layer = CALayer(layer: self.view.layer)
        root_layer.masksToBounds = true
        
        let frame = self.frameForCapture.frame
        preview_layer.frame = frame
        root_layer.addSublayer(preview_layer)
        
        
        let outputSettings = NSDictionary(objectsAndKeys: AVVideoCodecJPEG,AVVideoCodecKey)
        still_image_output.outputSettings = outputSettings as [NSObject : AnyObject]
        
        session.addOutput(still_image_output)
        
        session.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

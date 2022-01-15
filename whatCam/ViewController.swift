//
//  ViewController.swift
//  whatCam
//
//  Created by anonym on 2022-01-14.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


        // Create Camera Device
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else{ return }
        guard let input =  try? AVCaptureDeviceInput(device: captureDevice) else {return}
        

        captureSession.addInput(input)
        captureSession.startRunning()

        // Outputs

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        view.layer.addSublayer(previewLayer)

        previewLayer.frame = view.frame


    }


}


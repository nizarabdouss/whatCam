//
//  ViewController.swift
//  whatCam
//
//  Created by anonym on 2022-01-14.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

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

        //output monitor 
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self,queue: DispatchQueue(label:"videoQueue"))
        captureSession.addOutput(dataOutput)

        // Determining objects in frame 
        //VNImageRequestHandler(cgImage:,options:[:]).perform(requests: request)



    }

    //output check
    func captureOutput(_ output: AVCaptureOutput,didOutput
    sampleBuffer: CMSampleBuffer,from connection: AVCaptureConnection){
        print("Camera was able to capture a frame:", Date())

        guard let pixelBuffer =
            CMSampleBufferGetImageBuffer(sampleBuffer) else {return}

        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else{return}
        let request = VNCoreMLRequest(model: model ){
            (finishedReq,err) in 
            //check errors
            print(finishedReq.results)
            guard let results = finishedReq.results as?
                [VNClassificationObservation] else {return}

            guard let firstObservation = results.first else {return}

            //printing results

            print(firstObservation.identifier,firstObservation.confidence)
            
        }
        

        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer,options:[:]).perform([request])
    }
}


//
//  ViewController.swift
//  QRCode
//
//  Created by Yevhen Kim on 2016-10-22.
//  Copyright © 2016 Yevhen Kim. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    @IBOutlet weak var lblQRCodeResult: UILabel!
    
    var objCaptureSession: AVCaptureSession?
    var objCaptureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    var vwQRCode: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let objCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice)
            objCaptureSession = AVCaptureSession()
            objCaptureSession?.addInput(objCaptureDeviceInput)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(objCaptureVideoPreviewLayer!)
        objCaptureSession?.startRunning()
        
        view.bringSubview(toFront: lblQRCodeResult)
        
        vwQRCode = UIView()
        if let vwQRCode = vwQRCode {
            vwQRCode.layer.borderColor = UIColor.green.cgColor
            vwQRCode.layer.borderWidth = 3
            view.addSubview(vwQRCode)
            view.bringSubview(toFront: vwQRCode)
        }
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRect.zero
            lblQRCodeResult.text = "NO QRCode text detacted"
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject)
            vwQRCode?.frame = objBarCode!.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                lblQRCodeResult.text = objMetadataMachineReadableCodeObject.stringValue
            }
        }
    }
}


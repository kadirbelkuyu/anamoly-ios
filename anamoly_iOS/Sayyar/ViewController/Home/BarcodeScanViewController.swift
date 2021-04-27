//
//  BarcodeScanViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 09/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScanViewController: BaseViewController {
    
    @IBOutlet weak var barcodeScannerView: UIView!
    
    var qrCodeFrameView                 :   UIView?
    var videoPreviewLayer               :   AVCaptureVideoPreviewLayer?
    var captureSession                  =   AVCaptureSession()
    fileprivate let supportedCodeTypes  =   [
                                                AVMetadataObject.ObjectType.upce,
                                                AVMetadataObject.ObjectType.code39,
                                                AVMetadataObject.ObjectType.code39Mod43,
                                                AVMetadataObject.ObjectType.code93,
                                                AVMetadataObject.ObjectType.code128,
                                                AVMetadataObject.ObjectType.ean8,
                                                AVMetadataObject.ObjectType.ean13,
                                                AVMetadataObject.ObjectType.aztec,
                                                AVMetadataObject.ObjectType.pdf417,
                                                AVMetadataObject.ObjectType.itf14,
                                                AVMetadataObject.ObjectType.dataMatrix,
                                                AVMetadataObject.ObjectType.interleaved2of5,
                                                AVMetadataObject.ObjectType.qr
                                            ]

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession.startRunning()
    }
  
    //MARK: - Prepare View -
    private func prepareView() {
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            self.showAlert(withMessage: "Failed to get the camera device", withActions: okButton)
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = CGRect(x: barcodeScannerView.bounds.origin.x, y: barcodeScannerView.bounds.origin.y, width: ScreenWidth, height: barcodeScannerView.frame.size.height)
        barcodeScannerView.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            barcodeScannerView.addSubview(qrCodeFrameView)
            barcodeScannerView.bringSubviewToFront(qrCodeFrameView)
        }
    }

    //MARK: - Action Methods -
    @IBAction func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Barcode Delegate -
extension BarcodeScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No Barcode code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                captureSession.stopRunning()
                print(metadataObj.stringValue ?? "")
                productBarcodeScanAPICall(barcodeString: metadataObj.stringValue ?? "")
            }
        }
    }
}

//MARK: - API Call -
extension BarcodeScanViewController {
    
    private func productBarcodeScanAPICall(barcodeString : String) {
        let param = [ SText.Parameter.barcode : barcodeString ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.productBarcodeScan(param), arrImages: [], onSuccess: { (response) in
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                let homeDetailViewController = UIStoryboard.Home.get(HomeDetailViewController.self)!
                homeDetailViewController.products = Products.init(aDict: data)
                self.navigationController?.pushViewController(homeDetailViewController, animated: true)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

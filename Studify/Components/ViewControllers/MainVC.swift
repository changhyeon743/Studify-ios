//
//  MainVC.swift
//  Studify
//
//  Created by 이창현 on 10/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//
import AVFoundation
import UIKit
import Rasat
import ActionSheetPicker_3_0

class MainVC: UIViewController {
    
    //var video = AVCaptureVideoPreviewLayer()
    var session = AVCaptureSession()
    var device : AVCaptureDevice!
    var output : AVCaptureVideoDataOutput!
    var previewLayer:AVCaptureVideoPreviewLayer!

    var cover : UIView = UIView()
    
    @IBOutlet weak var currentBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()

        
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch {
            print("Error")
        }
        self.navigationController?.navigationBar.isTranslucent = false
        
        output = AVCaptureVideoDataOutput()
        output.alwaysDiscardsLateVideoFrames = true
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "com.changhyeon743.studify"))
        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            return
        }
        
        cover.backgroundColor = .black
        cover.frame = view.frame
        UIApplication.shared.keyWindow!.addSubview(cover)
        UIApplication.shared.keyWindow!.bringSubviewToFront(cover)
        cover.isHidden = true
        session.startRunning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "집중"
    }
    
    private let disposeBag = DisposeBag()
    
    func subscribe() {
        disposeBag.add(API.shared.channel.observable.subscribe { (study) in
            
            switch study {
                
            case .start:
                self.cover.isHidden = false
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                break
                
            case .end (let amount):
                self.cover.isHidden = true
                let alert = UIAlertController(title: "이만큼 공부함", message: "\(amount)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
                
            }
            
        })
    }
    
    @IBAction func currentBtnPressed(_ sender: UIButton) {
        let studies = ["국어","수학","영어","과학","사회","한국사","일본어","프로그래밍","회계원리","디자인 일반"]
        ActionSheetStringPicker.show(withTitle: "공부 선택", rows: studies, initialSelection: 0, doneBlock: { (picker, index, value) in
            API.shared.currentUser?.current = studies[index]
            sender.setTitle(studies[index], for: .normal)
        }, cancel: { (picker) in
            return
        }, origin: sender)
    }
    
}

extension MainVC : AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if (self.tabBarController?.selectedViewController != self ) {
            return
        }
        
        //Calculating the luminosity
        let rawMetadata = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))
        let metadata = CFDictionaryCreateMutableCopy(nil, 0, rawMetadata) as NSMutableDictionary
        let exifData = metadata.value(forKey: "{Exif}") as? NSMutableDictionary
        
        let FNumber : Double = exifData?["FNumber"] as! Double
        let ExposureTime : Double = exifData?["ExposureTime"] as! Double
        let ISOSpeedRatingsArray = exifData!["ISOSpeedRatings"] as? NSArray
        let ISOSpeedRatings : Double = ISOSpeedRatingsArray![0] as! Double
        let CalibrationConstant : Double = 50
        
        let luminosity : Double = (CalibrationConstant * FNumber * FNumber ) / ( ExposureTime * ISOSpeedRatings )
        //5 보다 낮을 경우 시작
        if (luminosity < 4) {
            API.shared.study.isStudying = true;
        } else {
            API.shared.study.isStudying = false;
        }
        //print(luminosity)
    }
}

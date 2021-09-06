//
//  ExerciseVC.swift
//  ExceriseDemo
//
//  Created by Nirzar Gandhi on 03/09/21.
//

class ExerciseVC: UIViewController {
    
    //MARK: - UILabel Outlets
    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var lblExerciseName: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblTotalCount: UILabel!
    
    //MARK: - CameraPreview Outlet
    @IBOutlet weak var vCameraPreview: CameraPreview!
    
    //MARK: - Variable Declaration
    var timer = Timer()
    var intTimerCount = 30
    
    let videoDataOutputQueue = DispatchQueue(
        label: "CameraFeedOutput",
        qos: .userInteractive
    )
    var cameraFeedSession: AVCaptureSession?
    var activeInput : AVCaptureDeviceInput!
    var _videoOutput : AVCaptureVideoDataOutput?
    var captureVideoOutput = AVCaptureMovieFileOutput()
    
    //MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        lblTimer.text = "00:30"
        
        intTimerCount = 30
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [self] granted in
                if granted {
                    self.setupCamera()
                }
            }
            
        case .restricted:
            showCameraPermissionAlert()
            
        case .denied:
            showCameraPermissionAlert()
            
        case .authorized:
            setupCamera()
            
        @unknown default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
    }
    
    //MARK: - Initialization Method
    func initialization() {
        hideNavigationBar(isTabbar: false)
    }
    
    //MARK: - Show Location Permission Alert Method
    func showCameraPermissionAlert() {
        
        vCameraPreview.isHidden = true
        lblPleaseWait.isHidden = false
        
        let alertController = UIAlertController(title: "Camera Permission", message: AlertMessage.msgCameraPermission, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Open Settings", style: .default, handler: {(cAlertAction) in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        alertController.addAction(okAction)
        
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Start Timer Method
    @objc func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkTimer), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    //MARK: - Check Timer Method
    @objc func checkTimer() {
        if intTimerCount > 0 {
            intTimerCount -= 1
            
            lblTimer.text = timeString(time: TimeInterval(intTimerCount))
        } else {
            timer.invalidate()
            
            let objBreakTimeVC = AllStoryBoard.Main.instantiateViewController(withIdentifier: ViewControllerName.kBreakTimeVC) as! BreakTimeVC
            self.navigationController?.pushViewController(objBreakTimeVC, animated: true)
        }
    }
    
    //MARK: - Time String Method
    func timeString(time:TimeInterval) -> String {
        _ = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    //MARK: - Setup Camera Method
    func setupCamera() {
        do {
            if cameraFeedSession == nil {
                try setupAVSession()
                
                mainThread {
                    self.vCameraPreview.previewLayer.session = self.cameraFeedSession
                    self.vCameraPreview.previewLayer.videoGravity = .resizeAspectFill
                    
                    self.vCameraPreview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    
                    self.vCameraPreview.isHidden = false
                    self.lblPleaseWait.isHidden = true
                }
                
                cameraFeedSession?.startRunning()
                
                self.perform(#selector(self.startTimer), with: nil, afterDelay: 1.0)
            }
        } catch {
            print(error.localizedDescription)
            
            vCameraPreview.isHidden = true
            lblPleaseWait.isHidden = false
        }
    }
    
    //MARK: - Setup AV Session Method
    func setupAVSession() throws {
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw AppError.captureSessionSetup(reason: AlertMessage.msgNotFoundBackCamera)
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            throw AppError.captureSessionSetup(reason: AlertMessage.msgNotCreateVideoDevice)
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        guard session.canAddInput(deviceInput) else {
            throw AppError.captureSessionSetup(reason: AlertMessage.msgNotAddVideoInputSession)
        }
        
        activeInput = deviceInput
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw AppError.captureSessionSetup(reason: "Could not add video data output to the session")
        }
        
        if let connection = dataOutput.connection(with: .video),
           connection.isVideoOrientationSupported {
            connection.videoOrientation =
                AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue)!
            connection.isVideoMirrored = AVCaptureDevice.Position.back == .front
            
            // Inverse the landscape orientation to force the image in the upward
            // orientation.
            if connection.videoOrientation == .landscapeLeft {
                connection.videoOrientation = .landscapeRight
            } else if connection.videoOrientation == .landscapeRight {
                connection.videoOrientation = .landscapeLeft
            }
        }
        
        session.commitConfiguration()
        cameraFeedSession = session
        _videoOutput = dataOutput
    }
    
    //MARK: - Recorded Video Path URL Method
    func recordedVideoPathURL() -> URL? {
        
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
        let videoPath = documentsDirectory.appendingPathComponent("Video-\(Date().timeIntervalSince1970).mp4")
        
        return videoPath
    }
    
    
    //MARK: - UIButton Action Method
    @IBAction func btnStopAction(_ sender: Any) {
        timer.invalidate()
        
        lblTimer.text = "00:00"
    }
}

//MARK: - AVCaptureFileOutputRecordingDelegate Extension
extension ExerciseVC : AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}

//
//  ImageVideoPickerExtension.swift
//  ReadingRight_Practical_Test

protocol ChoosePicture {
    func takeAndChoosePhoto()
    func takeAndChooseVideo()
    func takePhoto()
    func takeVideo()
    func choosePhotoAndVideo(isPhoto : Bool,isVideo : Bool)
}

extension ChoosePicture where Self: UIViewController ,Self: UIImagePickerControllerDelegate , Self : UINavigationControllerDelegate {
    
    func alertPromptToAllowPhotoAccessViaSetting() {
        
        let alert = UIAlertController(title: nil, message: AlertMessage.msgPhotoLibraryPermission, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        alert.addAction(UIAlertAction(title: "Setting", style: .cancel) { (alert) -> Void in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            DispatchQueue.main.async {
                _ = self.navigationController?.popViewController(animated: true)
            }
        })
        
        present(alert, animated: true)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let alert = UIAlertController(title: nil, message: AlertMessage.msgCameraPermission, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        alert.addAction(UIAlertAction(title: "Setting", style: .cancel) { (alert) -> Void in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            DispatchQueue.main.async {
                _ = self.navigationController?.popViewController(animated: true)
            }
        })
        
        present(alert, animated: true)
    }
    
    func takeAndChoosePhoto() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) -> Void in
        })
        
        let btnTakePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: {(action: UIAlertAction) -> Void in
            self.takePhoto()
        })
        
        let btnChooseExisting = UIAlertAction(title: "Choose Photo", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.choosePhotoAndVideo(isPhoto: true, isVideo: false)
        })
        
        alert.addAction(btnCancel)
        alert.addAction(btnTakePhoto)
        alert.addAction(btnChooseExisting)
        
        alert.popoverPresentationController?.sourceView = self.view
        
        present(alert, animated: true)
    }
    
    func takeAndChooseVideo() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) -> Void in
        })
        
        let btnTakePhoto = UIAlertAction(title: "Take Video", style: .default, handler: {(action: UIAlertAction) -> Void in
            self.takeVideo()
        })
        
        let btnChooseExisting = UIAlertAction(title: "Choose Video", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            self.choosePhotoAndVideo(isPhoto: false, isVideo: true)
        })
        
        alert.addAction(btnCancel)
        alert.addAction(btnTakePhoto)
        alert.addAction(btnChooseExisting)
        
        alert.popoverPresentationController?.sourceView = self.view
        
        present(alert, animated: true)
    }
    
    func takePhoto() {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.view.makeToast(AlertMessage.msgNoCamera)
        } else {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            switch authStatus {
            
            case .authorized:
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                imagePickerController.modalPresentationStyle = .overFullScreen
                
                self.present(imagePickerController, animated: true, completion: {() -> Void in
                })
                
            case .denied:
                self.alertPromptToAllowCameraAccessViaSetting()
                
            default:
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                imagePickerController.modalPresentationStyle = .overFullScreen
                self.present(imagePickerController, animated: true, completion: {() -> Void in
                })
            }
        }
    }
    
    func takeVideo() {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.view.makeToast(AlertMessage.msgNoCamera)
        } else {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            switch authStatus {
            case .authorized:
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.mediaTypes = ["public.movie"]
                imagePickerController.delegate = self
                imagePickerController.modalPresentationStyle = .overFullScreen
                self.present(imagePickerController, animated: true, completion: {() -> Void in
                })
                
            case .denied:
                self.alertPromptToAllowCameraAccessViaSetting()
                
            default:
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.mediaTypes = ["public.movie"]
                imagePickerController.delegate = self
                imagePickerController.modalPresentationStyle = .overFullScreen
                self.present(imagePickerController, animated: true, completion: {() -> Void in
                })
            }
        }
    }
    
    func choosePhotoAndVideo(isPhoto : Bool,isVideo : Bool) {
        
        func openImagePickerController() {
            
            mainThread {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                
                if isPhoto && isVideo {
                    imagePickerController.mediaTypes = ["public.image","public.movie"]
                } else if isVideo {
                    imagePickerController.mediaTypes = ["public.movie"]
                }
                
                imagePickerController.delegate = self
                imagePickerController.modalPresentationStyle = .overFullScreen
                
                self.present(imagePickerController, animated: true, completion: {() -> Void in
                })
            }
        }
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            openImagePickerController()
        } else if (status == PHAuthorizationStatus.denied) {
            self.alertPromptToAllowPhotoAccessViaSetting()
        } else if (status == PHAuthorizationStatus.notDetermined) {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    openImagePickerController()
                } else {
                    DispatchQueue.main.async {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        } else if (status == PHAuthorizationStatus.restricted) {
        }
    }
}

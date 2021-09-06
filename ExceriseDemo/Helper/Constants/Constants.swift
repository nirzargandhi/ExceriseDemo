//
//  Constants.swift

//MARK: - Colors
extension UIColor {
    
    class func appBlack() -> UIColor { return UIColor(named: "AppBlack")! }
    class func appBlue() -> UIColor { return UIColor(named: "AppBlue")! }
    class func appGray() -> UIColor { return UIColor(named: "AppGray")! }
    class func appOrange() -> UIColor { return UIColor(named: "AppOrange")! }
    class func appRed() -> UIColor { return UIColor(named: "AppRed")! }
}

// MARK: - Global
enum GlobalConstants {
    
    static let appName    = Bundle.main.infoDictionary!["CFBundleName"] as! String
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}

//MARK: - StoryBoard Identifier's
enum AllStoryBoard {
    
    static let Main = UIStoryboard(name: "Main", bundle: nil)
}

//MARK: - ViewController Names
enum ViewControllerName {
    
    static let kGetReadyVC = "GetReadyVC"
    static let kExerciseVC = "ExerciseVC"
    static let kBreakTimeVC = "BreakTimeVC"
}

//MARK: - Cell Identifiers
enum CellIdentifiers {
    
}

//MARK: - Message's
enum AlertMessage {
    
    //In Progress Message
    static let msgInProgress = "In Progress"
    
    //Internet Connection Message
    static let msgNetworkConnection = "You are not connected to internet. Please connect and try again"
    
    //Camera, Images and ALbums Related Messages
    static let msgPhotoLibraryPermission = "Please enable access for photos from Privacy Settings"
    static let msgCameraPermission = "Please enable camera access from Privacy Settings"
    static let msgNoCamera = "Device has no camera"
    static let msgImageSaveIssue = "Photo is unable to save in your local storage. Please check storage or try after some time"
    static let msgSelectPhoto = "Please select photo"
    static let msgNotFoundBackCamera = "Could not find a back camera"
    static let msgNotCreateVideoDevice = "Could not create video device input"
    static let msgNotAddVideoInputSession = "Could not add video device input to the session"
    static let msgNotAdVideoOutputSession = "Could not add video data output to the session"
    
    //General Error Message
    static let msgError = "Something went wrong. Please try after sometime"
    
    //Video Error Message
    static let msgVideoUnavailable = "Video is not available for this location"
    
    //Validation Message
    static let msgTourname = "Please enter tour name"
    
    //General Delete Message
    static let msgGeneralDelete = "Are you sure you want to delete?"
    
    //Save - Success and Fail Message
    static let msgSaveSuccess = "Tour has been saved successfully"
    static let msgSaveFailed = "Unable to save tour. Please try again after sometime"
    
    //Logout Message
    static let msgLogout = "Are you sure you want to log out from the application?"
}

//MARK: - Web Service URLs
enum WebServiceURL {
    
    static let mainURL = ""
}

//MARK: - Web Service Parameters
enum WebServiceParameter {
    
}

//MARK: - UserDefault
enum UserDefault {
    
    static let kAPIToken = "api_token"
    static let kIsKeyChain = "isKeyChain"
}

//MARK: - Constants
struct Constants {
    
    //MARK: - Device Type
    enum UIUserInterfaceIdiom : Int {
        
        case Unspecified
        case Phone
        case Pad
    }
    
    //MARK: - Screen Size
    struct ScreenSize {
        
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
}

//MARK: - DateTime Format
enum DateAndTimeFormatString {
    
    static let strDateFormate_ddMMMyyyyhhmmss = "dd MMM yyyy hh:mm:ss a"
    static let strDateFormate_ddMMMyyyy = "dd MMM yyyy"
    static let strDateFormate_hhmma = "hh:mm a"
}

//MARK: - AppError
enum AppError: Error {
    case captureSessionSetup(reason: String)
    case visionError(error: Error)
    case otherError(error: Error)
    
    static func display(_ error: Error, inViewController viewController: UIViewController) {
        if let appError = error as? AppError {
            appError.displayInViewController(viewController)
        } else {
            AppError.otherError(error: error).displayInViewController(viewController)
        }
    }
    
    func displayInViewController(_ viewController: UIViewController) {
        let title: String?
        let message: String?
        
        switch self {
        
        case .captureSessionSetup(let reason):
            title = "AVSession Setup Error"
            message = reason
            
        case .visionError(let error):
            title = "Vision Error"
            message = error.localizedDescription
            
        case .otherError(let error):
            title = "Error"
            message = error.localizedDescription
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

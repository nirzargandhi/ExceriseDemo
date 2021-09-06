//
//  Extension.swift

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension UIApplication {
    
    var screenShot: UIImage?  {
        
        if let rootViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            let scale = UIScreen.main.scale
            let bounds = rootViewController.view.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale);
            if let _ = UIGraphicsGetCurrentContext() {
                rootViewController.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return screenshot
            }
        }
        return nil
    }
    
    public func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.endBackgroundTask(taskID)
        }
    }
    
    public class func topViewController(_ base: UIViewController? = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension UIViewController {
    
    //MARK: - Show/Hide Navigation Bar Methods
    func showNavigationBar(isTabbar : Bool = true) {
        if isTabbar {
            self.tabBarController?.navigationController?.setNavigationBarHidden(false, animated: false)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    func hideNavigationBar(isTabbar : Bool = true) {
        if isTabbar {
            self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    func setNavigationHeader(strTitleName : String, isTabbar : Bool = true) {
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Poppins-Bold", size: 22.0) ?? UIFont.systemFont(ofSize: 22).withWeight(UIFont.Weight.bold)
        label.textAlignment = .center
        label.textColor = .white
        label.text = strTitleName
        
        if isTabbar {
            self.tabBarController?.navigationItem.titleView = label
            
            self.tabBarController?.navigationController?.navigationBar.shadowImage = UIImage()
            self.tabBarController?.navigationController?.navigationBar.barTintColor = .appBlack()
            self.tabBarController?.navigationController?.navigationBar.tintColor = .white
            self.tabBarController?.navigationController?.navigationBar.isTranslucent = false
        } else {
            self.navigationItem.titleView = label
            
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = .appBlack()
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    //MARK: - Setup Back Button Method
    func setupBackButton(isTabbar : Bool = true) {
        let btnBack = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(popVC))
        if isTabbar {
            self.tabBarController?.navigationItem.leftBarButtonItem = btnBack
        } else {
            self.navigationItem.leftBarButtonItem = btnBack
        }
    }
    
    @objc func popVC() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    //MARK: - Share Link Method
    func shareLink(strShareLink : String) {
        
        let urlShareLink = URL(string: strShareLink)
        let activityViewController = UIActivityViewController(activityItems: [urlShareLink!] as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

public extension UINavigationController {
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    public func setShadowNavigationBar(){
        self.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationBar.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationBar.shadowRadius = 4.0
        self.navigationBar.shadowOpacity = 2.0
        self.navigationBar.layer.masksToBounds = false
    }
    
    func popViewController(_ completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: true)
        CATransaction.commit()
    }
    
    func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    func makeTransparent(withTint tint: UIColor = .white) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = tint
        navigationBar.titleTextAttributes = [.foregroundColor: tint]
    }
}

public extension UICollectionView {
    
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}

public extension UITableView {
    
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    func removeTableFooterView() {
        tableFooterView = nil
    }
    
    func removeTableHeaderView() {
        tableHeaderView = nil
    }
    
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
    
    func setAttributes(isSeparator : Bool = false) {
        estimatedRowHeight = UITableView.automaticDimension
        rowHeight = UITableView.automaticDimension
        tableFooterView = UIView()
        
        if isSeparator {
            separatorColor = .lightGray
        }
    }
}

public extension UISearchBar {
    
    var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
    
    var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

public extension UISlider {
    
    func setValue(_ value: Float, animated: Bool = true, duration: TimeInterval = 1, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.setValue(value, animated: true)
            }, completion: { _ in
                completion?()
            })
        } else {
            setValue(value, animated: false)
            completion?()
        }
    }
}

public extension UIViewController {
    
    //MARK: - Add/Remove Notification Observer Method
    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}

@IBDesignable
extension UIDatePicker {
    @IBInspectable var textLabelColor: UIColor? {
        get {
            return self.value(forKey: "textColor") as? UIColor
        }
        set {
            self.setValue(newValue, forKey: "textColor")
        }
    }
}

public extension CLLocation {
    
    static func midLocation(start: CLLocation, end: CLLocation) -> CLLocation {
        let lat1 = Double.pi * start.coordinate.latitude / 180.0
        let long1 = Double.pi * start.coordinate.longitude / 180.0
        let lat2 = Double.pi * end.coordinate.latitude / 180.0
        let long2 = Double.pi * end.coordinate.longitude / 180.0
        
        let bx = cos(lat2) * cos(long2 - long1)
        let by = cos(lat2) * sin(long2 - long1)
        let mlat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bx) * (cos(lat1) + bx) + (by * by)))
        let mlong = (long1) + atan2(by, cos(lat1) + bx)
        
        return CLLocation(latitude: (mlat * 180 / Double.pi), longitude: (mlong * 180 / Double.pi))
    }
    
    
    func midLocation(to point: CLLocation) -> CLLocation {
        return CLLocation.midLocation(start: self, end: point)
    }
    
    func bearing(to destination: CLLocation) -> Double {
        let lat1 = Double.pi * coordinate.latitude / 180.0
        let long1 = Double.pi * coordinate.longitude / 180.0
        let lat2 = Double.pi * destination.coordinate.latitude / 180.0
        let long2 = Double.pi * destination.coordinate.longitude / 180.0
        
        let rads = atan2(sin(long2 - long1) * cos(lat2),
                         cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1))
        let degrees = rads * 180 / Double.pi
        
        return (degrees+360).truncatingRemainder(dividingBy: 360)
    }
}

@IBDesignable
class CustomSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 3
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
}

class CustomLabel: UILabel {
    override var text: String? {
        didSet {
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)))
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat , font : UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat , font : UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension Bundle {
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    var bundleId: String {
        return bundleIdentifier!
    }
    
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}

class CustomTitleView: UIView {
    
    override var intrinsicContentSize: CGSize {
        self.translatesAutoresizingMaskIntoConstraints = false
        return UIView.layoutFittingExpandedSize
    }
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}

extension Encodable {
    
    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
}

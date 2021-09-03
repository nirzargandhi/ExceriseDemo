//
//  UISideMenuNavigationController.swift

@objc public protocol UISideMenuNavigationControllerDelegate {
    @objc optional func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool)
    @objc optional func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool)
    @objc optional func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool)
    @objc optional func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool)
}

@objcMembers
open class UISideMenuNavigationController: UINavigationController {
    
    fileprivate weak var foundDelegate: UISideMenuNavigationControllerDelegate?
    fileprivate weak var activeDelegate: UISideMenuNavigationControllerDelegate? {
        get {
            guard !view.isHidden else {
                return nil
            }
            
            return sideMenuDelegate ?? foundDelegate ?? findDelegate(forViewController: presentingViewController)
        }
    }
    fileprivate func findDelegate(forViewController: UIViewController?) -> UISideMenuNavigationControllerDelegate? {
        if let navigationController = forViewController as? UINavigationController {
            return findDelegate(forViewController: navigationController.topViewController)
        }
        if let tabBarController = forViewController as? UITabBarController {
            return findDelegate(forViewController: tabBarController.selectedViewController)
        }
        if let splitViewController = forViewController as? UISplitViewController {
            return findDelegate(forViewController: splitViewController.viewControllers.last)
        }
        
        foundDelegate = forViewController as? UISideMenuNavigationControllerDelegate
        return foundDelegate
    }
    fileprivate var usingInterfaceBuilder = false
    internal var locked = false
    internal var originalMenuBackgroundColor: UIColor?
    internal var transition: SideMenuTransition {
        get {
            return sideMenuManager.transition
        }
    }
    
    open weak var sideMenuDelegate: UISideMenuNavigationControllerDelegate?
    
    open weak var sideMenuManager: SideMenuManager! = SideMenuManager.default {
        didSet {
            if locked && oldValue != nil {
                print("SideMenu Warning: a menu's sideMenuManager property cannot be changed after it has loaded.")
                sideMenuManager = oldValue
            }
        }
    }
    
    @IBInspectable open var menuWidth: CGFloat = 0 {
        didSet {
            if !isHidden && oldValue != menuWidth {
                print("SideMenu Warning: a menu's width property can only be changed when it is hidden.")
                menuWidth = oldValue
            }
        }
    }
    
    @IBInspectable open var leftSide: Bool = false {
        didSet {
            if locked && leftSide != oldValue {
                print("SideMenu Warning: a menu's leftSide property cannot be changed after it has loaded.")
                leftSide = oldValue
            }
        }
    }
    
    open var isHidden: Bool {
        get {
            return self.presentingViewController == nil
        }
    }
    
    #if !STFU_SIDEMENU
    @available(*, unavailable, renamed: "init(rootViewController:)")
    public init() {
        fatalError("init is not available")
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    #endif
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        usingInterfaceBuilder = true
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if !locked && usingInterfaceBuilder {
            if leftSide {
                sideMenuManager.menuLeftNavigationController = self
            } else {
                sideMenuManager.menuRightNavigationController = self
            }
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentingViewController?.view.endEditing(true)
        
        foundDelegate = nil
        activeDelegate?.sideMenuWillAppear?(menu: self, animated: animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if view.isHidden {
            transition.hideMenuComplete()
            dismiss(animated: false, completion: { () -> Void in
                self.view.isHidden = false
            })
            
            return
        }
        
        activeDelegate?.sideMenuDidAppear?(menu: self, animated: animated)
        
        #if !STFU_SIDEMENU
        if topViewController == nil {
            print("SideMenu Warning: the menu doesn't have a view controller to show! UISideMenuNavigationController needs a view controller to display just like a UINavigationController.")
        }
        #endif
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !isBeingDismissed {
            guard let sideMenuManager = sideMenuManager else {
                return
            }
            
            if let mainView = transition.mainViewController?.view {
                switch sideMenuManager.menuPresentMode {
                case .viewSlideOut, .viewSlideInOut:
                    mainView.superview?.insertSubview(view, belowSubview: mainView)
                case .menuSlideIn, .menuDissolveIn:
                    if let tapView = transition.tapView {
                        mainView.superview?.insertSubview(view, aboveSubview: tapView)
                    } else {
                        mainView.superview?.insertSubview(view, aboveSubview: mainView)
                    }
                }
            }
            
            UIView.animate(withDuration: animated ? sideMenuManager.menuAnimationDismissDuration : 0,
                           delay: 0,
                           usingSpringWithDamping: sideMenuManager.menuAnimationUsingSpringWithDamping,
                           initialSpringVelocity: sideMenuManager.menuAnimationInitialSpringVelocity,
                           options: sideMenuManager.menuAnimationOptions,
                           animations: {
                            self.transition.hideMenuStart()
                            self.activeDelegate?.sideMenuWillDisappear?(menu: self, animated: animated)
                           }) { (finished) -> Void in
                self.activeDelegate?.sideMenuDidDisappear?(menu: self, animated: animated)
                self.view.isHidden = true
            }
            
            return
        }
        
        activeDelegate?.sideMenuWillDisappear?(menu: self, animated: animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let sideMenuDelegate = activeDelegate as? UIViewController, sideMenuDelegate.view.window == nil {
            transition.hideMenuStart().hideMenuComplete()
        }
        
        activeDelegate?.sideMenuDidDisappear?(menu: self, animated: animated)
        
        guard let tableViewController = topViewController as? UITableViewController,
              let tableView = tableViewController.tableView,
              let indexPaths = tableView.indexPathsForSelectedRows,
              tableViewController.clearsSelectionOnViewWillAppear else {
            return
        }
        
        for indexPath in indexPaths {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard !view.isHidden else {
            return
        }
        
        NotificationCenter.default.removeObserver(self.transition, name: UIApplication.willChangeStatusBarFrameNotification, object: nil)
        coordinator.animate(alongsideTransition: { (context) in
            self.transition.presentMenuStart()
        }) { (context) in
            NotificationCenter.default.addObserver(self.transition, selector:#selector(SideMenuTransition.handleNotification), name: UIApplication.willChangeStatusBarFrameNotification, object: nil)
        }
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let sideMenuManager = sideMenuManager, viewControllers.count > 0 && sideMenuManager.menuPushStyle != .subMenu else {
            
            super.pushViewController(viewController, animated: animated)
            return
        }
        
        let splitViewController = presentingViewController as? UISplitViewController
        let tabBarController = presentingViewController as? UITabBarController
        let potentialNavigationController = (splitViewController?.viewControllers.first ?? tabBarController?.selectedViewController) ?? presentingViewController
        guard let navigationController = potentialNavigationController as? UINavigationController else {
            print("SideMenu Warning: attempt to push a View Controller from \(String(describing: potentialNavigationController.self)) where its navigationController == nil. It must be embedded in a Navigation Controller for this to work.")
            return
        }
        
        let activeDelegate = self.activeDelegate
        foundDelegate = nil
        
        CATransaction.begin()
        if sideMenuManager.menuDismissOnPush {
            let animated = animated || sideMenuManager.menuAlwaysAnimate
            
            CATransaction.setCompletionBlock( { () -> Void in
                activeDelegate?.sideMenuDidDisappear?(menu: self, animated: animated)
                if !animated {
                    self.transition.hideMenuStart().hideMenuComplete()
                }
                self.dismiss(animated: animated, completion: nil)
            })
            
            if animated {
                let areAnimationsEnabled = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(true)
                UIView.animate(withDuration: sideMenuManager.menuAnimationDismissDuration,
                               delay: 0,
                               usingSpringWithDamping: sideMenuManager.menuAnimationUsingSpringWithDamping,
                               initialSpringVelocity: sideMenuManager.menuAnimationInitialSpringVelocity,
                               options: sideMenuManager.menuAnimationOptions,
                               animations: {
                                activeDelegate?.sideMenuWillDisappear?(menu: self, animated: animated)
                                self.transition.hideMenuStart()
                               })
                UIView.setAnimationsEnabled(areAnimationsEnabled)
            }
        }
        
        if let lastViewController = navigationController.viewControllers.last, !sideMenuManager.menuAllowPushOfSameClassTwice && type(of: lastViewController) == type(of: viewController) {
            CATransaction.commit()
            return
        }
        
        switch sideMenuManager.menuPushStyle {
        
        case .subMenu, .defaultBehavior:
            break
            
        case .popWhenPossible:
            for subViewController in navigationController.viewControllers.reversed() {
                if type(of: subViewController) == type(of: viewController) {
                    navigationController.popToViewController(subViewController, animated: animated)
                    CATransaction.commit()
                    return
                }
            }
            
        case .preserve, .preserveAndHideBackButton:
            var viewControllers = navigationController.viewControllers
            let filtered = viewControllers.filter { preservedViewController in type(of: preservedViewController) == type(of: viewController) }
            if let preservedViewController = filtered.last {
                viewControllers = viewControllers.filter { subViewController in subViewController !== preservedViewController }
                if sideMenuManager.menuPushStyle == .preserveAndHideBackButton {
                    preservedViewController.navigationItem.hidesBackButton = true
                }
                viewControllers.append(preservedViewController)
                navigationController.setViewControllers(viewControllers, animated: animated)
                CATransaction.commit()
                return
            }
            if sideMenuManager.menuPushStyle == .preserveAndHideBackButton {
                viewController.navigationItem.hidesBackButton = true
            }
            
        case .replace:
            viewController.navigationItem.hidesBackButton = true
            navigationController.setViewControllers([viewController], animated: animated)
            CATransaction.commit()
            return
        }
        
        navigationController.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}



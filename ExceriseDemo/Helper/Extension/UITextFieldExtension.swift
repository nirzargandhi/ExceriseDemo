//
//  UITextFieldExtension.swift
//  ReadingRight_Practical_Test

// MARK: - UITextField Character Limit
private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
              prospectiveText.count > maxLength
        else {
            return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = String(prospectiveText.prefix(upTo: maxCharIndex))
        selectedTextRange = selection
    }
    
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let alphanumericRegex = "^(?=.*\\d)(?=.*\\D)([a-zA-Z0-9]{8,15})$"
    
    public func addLeftTextPadding(_ blankSize: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    public func addLeftIcon(_ image: UIImage?, frame: CGRect, imageSize: CGSize) {
        let leftView = UIView()
        leftView.frame = frame
        let imgView = UIImageView()
        imgView.frame = CGRect(x: frame.width - 8 - imageSize.width, y: (frame.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        imgView.image = image
        leftView.addSubview(imgView)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    func validateEmail() -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", UITextField.emailRegex)
        return emailTest.evaluate(with: self.text)
    }
    
    func validateDigits() -> Bool {
        let digitsRegEx = "[0-9]*"
        let digitsTest = NSPredicate(format:"SELF MATCHES %@", digitsRegEx)
        return digitsTest.evaluate(with: self.text)
    }
    
    func validateAlphaNumeric() -> Bool {
        let alphaNumeric = NSPredicate(format:"SELF MATCHES %@", UITextField.alphanumericRegex)
        return alphaNumeric.evaluate(with: self.text)
    }
    
    public var isEmpty: Bool {
        return trimmedText?.isEmpty == true
    }
    
    public var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func checkMinAndMaxLength(withMinLimit minLen: Int, withMaxLimit maxLen: Int) -> Bool {
        if (self.text!.count ) >= minLen && (self.text!.count ) <= maxLen {
            return true
        }
        return false
    }
    
    func checkLength(withMaxLimit maxLen: Int) -> Bool {
        if (self.text!.count ) == maxLen {
            return true
        }
        return false
    }
        
    enum Direction{
        case Left
        case Right
    }
    
    func addImage(direction : Direction, image : UIImage, Frame : CGRect, backgroundColor : UIColor) {
        let View = UIView(frame: Frame)
        View.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: Frame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.contentMode = .center
        imageView.tintColor = .black
        View.addSubview(imageView)
        
        if Direction.Left == direction {
            self.leftViewMode = .always
            self.leftView = View
        } else {
            self.rightViewMode = .always
            self.rightView = View
        }
    }
}

extension UITextField {
    
    @IBInspectable var paddingLeftView: CGFloat {
        get {
            return self.leftView?.frame.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightView: CGFloat {
        get {
            return self.leftView?.frame.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

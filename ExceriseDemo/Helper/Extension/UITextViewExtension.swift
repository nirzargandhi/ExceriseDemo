//
//  UITextViewExtension.swift
//  ReadingRight_Practical_Test

private let kPlaceholderTextViewInsetSpan: CGFloat = 15

@IBDesignable class PlaceholderTextView: UITextView {
    
    @IBInspectable var placeholder: NSString? { didSet { setNeedsDisplay() } }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGray
    
    @IBInspectable var TextViewBorderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = TextViewBorderColor.cgColor
        }
    }
    
    @IBInspectable var TextViewBorderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var TextViewCornerRadius: CGFloat = 6.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0.0
        }
    }
    
    override var text: String! { didSet { setNeedsDisplay() } }
    
    override var attributedText: NSAttributedString! { didSet { setNeedsDisplay() } }
    
    override var contentInset: UIEdgeInsets { didSet { setNeedsDisplay() } }
    
    override var font: UIFont? { didSet { setNeedsDisplay() } }
    
    override var textAlignment: NSTextAlignment { didSet { setNeedsDisplay() } }
    
    #if !TARGET_INTERFACE_BUILDER
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        listenForTextChangedNotifications()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        listenForTextChangedNotifications()
    }
    #endif
    
    func listenForTextChangedNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textChangedForPlaceholderTextView(_:)), name:UITextView.textDidChangeNotification , object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textChangedForPlaceholderTextView(_:)), name:UITextView.textDidBeginEditingNotification , object: self)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil { NotificationCenter.default.removeObserver(self) }
        else { listenForTextChangedNotifications() }
    }
    
    
    @objc func textChangedForPlaceholderTextView(_ notification: Notification) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if text.count == 0 && self.placeholder != nil {
            let baseRect = placeholderBoundsContainedIn(self.bounds)
            let font = self.font ?? self.typingAttributes[NSAttributedString.Key.font] as? UIFont ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            
            self.placeholderColor.set()
            
            var customParagraphStyle: NSMutableParagraphStyle!
            if let defaultParagraphStyle =  typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle {
                customParagraphStyle = defaultParagraphStyle.mutableCopy() as? NSMutableParagraphStyle
            } else { customParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
            }
            
            customParagraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
            customParagraphStyle.alignment = self.textAlignment
            
            let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: customParagraphStyle.copy() as! NSParagraphStyle, NSAttributedString.Key.foregroundColor: self.placeholderColor]
            self.placeholder?.draw(in: baseRect, withAttributes: attributes)
        }
    }
    
    func placeholderBoundsContainedIn(_ containerBounds: CGRect) -> CGRect {
        
        let baseRect = containerBounds.inset(by: UIEdgeInsets(top: kPlaceholderTextViewInsetSpan+self.contentInset.top, left: 15, bottom: 0, right: 15))
        
        
        if let paragraphStyle = typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle {
            baseRect.offsetBy(dx: paragraphStyle.headIndent, dy: paragraphStyle.firstLineHeadIndent)
        }
        
        return baseRect
    }
}



//
//  FontChangesExtension.swift
//  ReadingRight_Practical_Test

extension UILabel {
    public var substituteFontName : String {
        get {
            return self.font.fontName;
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased();
            var fontName = newValue;
            if fontNameToTest?.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest?.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest?.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest?.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: (self.font?.pointSize) ?? 17)
        }
    }
}

extension UIButton {
    public var substituteFontName : String {
        get {
            print(self.titleLabel?.font.fontName ?? "")
            return (self.titleLabel?.font.fontName) ?? "";
        }
        set {
            if (self.titleLabel?.font.fontName != ""){
                let fontNameToTest = self.titleLabel?.font.fontName.lowercased();
                var fontName = newValue;
                if fontNameToTest?.range(of: "bold") != nil {
                    fontName += "-Bold";
                } else if fontNameToTest?.range(of: "medium") != nil {
                    fontName += "-Medium";
                } else if fontNameToTest?.range(of: "light") != nil {
                    fontName += "-Light";
                } else if fontNameToTest?.range(of: "ultralight") != nil {
                    fontName += "-UltraLight";
                }
                self.titleLabel?.font = UIFont(name: fontName, size: (self.titleLabel?.font.pointSize) ?? 17)
            } else{
                self.titleLabel?.font = UIFont.systemFont(ofSize: (self.titleLabel?.font.pointSize) ?? 15)
            }
            
        }
    }
}

extension UITextView {
    public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UITextField {
    public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}


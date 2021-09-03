//
//  IntExtensions.swift

public extension Int {
    
    var countableRange: CountableRange<Int> {
        return 0..<self
    }
    
    var degreesToRadians: Double {
        return Double.pi * Double(self) / 180.0
    }
    
    var radiansToDegrees: Double {
        return Double(self) * 180 / Double.pi
    }
    
    var uInt: UInt {
        return UInt(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var float: Float {
        return Float(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var kFormatted: String {
        var sign: String {
            return self >= 0 ? "" : "-"
        }
        let abs = Swift.abs(self)
        if abs == 0 {
            return "0k"
        } else if abs >= 0 && abs < 1000 {
            return "0k"
        } else if abs >= 1000 && abs < 1000000 {
            return String(format: "\(sign)%ik", abs / 1000)
        }
        
        return String(format: "\(sign)%ikk", abs / 100000)
    }
}

public extension Int {
    
    static func random(between min: Int, and max: Int) -> Int {
        return random(inRange: min...max)
    }
    
    static func random(inRange range: ClosedRange<Int>) -> Int {
        let delta = UInt32(range.upperBound - range.lowerBound + 1)
        return range.lowerBound + Int(arc4random_uniform(delta))
    }
    
    func isPrime() -> Bool {
        if self == 2 {
            return true
        }
        
        guard self > 1 && self % 2 != 0 else {
            return false
        }
        
        let base = Int(sqrt(Double(self)))
        for i in Swift.stride(from: 3, through: base, by: 2) where self % i == 0 {
            return false
        }
        return true
    }
    
    func romanNumeral() -> String? {
        
        guard self > 0 else {
            return nil
        }
        
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        
        var romanValue = ""
        var startingValue = self
        
        for (index, romanChar) in romanValues.enumerated() {
            let arabicValue = arabicValues[index]
            let div = startingValue / arabicValue
            if div > 0 {
                for _ in 0..<div {
                    romanValue += romanChar
                }
                startingValue -= arabicValue * div
            }
        }
        return romanValue
    }
}

public extension Int {
    
    init(randomBetween min: Int, and max: Int) {
        self = Int.random(between: min, and: max)
    }
    
    init(randomInRange range: ClosedRange<Int>) {
        self = Int.random(inRange: range)
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }

infix operator ** : PowerPrecedence

public func ** (lhs: Int, rhs: Int) -> Double {
    return pow(Double(lhs), Double(rhs))
}

prefix operator √

public prefix func √ (int: Int) -> Double {
    return sqrt(Double(int))
}

infix operator ±

public func ± (lhs: Int, rhs: Int) -> (Int, Int) {
    return (lhs + rhs, lhs - rhs)
}

prefix operator ±

public prefix func ± (int: Int) -> (Int, Int) {
    return 0 ± int
}

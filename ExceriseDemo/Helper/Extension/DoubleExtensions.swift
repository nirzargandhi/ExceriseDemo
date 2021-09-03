//
//  DoubleExtensions.swift

extension Double {
    
    var int: Int {
        return Int(self)
    }
    
    var float: Float {
        return Float(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }

infix operator ** : PowerPrecedence

public func ** (lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)
}

prefix operator √

public prefix func √ (double: Double) -> Double {
    return sqrt(double)
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

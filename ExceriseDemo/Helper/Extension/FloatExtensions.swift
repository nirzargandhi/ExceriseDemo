//
//  FloatExtensions.swift

public extension Float {
	
    var int: Int {
		return Int(self)
	}
	
    var double: Double {
		return Double(self)
	}
	
    var cgFloat: CGFloat {
		return CGFloat(self)
	}
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }

infix operator ** : PowerPrecedence

public func ** (lhs: Float, rhs: Float) -> Float {
	return pow(lhs, rhs)
}

prefix operator √

public prefix func √ (float: Float) -> Float {
	return sqrt(float)
}

extension CGFloat {
    
    public var abs: CGFloat {
        return Swift.abs(self)
    }
    
    public var ceil: CGFloat {
        return Foundation.ceil(self)
    }
    
    public var floor: CGFloat {
        return Foundation.floor(self)
    }
    
    public var isPositive: Bool {
        return self > 0
    }
    
    public var isNegative: Bool {
        return self < 0
    }
    
    public var int: Int {
        return Int(self)
    }
    
    public var float: Float {
        return Float(self)
    }
    
    public var double: Double {
        return Double(self)
    }
    
    public var radiansToDegrees: CGFloat {
        return self * 180 / CGFloat.pi
    }
    
    public static func randomBetween(min: CGFloat, max: CGFloat) -> CGFloat {
        let delta = max - min
        return min + CGFloat(arc4random_uniform(UInt32(delta)))
    }
    
    public func degreesToRadians() -> CGFloat {
        return (.pi * self) / 180.0
    }
}

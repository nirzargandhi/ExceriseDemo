//
//  OptionalExtensions.swift

infix operator ??= : AssignmentPrecedence

public extension Optional {
    
    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }
    
    func run(_ block: (Wrapped) -> Void) {
        _ = self.map(block)
    }
    
    static func ??= (lhs: inout Optional, rhs: Optional) {
        guard let rhs = rhs else { return }
        lhs = rhs
    }
}

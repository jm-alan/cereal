public protocol Serializable {
    func serialize() -> String
}

public extension Serializable {
    @inlinable
    @inline(__always)
    func serialize() -> String {
        "\(self)"
    }
}

extension Bool: Serializable {}
extension Int: Serializable {}
extension Int8: Serializable {}
extension Int16: Serializable {}
extension Int32: Serializable {}
extension Int64: Serializable {}
extension Float: Serializable {}
extension Double: Serializable {}

extension String: Serializable {
    @inlinable
    @inline(__always)
    public func serialize() -> String {
        return "\"\(Parse.escape(string: self))\""
    }
}

extension Array: Serializable where Element: Serializable {
    @inlinable
    @inline(__always)
    public func serialize() -> String {
        return "[\(map { $0.serialize() }.joined(separator: ","))]"
    }
}

extension Dictionary: Serializable where Key: Serializable, Value: Serializable {
    @inlinable
    @inline(__always)
    public func serialize() -> String {
        """
        {\(map { "\($0.key.serialize()):\($0.value.serialize())" }
            .joined(separator: ",")
        )}
        """
    }
}

extension Optional: Serializable where Wrapped: Serializable {
    @inlinable
    @inline(__always)
    public func serialize() -> String {
        return switch self {
        case .none:
            "null"
        case let .some(wrapped):
            wrapped.serialize()
        }
    }
}

public protocol Serializable {
    @inlinable
    @inline(__always)
    func serialize() async -> String
}

public extension Serializable {
    @inlinable
    @inline(__always)
    func serialize() async -> String {
        "\(self)"
    }
}

extension Bool: Serializable {}
extension Int: Serializable {}
extension Int8: Serializable {}
extension Int16: Serializable {}
extension Int32: Serializable {}
extension Int64: Serializable {}
extension Int128: Serializable {}
extension UInt: Serializable {}
extension UInt8: Serializable {}
extension UInt16: Serializable {}
extension UInt32: Serializable {}
extension UInt64: Serializable {}
extension UInt128: Serializable {}
extension Float: Serializable {}
extension Double: Serializable {}

public protocol Countable {
    @inlinable
    @inline(__always)
    var count: Int { get }
}

extension Array: Countable {}
extension Dictionary: Countable {}

extension String: Serializable {
    @inlinable
    @inline(__always)
    public func serialize() async -> String {
        return "\"\(Parse.escape(string: self))\""
    }
}

extension Array: Serializable where Element: Serializable {
    @inlinable
    @inline(__always)
    public func serialize() async -> String {
        let result = await __asyncMap { await $0.serialize() }

        return "[\(result.joined(separator: ","))]"
    }
}

extension Dictionary: Serializable where Key: Serializable, Value: Serializable {
    @inlinable
    @inline(__always)
    public func serialize() async -> String {
        let result = await __asyncMap { "\(await $0.key.serialize()):\(await $0.value.serialize())" }

        return "{\(result.joined(separator: ","))}"
    }
}

extension Optional: Serializable where Wrapped: Serializable {
    @inlinable
    @inline(__always)
    public func serialize() async -> String {
        return switch self {
        case .none:
            "null"
        case let .some(wrapped):
            await wrapped.serialize()
        }
    }
}

internal extension Sequence where Self: Countable {
    @inlinable
    @inline(__always)
    func __asyncMap<T>(_ transform: (Element) async -> T) async -> [T] {
        var result: [T] = .init()
        result.reserveCapacity(self.count)

        for el in self {
            result.append(await transform(el))
        }

        return result
    }
}

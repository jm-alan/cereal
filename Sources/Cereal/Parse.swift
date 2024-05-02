import Foundation

public let doubleQuoteByte = "\"".utf8.first!
public let backslashByte = "\\".utf8.first!
public let newlineByte = "\n".utf8.first!

public let escapedDoubleQuoteBytes = "\\\"".utf8
public let escapedBackslashBytes = "\\\\".utf8
public let escapedNewlineBytes = "\\n".utf8

@usableFromInline
let unicodeEscapes = stride(from: 0, through: 31, by: 1).map { "\\u00\(String($0, radix: 16))".utf8 }

public enum Parse {
    @inlinable
    @inline(__always)
    public static func escape(string: String) -> String {
        var byteContainer: [UInt8] = []

        for byte in string.utf8 {
            switch byte {
            case doubleQuoteByte:
                byteContainer.append(contentsOf: escapedDoubleQuoteBytes)
            case backslashByte:
                byteContainer.append(contentsOf: escapedBackslashBytes)
            case newlineByte:
                byteContainer.append(contentsOf: escapedNewlineBytes)
            default:
                byteContainer.append(byte)
            }
        }

        return .init(bytes: byteContainer, encoding: .utf8)!
    }
}

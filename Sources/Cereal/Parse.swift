public enum Parse {
    @inlinable
    @inline(__always)
    public static func escape(string: String) -> String {
        string.unicodeScalars.map {
            return switch $0 {
            case "\"":
                "\\\""
            case "\\":
                "\\\\"
            case "\n":
                "\\n"
            case let scalar where scalar.value >= 0 && scalar.value <= 31:
                "\\u00\(String(scalar.value, radix: 16))"
            case let scalar:
                "\(scalar)"
            }
        }.joined(separator: "")
    }
}

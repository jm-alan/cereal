import SwiftSyntax
import SwiftSyntaxMacros

let commaBytes = ",".utf8
let doubleQuoteBytes = "\"".utf8
let tripleDoubleQuoteBytes = "\"\"\"".utf8
let colonBytes = ":".utf8
let selfBytes = "self".utf8
let dotBytes = ".".utf8
let backslashBytes = "\\".utf8
let openParenBytes = "(".utf8
let closeParenBytes = ")".utf8
let invokeParenBytes = "()".utf8
let openBraceBytes = "{".utf8
let closeBraceBytes = "}".utf8
let serializeBytes = "serialize".utf8
let parseDotEscapeBytes = "Parse.escape".utf8


let inlineSerializable = ["Bool", "Int", "Float", "Double", "String"]

public enum Lex {
    static func parseAs(enum declaration: EnumDeclSyntax) throws -> [ExtensionDeclSyntax] {
        return []
    }

    static func parseAs(struct declaration: StructDeclSyntax) throws -> [ExtensionDeclSyntax] {
        try createExtension(
            from: declaration.memberBlock,
            for: declaration.name.trimmedDescription
        )
    }

    static func parseAs(class declaration: ClassDeclSyntax) throws -> [ExtensionDeclSyntax] {
        try createExtension(
            from: declaration.memberBlock,
            for: declaration.name.trimmedDescription
        )
    }

    static func createExtension(
        from memberBlock: MemberBlockSyntax,
        for name: String
    ) throws -> [ExtensionDeclSyntax] {
        let processedTypes = try memberBlock
            .members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .compactMap { memb -> (IdentifierPatternSyntax, TypeSyntax)? in
                guard
                    let patternBinding = memb.bindings.first?.as(PatternBindingSyntax.self),
                    let identPattern = patternBinding.pattern.as(IdentifierPatternSyntax.self)
                else { return nil }

                return (identPattern, patternBinding.typeAnnotation!.type)
            }
            .map { (tup: (IdentifierPatternSyntax, TypeSyntax)) -> (String, String, Bool) in
                let (pattern, type) = tup

                if let optionalType = type.as(OptionalTypeSyntax.self) {
                    return (
                        pattern.identifier.text,
                        optionalType.wrappedType.trimmedDescription,
                        true
                    )
                } else if let regularType = type.as(IdentifierTypeSyntax.self) {
                    return (
                        pattern.identifier.text,
                        regularType.trimmedDescription,
                        false
                    )
                } else if let arrayType = type.as(ArrayTypeSyntax.self) {
                    return (
                        pattern.identifier.text,
                        arrayType.trimmedDescription,
                        false
                    )
                } else if let dictType = type.as(DictionaryTypeSyntax.self) {
                    return (
                        pattern.identifier.text,
                        dictType.trimmedDescription,
                        false
                    )
                } else {
                    throw CerealError.unserializable(
                        "Unable to serialze type \(type.trimmedDescription)"
                    )
                }
            }

        var funcBody = processedTypes
            .map { tup in
                let (varName, typeName, isOptional) = tup

                guard !isOptional && inlineSerializable.contains(typeName) else {
                    return "\"\(varName)\":\\(self.\(varName).serialize())"
                }

                return switch typeName {
                case "Bool", "Int", "Float", "Double":
                    "\"\(varName)\":\\(self.\(varName))"
                case "String":
                    "\"\(varName)\":\"\\(Parse.escape(string: self.\(varName)))\""
                default:
                    fatalError("We should never get here")

                }
            }
            .joined(separator: ",")

        funcBody = "{\(funcBody)}"

        return try [ExtensionDeclSyntax("""
        extension \(raw: name): Serializable {
            @inlinable
            @inline(__always)
            public func serialize() -> String {
                \"""
                \(raw: funcBody)
                \"""
            }
        }
        """)]
    }
}

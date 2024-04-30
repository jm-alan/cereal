import SwiftSyntax
import SwiftSyntaxMacros

public enum Lex {
    static func parseAs(enum declaration: EnumDeclSyntax) throws -> [ExtensionDeclSyntax] {
        return []
    }

    static func parseAs(struct declaration: StructDeclSyntax) throws -> [ExtensionDeclSyntax] {
        var funcBody = try declaration
            .memberBlock
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
                    throw CerealError.unserializable("Unable to serialze type \(type.trimmedDescription)")
                }
            }
            .map { tup in
                let (varName, typeName, isOptional) = tup

                guard !isOptional else {
                    return "\"\(varName)\":\\(self.\(varName).serialize())"
                }

                return switch typeName {
                case "Bool", "Int", "Float", "Double":
                    "\"\(varName)\":\\(self.\(varName))"
                case "String":
                    "\"\(varName)\":\"\\(Parse.escape(string: self.\(varName)))\""
                default:
                    "\"\(varName)\":\\(self.\(varName).serialize())"
                }
            }
            .joined(separator: ",")

        funcBody = "{\(funcBody)}"

        return try [ExtensionDeclSyntax("""
        extension \(raw: declaration.name.trimmedDescription): Serializable {
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

    static func parseAs(class declaration: ClassDeclSyntax) throws -> [ExtensionDeclSyntax] {
        return []
    }
}

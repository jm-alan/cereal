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


let inlineSerializable: Set = [
    "Bool",
    "Int",
    "Int8",
    "Int16",
    "Int32",
    "Int64",
    "Int128",
    "UInt",
    "UInt8",
    "UInt16",
    "UInt32",
    "UInt64",
    "UInt128",
    "Float",
    "Double"
]

public enum Lex {
    static func parseAs(enum declaration: EnumDeclSyntax) throws -> [ExtensionDeclSyntax] {
        return []
    }

    static func parseAs(struct declaration: StructDeclSyntax) throws -> [ExtensionDeclSyntax] {
        createExtension(
            from: declaration.memberBlock,
            for: declaration.name.trimmedDescription
        )
    }

    static func parseAs(class declaration: ClassDeclSyntax) throws -> [ExtensionDeclSyntax] {
        createExtension(
            from: declaration.memberBlock,
            for: declaration.name.trimmedDescription
        )
    }

    static func createExtension(
        from memberBlock: MemberBlockSyntax,
        for name: String
    ) -> [ExtensionDeclSyntax] {
        var isolateVars: [String] = []
        var asyncVars: [String] = []
        var asyncResult: [String] = []
        var syncResult: [String] = []

        memberBlock
            .members
            .forEach { memb in
                let vds = memb.decl.as(VariableDeclSyntax.self)

                if
                    let patternBinding = vds?.bindings.first,
                    let pattern = patternBinding.pattern.as(IdentifierPatternSyntax.self),
                    let type = patternBinding.typeAnnotation?.type
                {
                    let varName = pattern.identifier.text
                    var typeName = type.trimmedDescription
                    var isOptional = false

                    if let optionalType = type.as(OptionalTypeSyntax.self) {
                        typeName = optionalType.wrappedType.trimmedDescription
                        isOptional = true
                    }

                    guard !isOptional && inlineSerializable.contains(typeName) else {
                        print("Parsing type:", typeName)

                        let isolateVarName = "\(varName)Isolate"
                        let asyncVarName = "\(varName)Serial"

                        isolateVars.append("let \(isolateVarName) = self.\(varName)")
                        asyncVars.append("async let \(asyncVarName) = \(isolateVarName).serialize()")
                        asyncResult.append("\"\(varName)\":\\(await \(asyncVarName))")
                        syncResult.append("//\"\(varName)\":\\(await self.\(varName).serialize())")
                        return
                    }

                    var inlineRepresentation = ""

                    switch typeName {
                    case "Bool", "Int", "Int8", "Int16", "Int32", "Int64", "Int128", "UInt", "UInt8", "UInt16", "UInt32", "UInt64", "UInt128", "Float", "Double":
                        inlineRepresentation = "\"\(varName)\":\\(self.\(varName))"
                    default:
                        fatalError(
                            "Unable to serialze type \(typeName)"
                        )
                    }

                    asyncResult.append(inlineRepresentation)
                    syncResult.append(inlineRepresentation)
                }

            }

        let isolateDecls = isolateVars.joined(separator: "\n")
        let asyncDecls = asyncVars.joined(separator: "\n")
        let asyncBody = asyncResult.joined(separator: ",")
        let syncBody = syncResult.joined(separator: ",")

        return try! [ExtensionDeclSyntax("""
        extension \(raw: name): Serializable {
            @inlinable
            @inline(__always)
            public func serialize() async -> String {
                //if runAsync {
                    \(raw: isolateDecls)
                    \(raw: asyncDecls)
                    return \"""
                    {\(raw: asyncBody)}
                    \"""
                //} else {
                    //return \"""
                    //{\(raw: syncBody)}
                    //\"""
                //}
            }
        }
        """)]
    }
}

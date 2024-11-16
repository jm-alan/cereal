import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct CerealMacro: ExtensionMacro {
    public static func expansion(
        of _: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf _: some TypeSyntaxProtocol,
        conformingTo _: [TypeSyntax],
        in _: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        if let castDecl = declaration.as(EnumDeclSyntax.self) {
            return try Lex.parseAs(enum: castDecl)
        } else if let castDecl = declaration.as(StructDeclSyntax.self) {
            return try Lex.parseAs(struct: castDecl)
        } else if let castDecl = declaration.as(ClassDeclSyntax.self) {
            return try Lex.parseAs(class: castDecl)
        } else {
            throw CerealError.unserializable("Invalid @Cereal annotation")
        }
    }
}

enum CerealError: Error {
    case unserializable(String)
    case noArgs
    case nonStaticString
}

@main
struct CerealPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CerealMacro.self,
    ]
}

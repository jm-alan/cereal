import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")
public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "(\(argument), \(literal: argument.description))"
    }
}

public struct CerealMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
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
}

@main
struct CerealPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        CerealMacro.self
    ]
}

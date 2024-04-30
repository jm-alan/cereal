import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(CerealMacros)
import CerealMacros

let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self,
    "Cereal": CerealMacro.self,
]
#endif

final class CerealTests: XCTestCase {
    func testCereal() {
        assertMacroExpansion(
            """
            @Cereal
            struct Nested {
                var key: Int = 7
            }
            @Cereal
            struct SerializeMe {
                var boolVar: Bool = false
                var intVar: Int = 0
                var floatVar: Float = 0.0
                var doubleVar: Double = 0.0
                var stringVar: String = "hello"

                var optionalIntVar: Int? = nil

                var runtimeBool: Bool { false }
                var runtimeInt: Int { 0 }
                var runtimeFloat: Float { 0.0 }
                var runtimeDouble: Double { 0.0 }
                var runtimeString: String { "hello" }

                var optionalRuntimeFloat: Float? = nil

                var nestedStruct: Nested = .init()

                var array: [Int] = []
            }
            """,
            expandedSource: """
            struct Nested {
                var key: Int = 7

                @inlinable
                @inline(__always)
                public func serialize() -> String {
                    \"""
                    {"key":\\(self.key)}
                    \"""
                }
            }
            struct SerializeMe {
                var boolVar: Bool = false
                var intVar: Int = 0
                var floatVar: Float = 0.0
                var doubleVar: Double = 0.0
                var stringVar: String = "hello"

                var optionalIntVar: Int? = nil

                var runtimeBool: Bool { false }
                var runtimeInt: Int { 0 }
                var runtimeFloat: Float { 0.0 }
                var runtimeDouble: Double { 0.0 }
                var runtimeString: String { "hello" }

                var optionalRuntimeFloat: Float? = nil

                var nestedStruct: Nested = .init()

                @inlinable
                @inline(__always)
                public func serialize() -> String {
                    \"""
                    {\
            "boolVar":\\(self.boolVar),\
            "intVar":\\(self.intVar),\
            "floatVar":\\(self.floatVar),\
            "doubleVar":\\(self.doubleVar),\
            "stringVar":"\\(Lex.escape(string: self.stringVar))",\
            "optionalIntVar":\\(self.optionalIntVar.serialize()),\
            "runtimeBool":\\(self.runtimeBool),\
            "runtimeInt":\\(self.runtimeInt),\
            "runtimeFloat":\\(self.runtimeFloat),\
            "runtimeDouble":\\(self.runtimeDouble),\
            "runtimeString":"\\(Lex.escape(string: self.runtimeString))",\
            "optionalRuntimeFloat":\\(self.optionalRuntimeFloat.serialize()),\
            "nestedStruct":\\(self.nestedStruct.serialize())\
            }
                    \"""
                }
            }
            """,
            macros: testMacros
        )
    }
}

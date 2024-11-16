import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(CerealMacros)
import CerealMacros

let testMacros: [String: Macro.Type] = [
    "Cereal": CerealMacro.self,
]
#endif

final class CerealTests: XCTestCase {
    func testCereal() {
        assertMacroExpansion(
            """
            @Cereal
            struct WhoCares {
                var key: Int = 7
            }
            """,
            expandedSource: """
            struct WhoCares {
                var key: Int = 7
            }

            extension WhoCares: Serializable {
                @inlinable
                @inline(__always)
                public func serialize() -> String {
                    \"""
                    {"key":\\(self.key)}
                    \"""
                }
            }
            """,
            macros: testMacros
        )
    }
}

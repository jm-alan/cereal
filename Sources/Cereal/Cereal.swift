@attached(extension, names: named(serialize), conformances: Serializable)
public macro Cereal() = #externalMacro(module: "CerealMacros", type: "CerealMacro")

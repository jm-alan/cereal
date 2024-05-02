import Cereal
import Foundation

let a = 17
let b = 25

@Cereal
struct TryMe {
    var someVar: Int = 0
}
let tried = TryMe()

let encoder = JSONEncoder()

let info = KgInfo()

let runs = 10_000_000

var codableResult = try! String(data: encoder.encode(info), encoding: .utf8)!
var cerealResult = info.serialize()

//let codableStart = Date().timeIntervalSince1970
//for _ in 0..<runs {
//    codableResult = try! String(data: encoder.encode(info), encoding: .utf8)
//}
//let codableEnd = Date().timeIntervalSince1970
//let codableTime = codableEnd - codableStart
//
//let cerealStart = Date().timeIntervalSince1970
//for _ in 0..<runs {
//    cerealResult = info.serialize()
//}
//let cerealEnd = Date().timeIntervalSince1970
//let cerealTime = cerealEnd - cerealStart
//
//let codableIPS = Double(runs) / codableTime
//let cerealIPS = Double(runs) / cerealTime
//
//func roundReadable(_ dub: Double) -> Double {
//    Double(round(dub * 10_000)) / 10_000
//}

//print("Codable took \(codableTime)s or ~\(roundReadable(codableIPS)) iterations per second")
//print("Cereal took \(cerealTime)s or ~\(roundReadable(cerealIPS)) iterations per second")
//print("Cereal performed at ~\(Double(round((cerealIPS / codableIPS) * 10_000)) / 100.0)% of Codable")

let isolatedEscapeTest = String(cerealResult)

let escapeEncoder = JSONEncoder()
let codableEscapeStart = Date().timeIntervalSince1970
for idx in 0..<runs {
    codableResult = try! String(data: escapeEncoder.encode(isolatedEscapeTest), encoding: .utf8)!
}
let codableEscapeEnd = Date().timeIntervalSince1970
let codableEscapeTime = codableEscapeEnd - codableEscapeStart

let cerealEscapeStart = Date().timeIntervalSince1970
for idx in 0..<runs {
    cerealResult = Parse.escape(string: isolatedEscapeTest)
}
let cerealEscapeEnd = Date().timeIntervalSince1970
let cerealEscapeTime = cerealEscapeEnd - cerealEscapeStart

let codableEscapeIPS = Double(runs) / codableEscapeTime
let cerealEscapeIPS = Double(runs) / cerealEscapeTime

print("Codable took \(codableEscapeTime) | ~\(codableEscapeIPS) iterations per second | ~\(.init(codableResult.utf8.count) * codableEscapeIPS / 1_000_000.0) MB/s")
print("Cereal took \(cerealEscapeTime) | ~\(cerealEscapeIPS) iterations per second | ~\(.init(cerealResult.utf8.count) * cerealEscapeIPS / 1_000_000.0) MB/s")

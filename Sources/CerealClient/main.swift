import Cereal
import ExtrasJSON
import Foundation

let a = 17
let b = 25

@Cereal
struct TryMe {
    var someVar: Int = 0
}

let tried = TryMe()

let codableEncoder = JSONEncoder()
let xtraEncoder = XJSONEncoder()

let info = KgInfo()

let runs = 10_000_000

var codableResult = try! String(data: codableEncoder.encode(info), encoding: .utf8)!
var xtraResult = try! String(bytes: xtraEncoder.encode(info), encoding: .utf8)!
var cerealResult = info.serialize()

let codableStart = Date().timeIntervalSince1970
for _ in 0 ..< runs {
    codableResult = try! String(data: codableEncoder.encode(info), encoding: .utf8)!
}

let codableEnd = Date().timeIntervalSince1970
let codableTime = codableEnd - codableStart

let xtraStart = Date().timeIntervalSince1970
for _ in 0 ..< runs {
    xtraResult = try! String(bytes: xtraEncoder.encode(info), encoding: .utf8)!
}

let xtraEnd = Date().timeIntervalSince1970
let xtraTime = xtraEnd - xtraStart

let cerealStart = Date().timeIntervalSince1970
for _ in 0 ..< runs {
    cerealResult = info.serialize()
}

let cerealEnd = Date().timeIntervalSince1970
let cerealTime = cerealEnd - cerealStart

let runsAsDouble: Double = .init(runs)

let codableIPS = runsAsDouble / codableTime
let xtraIPS = runsAsDouble / xtraTime
let cerealIPS = runsAsDouble / cerealTime

func roundReadable(_ dub: Double) -> Double {
    Double(round(dub * 10000)) / 10000
}

print("Codable took \(codableTime)s | ~\(roundReadable(codableIPS)) iterations per second | ~\(.init(codableResult.utf8.count) * codableIPS / 1_000_000.0) MB/s")
print("Xtra took \(xtraTime)s | ~\(roundReadable(xtraIPS)) iterations per second | ~\(.init(xtraResult.utf8.count) * xtraIPS / 1_000_000.0) MB/s")
print("Cereal took \(cerealTime)s | ~\(roundReadable(cerealIPS)) iterations per second | ~\(.init(cerealResult.utf8.count) * cerealIPS / 1_000_000.0) MB/s")
print("Cereal performed at ~\(Double(round((cerealIPS / codableIPS) * 10000)) / 100.0)% of Codable")
print("Xtra performed at ~\(Double(round((xtraIPS / codableIPS) * 10000)) / 100.0)% of Codable")
print("Cereal performed at ~\(Double(round((cerealIPS / xtraIPS) * 10000)) / 100.0)% of Xtra")

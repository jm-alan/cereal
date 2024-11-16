import Cereal
import ExtrasJSON
import Foundation

func roundReadable(_ dub: Double) -> Double {
    Double(round(dub * 10000)) / 10000
}

func asPercent(_ numerator: Double, _ denominator: Double) -> Double {
    (numerator / denominator) * 100
}

func readablePercent(_ numerator: Double, _ denominator: Double) -> Double {
    roundReadable(asPercent(numerator, denominator))
}

func printSummary(_ name: String, _ seconds: Double, _ ips: Double, _ mbs: Double) {
    print("""
    \(name):
        Duration: \(roundReadable(seconds))s
        Loop frequency: ~\(roundReadable(ips))Hz
        Throughput: ~\(roundReadable(mbs))MB/s
    """)
}

func printCompSummary(
    _ leftName: String,
    _ rightName: String,
    _ leftTime: Double,
    _ rightTime: Double,
    _ leftIPS: Double,
    _ rightIPS: Double,
    _ leftMBS: Double,
    _ rightMBS: Double
) {
    print("""
    \(leftName) / \(rightName):
        \(leftName) took \(readablePercent(leftTime, rightTime))% of the time \(rightName) took
        \(leftName) iterated at ~\(readablePercent(leftIPS, rightIPS))% the speed of \(rightName)
        \(leftName) achieved ~\(readablePercent(leftMBS, rightMBS))% of \(rightName)'s throughput
    """)
}

let codableEncoder = JSONEncoder()
let xtraEncoder = XJSONEncoder()

let info = KgInfo()

let runs = 50_000
let runsAsDouble: Double = .init(runs)

var codableResult = try! String(data: codableEncoder.encode(info), encoding: .utf8)!
var xtraResult = try! String(bytes: xtraEncoder.encode(info), encoding: .utf8)!
var cerealResult = await info.serialize()

let codableStart = Date().timeIntervalSince1970
for _ in 0 ..< runs {
    _ = try! String(data: codableEncoder.encode(info), encoding: .utf8)!
}

let codableEnd = Date().timeIntervalSince1970
let codableTime = codableEnd - codableStart
let codableIPS = runsAsDouble / codableTime
let codableMBS = .init(codableResult.utf8.count) * codableIPS / 1_000_000.0

printSummary("Foundation", codableTime, codableIPS, codableMBS)

// ------------------------------------------------------------------------------------------------

let xtraStart = Date().timeIntervalSince1970
for _ in 0 ..< runs {
    _ = try! String(bytes: xtraEncoder.encode(info), encoding: .utf8)!
}

let xtraEnd = Date().timeIntervalSince1970
let xtraTime = xtraEnd - xtraStart
let xtraIPS = runsAsDouble / xtraTime
let xtraMBS = .init(xtraResult.utf8.count) * xtraIPS / 1_000_000.0

printSummary("ExtrasJSON", xtraTime, xtraIPS, xtraMBS)

// ------------------------------------------------------------------------------------------------

let cerealStart = Date().timeIntervalSince1970
for _ in 0 ..< runs {
    _ = await info.serialize()
}

let cerealEnd = Date().timeIntervalSince1970
let cerealTime = cerealEnd - cerealStart
let cerealIPS = runsAsDouble / cerealTime
let cerealMBS = .init(cerealResult.utf8.count) * cerealIPS / 1_000_000.0

printSummary("Jolly", cerealTime, cerealIPS, cerealMBS)

let totalTime = cerealEnd - codableStart

printCompSummary("ExtrasJSON", "Foundation", xtraTime, codableTime, xtraIPS, codableIPS, xtraMBS, codableMBS)
printCompSummary("Jolly", "ExtrasJSON", cerealTime, xtraTime, cerealIPS, xtraIPS, cerealMBS, xtraMBS)
printCompSummary("Jolly", "Foundation", cerealTime, codableTime, cerealIPS, codableIPS, cerealMBS, codableMBS)

print("Total run took \(totalTime)s")

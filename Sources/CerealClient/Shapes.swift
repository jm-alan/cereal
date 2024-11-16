import Cereal

@Cereal
struct HealthStatus: Codable {
    var age: Int = 1234567
    var alcohol: Int = 1234567
    var alcoholAbuse: Bool = false
    var alcoholFrequency: Int = 1234567
    var allergies: Int = 1234567
    var bmi: Int = 1234567
    var caffeine: Int = 1234567
    var caffeineFrequency: Int = 1234567
    var date: Int = 1234567
    var exercise: Int = 1234567
    var exerciseDuration: Int = 1234567
    var exerciseFrequency: Int = 1234567
    var exerciseIntensity: Int = 1234567
    var exerciseType: Int = 1234567
    var height: Int = 1234567
    var herbalRemedies: Int = 1234567
    var intercourseFrequency: Int = 1234567
    var intercourseLubricants: Int = 1234567
    var nicotineProducts: Int = 1234567
    var painWithIntercourse: Int = 1234567
    var recentSexualPartners: Int = 1234567
    var recreationalDrugs: Bool = false
    var sexualAbuse: Int = 1234567
    var smokingCurrently: Bool = false
    var smokingPreviously: Int = 1234567
    var specialDiet: Int = 1234567
    var thyroidMedication: Int = 1234567
    var travelledZikaVirus: Int = 1234567
    var weight: Int = 1234567
}

@Cereal
struct HormoneMeasurement: Codable {
    var amhLevel: Int = 1234567
    var date: String = "2023-10-17T00:00:00.000Z"
    var e2Level: Int = 1234567
    var fshLevel: Int = 1234567
    var lhLevel: Int = 1234567
    var progesteroneLevel: Int = 1234567
    var prolactinLevel: Int = 1234567
    var t4Level: Int = 1234567
    var tshLevel: Int = 1234567
    var vitaminDLevel: Int = 1234567
}

@Cereal
struct Mammography: Codable {
    var normal: Bool = false
}

@Cereal
struct PapSmear: Codable {
    var normal: Bool = false
}

@Cereal
struct FemaleFertilityAnalyses: Codable {
    var birthControlBeforeStimulation: Int = 1234567
    var carrierGeneticTesting: Int = 1234567
    var contraceptiveSideEffects: Int = 1234567
    var contraceptiveUsed: Int = 1234567
    var date: Int = 1234567
    var healthStatus: HealthStatus = .init()

    var hormoneMeasurement: HormoneMeasurement = .init()

    var mammography: [Mammography] = [.init(), .init(), .init(), .init(), .init(), .init(), .init()]
    var menstrualCycle: Int = 1234567
    var mockEmbryoTransferOutcome: Int = 1234567
    var monthsTryingToConceive: Int = 1234567
    var motherMenopauseAge: Int = 1234567

    var papSmear: PapSmear = .init()

    var pregnancies: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var previousArtCycles: Int = 1234567
    var previousAttemptToConceiveWithDifferentPartner: Int = 1234567
    var previousBirths: Int = 1234567
    var previousEctopic: Int = 1234567
    var previousMiscarriages: Int = 1234567
    var previousPregnancies: Int = 1234567
    var sonohysterogramOutcome: Int = 1234567
}

@Cereal
struct MaleHealthStatus: Codable {
    var acupuntureCurrently: Int = 1234567
    var acupunturePreviously: Int = 1234567
    var age: Int = 1234567
    var alcohol: Int = 1234567
    var alcoholAbuse: Int = 1234567
    var alcoholFrequency: Int = 1234567
    var allergies: Int = 1234567
    var bmi: Int = 1234567
    var caffeine: Int = 1234567
    var caffeineFrequency: Int = 1234567
    var date: Int = 1234567
    var exercise: Int = 1234567
    var exerciseDuration: Int = 1234567
    var exerciseFrequency: Int = 1234567
    var exerciseIntensity: Int = 1234567
    var exerciseType: Int = 1234567
    var height: Int = 1234567
    var herbalRemedies: Int = 1234567
    var intercourseFrequency: Int = 1234567
    var intercourseLubricants: Int = 1234567
    var nicotineProducts: Int = 1234567
    var painWithIntercourse: Int = 1234567
    var recentSexualPartners: Int = 1234567
    var recreationalDrugs: Int = 1234567
    var sexualAbuse: Int = 1234567
    var smokingCurrently: Int = 1234567
    var smokingPreviously: Int = 1234567
    var specialDiet: Int = 1234567
    var thyroidMedication: Int = 1234567
    var travelledZikaVirus: Int = 1234567
    var weight: Int = 1234567
}

@Cereal
struct SpermCount: Codable {
    var concentrationTypeAB: Int = 1234567
    var concentrationTypeABC: Int = 1234567
    var motionless: Int = 1234567
    var normalMorphology: Int = 1234567
    var total: Int = 1234567
    var vitability: Int = 1234567
    var volume: Int = 1234567
}

@Cereal
struct SpermAnalysis: Codable {
    var agglutination: Int = 1234567
    var bacteria: Int = 1234567
    var cells: Int = 1234567
    var color: Int = 1234567
    var date: Int = 1234567
    var phLevel: Int = 1234567

    var spermCount: [SpermCount] = [.init(), .init(), .init(), .init(), .init(), .init(), .init()]

    var testicle: Int = 1234567
    var translucency: Int = 1234567
    var viscosity: Int = 1234567
}

@Cereal
struct MaleFertilityAnalyses: Codable {
    var carrierGeneticTesting: Int = 1234567
    var date: Int = 1234567

    var healthStatus: MaleHealthStatus = .init()

    var previousPaternity: Int = 1234567

    var spermAnalysis: SpermAnalysis = .init()
}

@Cereal
struct LastCouple: Codable {
    var diseases: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var familyHistoryDiseases: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var hypersensitivities: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var infertilityCauses: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]

    var maleFertilityAnalyses: [MaleFertilityAnalyses] = [.init(), .init(), .init(), .init(), .init(), .init(), .init()]
    var surgeries: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
}

@Cereal
struct KgInfo: Codable {
    var birthYear: Int = 1234567
    var dietarySupplements: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var diseases: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var familyHistoryCancers: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var familyHistoryDiseases: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var femaleFertilityAnalyses: [FemaleFertilityAnalyses] = [.init(), .init(), .init(), .init(), .init(), .init(), .init()]

    var varhypersensitivities: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var infertilityCauses: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var lastCouple: LastCouple = .init()
    var prescriptions: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var sex: Int = 1234567
    var sexuallyTransmittedDiseases: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var surgeries: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
    var therapeuticVitamins: [Int] = [1234567,1234567, 1234567, 1234567, 1234567, 1234567, 1234567]
}

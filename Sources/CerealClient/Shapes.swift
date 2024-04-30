import Cereal

@Cereal
struct HealthStatus: Codable {
    var age: Int? = nil
    var alcohol: Int? = nil
    var alcoholAbuse: Bool = false
    var alcoholFrequency: Int? = nil
    var allergies: Int? = nil
    var bmi: Int? = nil
    var caffeine: Int? = nil
    var caffeineFrequency: Int? = nil
    var date: Int? = nil
    var exercise: Int? = nil
    var exerciseDuration: Int? = nil
    var exerciseFrequency: Int? = nil
    var exerciseIntensity: Int? = nil
    var exerciseType: Int? = nil
    var height: Int? = nil
    var herbalRemedies: Int? = nil
    var intercourseFrequency: Int? = nil
    var intercourseLubricants: Int? = nil
    var nicotineProducts: Int? = nil
    var painWithIntercourse: Int? = nil
    var recentSexualPartners: Int? = nil
    var recreationalDrugs: Bool = false
    var sexualAbuse: Int? = nil
    var smokingCurrently: Bool = false
    var smokingPreviously: Int? = nil
    var specialDiet: Int? = nil
    var thyroidMedication: Int? = nil
    var travelledZikaVirus: Int? = nil
    var weight: Int? = nil
}

@Cereal
struct HormoneMeasurement: Codable {
    var amhLevel: Int? = nil
    var date: String = "2023-10-17T00:00:00.000Z"
    var e2Level: Int? = nil
    var fshLevel: Int? = nil
    var lhLevel: Int? = nil
    var progesteroneLevel: Int? = nil
    var prolactinLevel: Int? = nil
    var t4Level: Int? = nil
    var tshLevel: Int? = nil
    var vitaminDLevel: Int? = nil
}

@Cereal
struct Mammography: Codable {
    var normal: Bool? = nil
}

@Cereal
struct PapSmear: Codable {
    var normal: Bool? = nil
}

@Cereal
struct FemaleFertilityAnalyses: Codable {
    var birthControlBeforeStimulation: Int? = nil
    var carrierGeneticTesting: Int? = nil
    var contraceptiveSideEffects: Int? = nil
    var contraceptiveUsed: Int? = nil
    var date: Int? = nil
    var healthStatus: HealthStatus = .init()

    var hormoneMeasurement: HormoneMeasurement = .init()

    var mammography: [Mammography] = [.init()]
    var menstrualCycle: Int? = nil
    var mockEmbryoTransferOutcome: Int? = nil
    var monthsTryingToConceive: Int? = nil
    var motherMenopauseAge: Int? = nil

    var papSmear: PapSmear = .init()

    var pregnancies: [Int] = []
    var previousArtCycles: Int? = nil
    var previousAttemptToConceiveWithDifferentPartner: Int? = nil
    var previousBirths: Int? = nil
    var previousEctopic: Int? = nil
    var previousMiscarriages: Int? = nil
    var previousPregnancies: Int? = nil
    var sonohysterogramOutcome: Int? = nil
}

@Cereal
struct MaleHealthStatus: Codable {
    var acupuntureCurrently: Int? = nil
    var acupunturePreviously: Int? = nil
    var age: Int? = nil
    var alcohol: Int? = nil
    var alcoholAbuse: Int? = nil
    var alcoholFrequency: Int? = nil
    var allergies: Int? = nil
    var bmi: Int? = nil
    var caffeine: Int? = nil
    var caffeineFrequency: Int? = nil
    var date: Int? = nil
    var exercise: Int? = nil
    var exerciseDuration: Int? = nil
    var exerciseFrequency: Int? = nil
    var exerciseIntensity: Int? = nil
    var exerciseType: Int? = nil
    var height: Int? = nil
    var herbalRemedies: Int? = nil
    var intercourseFrequency: Int? = nil
    var intercourseLubricants: Int? = nil
    var nicotineProducts: Int? = nil
    var painWithIntercourse: Int? = nil
    var recentSexualPartners: Int? = nil
    var recreationalDrugs: Int? = nil
    var sexualAbuse: Int? = nil
    var smokingCurrently: Int? = nil
    var smokingPreviously: Int? = nil
    var specialDiet: Int? = nil
    var thyroidMedication: Int? = nil
    var travelledZikaVirus: Int? = nil
    var weight: Int? = nil
}

@Cereal
struct SpermCount: Codable {
    var concentrationTypeAB: Int? = nil
    var concentrationTypeABC: Int? = nil
    var motionless: Int? = nil
    var normalMorphology: Int? = nil
    var total: Int? = nil
    var vitability: Int? = nil
    var volume: Int? = nil
}

@Cereal
struct SpermAnalysis: Codable {
    var agglutination: Int? = nil
    var bacteria: Int? = nil
    var cells: Int? = nil
    var color: Int? = nil
    var date: Int? = nil
    var phLevel: Int? = nil

    var spermCount: [SpermCount] = [.init()]

    var testicle: Int? = nil
    var translucency: Int? = nil
    var viscosity: Int? = nil
}

@Cereal
struct MaleFertilityAnalyses: Codable {
    var carrierGeneticTesting: Int? = nil
    var date: Int? = nil

    var healthStatus: MaleHealthStatus = .init()

    var previousPaternity: Int? = nil

    var spermAnalysis: SpermAnalysis = .init()
}

@Cereal
struct LastCouple: Codable {
    var diseases: [Int] = []
    var familyHistoryDiseases: [Int] = []
    var hypersensitivities: [Int] = []
    var infertilityCauses: [Int] = []

    var maleFertilityAnalyses: [MaleFertilityAnalyses] = [.init()]
    var surgeries: [Int] = []
}

@Cereal
struct KgInfo: Codable {
    var birthYear: Int = 1995
    var dietarySupplements: [Int] = []
    var diseases: [Int] = []
    var familyHistoryCancers: [Int] = []
    var familyHistoryDiseases: [Int] = []
    var femaleFertilityAnalyses: [FemaleFertilityAnalyses] = [.init(), .init()]

    var varhypersensitivities: [Int] = []
    var infertilityCauses: [Int] = []
    var lastCouple: LastCouple = .init()
    var prescriptions: [Int] = []
    var sex: Int? = nil
    var sexuallyTransmittedDiseases: [Int] = []
    var surgeries: [Int] = []
    var therapeuticVitamins: [Int] = []
}

import ArgumentParser
import BCFoundation
import WolfBase

struct GenerateSeedCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "seed",
        abstract: "Generate a seed."
    )

    @Option(help: "The number of bytes for the seed. Must be in the range \(minSeedSize)...256.")
    var count: Int = 16
    
    @Option(help: "Raw hex data for the seed.")
    var hex: HexData?

    func validate() throws {
        let range = minSeedSize...256
        if let hex {
            guard range.contains(hex.data.count) else {
                throw EnvelopeToolError.sizeOutOfRange(range, count)
            }
        } else {
            guard range.contains(count) else {
                throw EnvelopeToolError.sizeOutOfRange(range, count)
            }
        }
    }
    
    mutating func run() throws {
        resetOutput()
        let seed: Seed
        if let hex {
            seed = Seed(data: hex)!
        } else {
            seed = Seed(count: count)
        }
        printOut(seed.ur)
    }
}

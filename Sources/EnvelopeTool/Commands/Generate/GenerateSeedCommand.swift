import ArgumentParser
import BCFoundation

struct GenerateSeedCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "seed", abstract: "Generate a seed.")

    @Argument(help: "The number of bytes for the seed. Must be in the range \(minSeedSize)...256.")
    var count: Int = 16
    
    func validate() throws {
        let range = minSeedSize...256
        guard range.contains(count) else {
            throw EnvelopeToolError.sizeOutOfRange(range, count)
        }
    }
    
    mutating func run() throws {
        resetOutput()
        printOut(Seed(count: count).ur)
    }
}

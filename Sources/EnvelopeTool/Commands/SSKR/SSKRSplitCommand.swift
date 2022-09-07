import ArgumentParser
import BCFoundation
import WolfBase

struct SSKRSplitCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "split", abstract: "Split an envelope into several shares using SSKR.")

    @Argument
    var envelope: Envelope?
    
    @Option(name: .customShort("t"), help: "The number of groups that must meet their threshold.")
    var groupThreshold: Int = 1
    
    @Option(name: .customShort("g"), help: "The group specification.")
    var group: [String] = ["1-of-1"]

    mutating func fill() throws {
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
    }
    
    mutating func run() throws {
        resetOutput()
        try fill()
        
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        
        guard groupThreshold <= group.count else {
            throw EnvelopeToolError.invalidGroupThreshold(groupThreshold)
        }

        let regex = try ~/#"(\d{1,2})-of-(\d{1,2})"#
        let groups: [(Int, Int)] = try group.map {
            guard
                let matches = regex.matchedSubstrings(in: $0),
                matches.count == 2,
                let m = Int(matches[0]),
                let n = Int(matches[1])
            else {
                throw EnvelopeToolError.invalidGroupSpecifier($0)
            }
            return (m, n)
        }
        
        let contentKey = SymmetricKey()
        let wrapped = envelope.wrap()
        let encrypted = try wrapped.encryptSubject(with: contentKey)
        let groupedShares = encrypted.split(groupThreshold: groupThreshold, groups: groups, contentKey: contentKey)
        let flattenedShares = groupedShares.map {
            $0.map({ $0.ur.string }).joined(separator: "\n")
        }.joined(separator: "\n\n")
        printOut(flattenedShares)
    }
}

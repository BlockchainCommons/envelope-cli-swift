import ArgumentParser
import Foundation
import BCFoundation

struct GenerateDigestCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "digest",
        abstract: "Generate a digest from the input data.",
        discussion: "If the `data` argument is given on the command line, it is taken as a UTF-8 string. If it is omitted on the command line, then all available data is read from stdin and treated as a binary blob."
    )
    
    @Argument var data: Data?
    
    mutating func fill() throws {
        if data == nil {
            data = try readInData()
        }
    }
    
    mutating func run() throws {
        setupCommand()
        try fill()
        guard let data else {
            throw EnvelopeToolError.missingArgument("data")
        }
        printOut(Digest(data).ur)
    }
}

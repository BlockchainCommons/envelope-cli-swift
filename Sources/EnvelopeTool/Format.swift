import ArgumentParser
import BCFoundation

struct Format: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Print the envelope in Envelope Notation.")

    @Argument(help: "The envelope to format.")
    var envelope: Envelope
    
    func run() throws {
        resetOutput()
        printOut(envelope.format)
    }
}

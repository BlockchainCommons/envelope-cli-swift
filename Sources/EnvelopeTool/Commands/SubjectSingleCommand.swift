import ArgumentParser
import BCFoundation

struct SubjectSingleCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "single", abstract: "Create an envelope with the given subject.")

    @OptionGroup
    var arguments: SubjectArguments
    
    mutating func run() throws {
        resetOutput()
        printOut(try arguments.envelope.ur)
    }
}

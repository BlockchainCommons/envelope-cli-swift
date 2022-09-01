import ArgumentParser
import BCFoundation

struct SubjectAssertionCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "assertion", abstract: "Create an envelope with the given assertion (predicate and object).")

    @OptionGroup
    var arguments: AssertionArguments
    
    mutating func run() throws {
        resetOutput()
        printOut(try arguments.assertion.ur)
    }
}

import ArgumentParser
import BCFoundation

struct AssertionCreateCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "create", abstract: "Create a bare assertion with the given predicate and object.")

    @OptionGroup
    var arguments: AssertionArguments
    
    @Flag(help: "Add salt to the assertion.")
    var salted: Bool = false

    mutating func fill() throws {
        try arguments.fill()
    }

    mutating func run() throws {
        resetOutput()
        try fill()
        var result = try arguments.assertion
        if salted {
            result = result.addSalt()
        }
        printOut(result.ur)
    }
}

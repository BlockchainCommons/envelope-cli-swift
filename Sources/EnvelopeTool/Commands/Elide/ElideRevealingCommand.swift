import ArgumentParser
import BCFoundation

struct ElideRevealingCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "revealing",
        abstract: "Elide all objects not in the target."
    )

    init() { }
    
    @OptionGroup
    var arguments: ElideArguments

    mutating func run() throws {
        try arguments.run(revealing: true)
    }
}

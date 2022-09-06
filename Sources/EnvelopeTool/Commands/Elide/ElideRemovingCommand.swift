import ArgumentParser
import BCFoundation

struct ElideRemovingCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "removing",
        abstract: "Elide all objects in the target."
    )

    init() { }
    
    @OptionGroup
    var arguments: ElideArguments

    mutating func run() throws {
        try arguments.run(revealing: false)
    }
}

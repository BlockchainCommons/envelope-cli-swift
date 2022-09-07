import Foundation
@testable import EnvelopeTool

func setUpTest() {
    EnvelopeTool.outputToStdout = false
    EnvelopeTool.readFromStdin = false
}

func envelope(_ arguments: [String], inputLines: [String] = []) throws -> String {
    EnvelopeTool.setInputLines(inputLines)
    var t = try Main.parseAsRoot(arguments)
    try t.run()
    return EnvelopeTool.outputText
}

func envelope(_ argument: String, inputLines: [String]) throws -> String {
    return try envelope(argument.split(separator: " ").map { String($0) }, inputLines: inputLines)
}

func envelope(_ argument: String, inputLine: String? = nil) throws -> String {
    let inputLines: [String]
    if let inputLine {
        inputLines = [inputLine]
    } else {
        inputLines = []
    }
    return try envelope(argument.split(separator: " ").map { String($0) }, inputLines: inputLines)
}

func pipe(_ arguments: [String], inputLine: String? = nil) throws -> String {
    var inputLine = inputLine
    for argument in arguments {
        inputLine = try envelope(argument, inputLine: inputLine)
    }
    return inputLine ?? ""
}

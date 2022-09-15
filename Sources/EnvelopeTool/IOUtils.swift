import Foundation
import ArgumentParser
import WolfBase

#if DEBUG

private var _outputText = ""
private var _inputLines: [String] = []

var outputText: String { _outputText.trim() }
var outputToStdout: Bool = true
var readFromStdin: Bool = true

func resetOutput() {
    _outputText = ""
}

func setInputLines(_ inputLines: [String]) {
    _inputLines = inputLines
}

func printOut(
    _ items: Any..., separator: String = " ", terminator: String = "\n"
) {
    print(items, separator: separator, terminator: terminator, to: &_outputText)
    if outputToStdout {
        print(items, separator: separator, terminator: terminator)
    }
}

func readIn() -> String? {
    if readFromStdin {
        return readLine()
    } else if _inputLines.isEmpty {
        return nil
    } else {
        return _inputLines.removeFirst()
    }
}

func readInData() throws -> Data? {
    if readFromStdin {
        return try FileHandle.standardInput.readToEnd()
    } else {
        defer { _inputLines.removeAll() }
        return _inputLines.joined(separator: "\n").utf8Data
    }
}

#else

func resetOutput() { }

func printOut(
    _ items: Any..., separator: String = " ", terminator: String = "\n"
) {
    print(items, separator: separator, terminator: terminator)
}

func readIn() -> String? {
    readLine()
}

func readInData() throws -> Data? {
    try FileHandle.standardInput.readToEnd()
}

#endif

func readIn<T>(_ type: T.Type) throws -> T? where T: ExpressibleByArgument {
    guard let inputLine = readIn() else {
        return nil
    }
    guard let result = T.init(argument: inputLine) else {
        throw EnvelopeToolError.invalidType(expectedType: T.self†)
    }
    return result
}

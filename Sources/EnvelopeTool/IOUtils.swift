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

func readIn() throws -> String {
    let result: String?
    if readFromStdin {
        result = readLine()
    } else {
        if _inputLines.isEmpty {
            result = nil
        } else {
            result = _inputLines.removeFirst()
        }
    }
    guard let result else {
        throw EnvelopeToolError.unexpectedEOF
    }
    return result
}

#else

func resetOutput() { }

func printOut(
    _ items: Any..., separator: String = " ", terminator: String = "\n"
) {
    print(items, separator: separator, terminator: terminator)
}

func readIn() throws -> String {
    guard let result = readLine() else {
        throw EnvelopeToolError.unexpectedEOF
    }
    return result
}

#endif

func readIn<T>(_ type: T.Type) throws -> T where T: ExpressibleByArgument {
    let inputLine = try readIn()
    guard let result = T.init(argument: inputLine) else {
        throw EnvelopeToolError.invalidType(expectedType: T.self†)
    }
    return result
}

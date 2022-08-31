import Foundation
import ArgumentParser

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
    } else {
        if _inputLines.isEmpty {
            return nil
        } else {
            return _inputLines.removeFirst()
        }
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

#endif

func readIn<T>(_ type: T.Type) -> T? where T: ExpressibleByArgument {
    guard let t = readIn() else {
        return nil
    }
    return T.init(argument: t)
}

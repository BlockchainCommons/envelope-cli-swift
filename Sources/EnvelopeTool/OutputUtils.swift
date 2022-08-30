import Foundation

#if DEBUG

private var _outputText = ""
var outputText: String { _outputText.trim() }
var outputToStdout: Bool = true

func resetOutput() {
    _outputText = ""
}

func printOut(
    _ items: Any..., separator: String = " ", terminator: String = "\n"
) {
    print(items, separator: separator, terminator: terminator, to: &_outputText)
    if outputToStdout {
        print(items, separator: separator, terminator: terminator)
    }
}

#else

func printOut(
    _ items: Any..., separator: String = " ", terminator: String = "\n"
) {
    print(items, separator: separator, terminator: terminator)
}

#endif

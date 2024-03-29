import Foundation
import ArgumentParser
import BCFoundation

extension ARID: ExpressibleByArgument {
    public init?(argument: String) {
        try? self.init(urString: argument)
    }
}

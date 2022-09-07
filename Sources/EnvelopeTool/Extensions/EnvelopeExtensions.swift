import Foundation
import ArgumentParser
import BCFoundation

extension Envelope: ExpressibleByArgument {
    public init?(argument: String) {
        try? self.init(urString: argument)
    }
}

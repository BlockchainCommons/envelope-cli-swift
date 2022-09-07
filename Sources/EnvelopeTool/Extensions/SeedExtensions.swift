import Foundation
import ArgumentParser
import BCFoundation

extension Seed: ExpressibleByArgument {
    public init?(argument: String) {
        try? self.init(urString: argument)
    }
}

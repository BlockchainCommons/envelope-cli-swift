import Foundation
import ArgumentParser
import BCFoundation

extension UR: ExpressibleByArgument {
    public init?(argument: String) {
        try? self.init(urString: argument)
    }
}

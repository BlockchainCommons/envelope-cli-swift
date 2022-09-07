import Foundation
import ArgumentParser
import BCFoundation

extension SymmetricKey: ExpressibleByArgument {
    public init?(argument: String) {
        try? self.init(urString: argument)
    }
}

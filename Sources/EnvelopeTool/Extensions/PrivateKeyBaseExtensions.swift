import Foundation
import ArgumentParser
import BCFoundation

extension PrivateKeyBase: ExpressibleByArgument {
    public init?(argument: String) {
        try? self.init(urString: argument)
    }
}

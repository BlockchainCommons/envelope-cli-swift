import Foundation
import ArgumentParser
import BCFoundation

extension PublicKeyBase: ExpressibleByArgument {
    public init?(argument: String) {
        try? self.init(urString: argument)
    }
}

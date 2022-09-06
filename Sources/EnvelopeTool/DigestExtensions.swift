import Foundation
import ArgumentParser
import BCFoundation

extension Digest: ExpressibleByArgument {
    public init?(argument: String) {
        try? self.init(urString: argument)
    }
}

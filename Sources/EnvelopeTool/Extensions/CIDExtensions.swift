import Foundation
import ArgumentParser
import BCFoundation

extension CID: ExpressibleByArgument {
    public init?(argument: String) {
        try? self.init(urString: argument)
    }
}

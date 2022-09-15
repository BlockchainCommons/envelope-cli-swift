import Foundation
import ArgumentParser
import WolfBase

extension Data: ExpressibleByArgument {
    public init?(argument: String) {
        self = argument.utf8Data
    }
}

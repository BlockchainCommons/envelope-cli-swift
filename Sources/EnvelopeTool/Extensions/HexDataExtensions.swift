import Foundation
import WolfBase
import ArgumentParser

extension HexData: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(hex: argument)
    }
}

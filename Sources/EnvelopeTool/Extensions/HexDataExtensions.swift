import Foundation
import WolfBase
import ArgumentParser

extension HexData: ExpressibleByArgument {
    public init?(argument: String) {
        let arg: String
        if argument.hasPrefix("0x") {
            arg = String(argument.dropFirst(2))
        } else {
            arg = argument
        }
        self.init(hex: arg)
    }
}

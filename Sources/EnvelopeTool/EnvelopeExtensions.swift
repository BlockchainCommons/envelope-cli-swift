import Foundation
import ArgumentParser
import BCFoundation

extension Envelope: ExpressibleByArgument {
    public init?(argument: String) {
        guard let ur = try? UR(urString: argument) else {
            return nil
        }
        try? self.init(ur: ur)
    }
}

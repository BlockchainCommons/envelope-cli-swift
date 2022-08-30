import Foundation
import ArgumentParser

enum DataType: EnumerableFlag {
    case cbor
    case cid
    case data
    case date
    case int
    case string
    case uuid
}

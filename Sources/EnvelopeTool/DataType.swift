import Foundation
import ArgumentParser

enum DataType: EnumerableFlag {
    case cbor
    case cid
    case data
    case date
    case digest
    case envelope
    case int
    case string
    case ur
    case uuid
}

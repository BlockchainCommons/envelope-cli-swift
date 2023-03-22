import Foundation
import ArgumentParser

enum DataType: EnumerableFlag {
    case assertion
    case cbor
    case cid
    case data
    case date
    case digest
    case envelope
    case number
    case known
    case object
    case predicate
    case string
    case ur
    case uri
    case uuid
    case wrapped
}

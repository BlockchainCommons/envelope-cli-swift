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
    case int
    case knownPredicate
    case object
    case predicate
    case string
    case ur
    case uuid
    case wrapped
}

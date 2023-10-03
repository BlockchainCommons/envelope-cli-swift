import Foundation
import ArgumentParser

enum DataType: EnumerableFlag {
    case assertion
    case predicate
    case object

    case arid
    case bool
    case cbor
    case data
    case date
    case digest
    case envelope
    case known
    case number
    case string
    case ur
    case uri
    case uuid
    case wrapped
}

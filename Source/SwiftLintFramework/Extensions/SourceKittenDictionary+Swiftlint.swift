import Foundation
import SourceKittenFramework

extension SourceKittenDictionary {
    /// Returns array of tuples containing "key.kind" and "byteRange" from Structure
    /// that contains the byte offset. Returns all kinds if no parameter specified.
    ///
    /// - parameter byteOffset: Int?
    ///
    /// - returns: The kinds and byte ranges.
    internal func kinds(forByteOffset byteOffset: ByteCount? = nil)
        -> [(kind: String, byteRange: ByteRange)] {
        var results = [(kind: String, byteRange: ByteRange)]()

        func parse(_ dictionary: SourceKittenDictionary) {
            guard let offset = dictionary.offset,
                let byteRange = dictionary.length.map({ NSRange(location: offset, length: $0) }) else {
                    return
            }
            if let byteOffset = byteOffset, !NSLocationInRange(byteOffset, byteRange) {
                return
            }
            if let kind = dictionary.kind {
                results.append((kind: kind, byteRange: byteRange))
            }
            dictionary.substructure.forEach(parse)
        }
        parse(self)
        return results
    }

    internal func structures(forByteOffset byteOffset: ByteCount) -> [SourceKittenDictionary] {
        var results = [SourceKittenDictionary]()

        func parse(_ dictionary: SourceKittenDictionary) {
            guard let offset = dictionary.offset,
                let byteRange = dictionary.length.map({ NSRange(location: offset, length: $0) }),
                NSLocationInRange(byteOffset, byteRange) else {
                    return
            }

            results.append(dictionary)
            dictionary.substructure.forEach(parse)
        }
        parse(self)
        return results
    }
}

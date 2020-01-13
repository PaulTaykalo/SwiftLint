import Foundation
import SourceKittenFramework

extension ByteRange {
    func intersects(_ range: ByteRange) -> Bool {
        return self.intersectionRange(with: range).length > 0
    }

    func intersects(_ ranges: [ByteRange]) -> Bool {
        for range in ranges where intersects(range) {
            return true
        }
        return false
    }
}

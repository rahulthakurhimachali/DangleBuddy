//
//  Comparable+Clamped.swift
//  DangleBuddy
//

extension Comparable {
    /// Returns the value constrained to `range`.
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

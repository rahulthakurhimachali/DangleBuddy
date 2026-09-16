//
//  BuiltInCharms.swift
//  DangleBuddy
//
//  The shipped charm set.
//

/// Every built-in charm, in menu order: the DangleBuddy collection.
///
/// Drawn from SVG assets resolved through `SVGArtworkSource`. A free-standing lookup
/// rather than a method on a service, so previews, scripts and tests can resolve a
/// charm without building the whole object graph.
enum BuiltInCharms {
    /// What the rope shows when a selection can no longer be resolved.
    static let fallbackKind = CharmKind.daruma

    static var fallback: any Charm { charm(for: fallbackKind) }

    static let all: [any Charm] = CollectionCharmCatalog.charms(
        source: SVGArtworkSource.resolveDefault()
    )

    /// Falls back to Daruma, so an unknown kind can never leave the rope bare.
    static func charm(for kind: CharmKind) -> any Charm {
        all.first { $0.id == .builtIn(kind) } ?? fallback
    }

    /// Collection charms whose SVG asset could not be found.
    static var missingArtwork: [CharmKind] {
        all.compactMap { charm in
            guard let svg = charm as? SVGCharm, svg.vector == nil else { return nil }
            return svg.kind
        }
    }
}

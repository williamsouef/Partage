/// Un montant exact, stocké en centimes pour éviter les erreurs d'arrondi des `Double`.
public struct Money: Hashable, Codable, Sendable {
    public var cents: Int

    public init(cents: Int) {
        self.cents = cents
    }
}

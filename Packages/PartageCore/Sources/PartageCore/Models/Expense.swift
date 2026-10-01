import Foundation

public struct Expense: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public var title: String
    public var amount: Money
    public var paidBy: Participant.ID
    public var split: Split

    public init(id: UUID = UUID(), title: String, amount: Money, paidBy: Participant.ID, split: Split) {
        self.id = id
        self.title = title
        self.amount = amount
        self.paidBy = paidBy
        self.split = split
    }
}

/// Comment une dépense est répartie. Chaque cas porte ses propres données,
/// ce qui rend les états incohérents impossibles à représenter.
public enum Split: Hashable, Codable, Sendable {
    /// Parts égales entre ces participants.
    case equal(among: Set<Participant.ID>)
    /// Montant précis pour chaque participant.
    case custom([Participant.ID: Money])
}

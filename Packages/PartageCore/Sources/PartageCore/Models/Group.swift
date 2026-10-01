import Foundation

public struct Group: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public var name: String
    public var participants: [Participant]
    public var expenses: [Expense]

    public init(id: UUID = UUID(), name: String, participants: [Participant] = [], expenses: [Expense] = []) {
        self.id = id
        self.name = name
        self.participants = participants
        self.expenses = expenses
    }
}

import Foundation
import Testing
@testable import PartageCore

@Test func expenseRoundTripsThroughJSON() throws {
    let lea = Participant(name: "Léa")
    let tom = Participant(name: "Tom")
    let expense = Expense(
        title: "Courses",
        amount: Money(cents: 4_250),
        paidBy: lea.id,
        split: .equal(among: [lea.id, tom.id])
    )

    let data = try JSONEncoder().encode(expense)
    let decoded = try JSONDecoder().decode(Expense.self, from: data)

    #expect(decoded == expense)
}

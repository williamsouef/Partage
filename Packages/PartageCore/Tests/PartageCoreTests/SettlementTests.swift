import Testing
@testable import PartageCore

struct SettlementTests {
    let lea = Participant(name: "Léa")
    let max = Participant(name: "Max")
    let tom = Participant(name: "Tom")
    let sam = Participant(name: "Sam")

    /// Léa +40, Max +10, Tom −30, Sam −20 — l'exemple déroulé à la main.
    @Test func fourPeopleNeedThreeTransfers() {
        let group = Group(name: "Voyage", participants: [lea, max, tom, sam], expenses: [
            Expense(title: "Location", amount: Money(cents: 4_000), paidBy: lea.id,
                    split: .custom([tom.id: Money(cents: 3_000), sam.id: Money(cents: 1_000)])),
            Expense(title: "Essence", amount: Money(cents: 1_000), paidBy: max.id,
                    split: .custom([sam.id: Money(cents: 1_000)])),
        ])

        let transfers = group.settlement()

        #expect(transfers.count == 3)
        #expect(transfers.contains(Transfer(from: tom.id, to: lea.id, amount: Money(cents: 3_000))))
    }

    @Test func transfersCancelEveryBalance() {
        let group = Group(name: "Coloc", participants: [lea, tom, sam], expenses: [
            Expense(title: "Courses", amount: Money(cents: 100), paidBy: lea.id,
                    split: .equal(among: [lea.id, tom.id, sam.id])),
            Expense(title: "Pizza", amount: Money(cents: 2_550), paidBy: tom.id,
                    split: .equal(among: [lea.id, tom.id, sam.id])),
        ])

        var remaining = group.balances().mapValues(\.cents)
        for transfer in group.settlement() {
            remaining[transfer.from, default: 0] += transfer.amount.cents
            remaining[transfer.to, default: 0] -= transfer.amount.cents
        }

        #expect(remaining.values.allSatisfy { $0 == 0 })
    }

    @Test func nothingToSettleWhenEmpty() {
        #expect(Group(name: "Vide").settlement().isEmpty)
    }
}

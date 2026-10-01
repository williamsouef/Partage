import Testing
@testable import PartageCore

struct BalancesTests {
    let lea = Participant(name: "Léa")
    let tom = Participant(name: "Tom")
    let sam = Participant(name: "Sam")

    @Test func equalSplitBetweenThree() {
        let group = Group(name: "Coloc", participants: [lea, tom, sam], expenses: [
            Expense(title: "Courses", amount: Money(cents: 3_000), paidBy: lea.id,
                    split: .equal(among: [lea.id, tom.id, sam.id])),
        ])

        let balances = group.balances()

        #expect(balances[lea.id] == Money(cents: 2_000))
        #expect(balances[tom.id] == Money(cents: -1_000))
        #expect(balances[sam.id] == Money(cents: -1_000))
    }

    @Test func leftoverCentIsNotLost() {
        let group = Group(name: "Coloc", participants: [lea, tom, sam], expenses: [
            Expense(title: "Café", amount: Money(cents: 100), paidBy: lea.id,
                    split: .equal(among: [lea.id, tom.id, sam.id])),
        ])

        let total = group.balances().values.reduce(0) { $0 + $1.cents }

        #expect(total == 0)
    }

    @Test func customSplit() {
        let group = Group(name: "Resto", participants: [lea, tom], expenses: [
            Expense(title: "Dîner", amount: Money(cents: 5_000), paidBy: tom.id,
                    split: .custom([lea.id: Money(cents: 3_500), tom.id: Money(cents: 1_500)])),
        ])

        let balances = group.balances()

        #expect(balances[lea.id] == Money(cents: -3_500))
        #expect(balances[tom.id] == Money(cents: 3_500))
    }
}

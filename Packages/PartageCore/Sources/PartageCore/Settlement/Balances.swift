extension Group {
    /// Solde de chaque participant : ce qu'il a payé moins ce qu'il doit.
    /// Positif → on lui doit de l'argent. Négatif → il doit de l'argent.
    public func balances() -> [Participant.ID: Money] {
        var result: [Participant.ID: Int] = [:]

        for expense in expenses {
            result[expense.paidBy, default: 0] += expense.amount.cents

            switch expense.split {
            case .equal(let among):
                guard !among.isEmpty else { continue }
                let share = expense.amount.cents / among.count
                var remainder = expense.amount.cents % among.count
                // Ordre stable pour que le centime restant tombe toujours sur les mêmes personnes.
                for id in among.sorted(by: { $0.uuidString < $1.uuidString }) {
                    let extra = remainder > 0 ? 1 : 0
                    remainder -= extra
                    result[id, default: 0] -= share + extra
                }

            case .custom(let amounts):
                for (id, money) in amounts {
                    result[id, default: 0] -= money.cents
                }
            }
        }

        return result.mapValues { Money(cents: $0) }
    }
}

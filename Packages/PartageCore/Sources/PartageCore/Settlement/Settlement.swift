/// Un remboursement à effectuer : `from` doit payer `amount` à `to`.
public struct Transfer: Hashable, Codable, Sendable {
    public let from: Participant.ID
    public let to: Participant.ID
    public let amount: Money
}

extension Group {
    /// Transforme les soldes en remboursements, avec un algorithme glouton :
    /// le plus gros débiteur rembourse le plus gros créditeur, jusqu'à ce que tout soit à 0.
    public func settlement() -> [Transfer] {
        let balances = balances()

        // 1. Séparer créditeurs (solde > 0) et débiteurs (solde < 0), en montants positifs.
        var creditors = balances.filter { $0.value.cents > 0 }.map { (id: $0.key, cents: $0.value.cents) }
        var debtors = balances.filter { $0.value.cents < 0 }.map { (id: $0.key, cents: -$0.value.cents) }

        var transfers: [Transfer] = []

        while !creditors.isEmpty && !debtors.isEmpty {
            // 2. Prendre le plus gros de chaque côté.
            creditors.sort { $0.cents > $1.cents }
            debtors.sort { $0.cents > $1.cents }

            // 3. Le débiteur paie le plus petit des deux montants.
            let amount = min(creditors[0].cents, debtors[0].cents)
            transfers.append(Transfer(from: debtors[0].id, to: creditors[0].id, amount: Money(cents: amount)))

            // 4. Retirer le montant, et sortir ceux qui tombent à 0.
            creditors[0].cents -= amount
            debtors[0].cents -= amount
            if creditors[0].cents == 0 { creditors.removeFirst() }
            if debtors[0].cents == 0 { debtors.removeFirst() }
        }

        return transfers
    }
}

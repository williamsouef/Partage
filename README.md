# Partage

An open-source iOS app to split shared expenses — trips, flatshares, dinners — and settle up with as few transfers as possible.

> 🚧 Work in progress. The core logic is done and tested; the SwiftUI app is next.

## Architecture

```
Partage/
├── Packages/PartageCore/   Pure Swift domain logic, no UI, fully tested
│   ├── Models/             Money, Participant, Expense, Group
│   └── Settlement/         Balances + debt simplification
└── .github/workflows/      CI: runs the test suite on every push
```

Keeping the business logic in its own package means it can be tested in isolation and reused by the app, a widget or a watch extension.

## Design decisions

- **Money is stored in integer cents.** Floating-point types can't represent amounts like `0.1` exactly; integers can.
- **Splits are an enum with associated values** (`.equal(among:)` / `.custom([id: amount])`), so an inconsistent split can't even be expressed.
- **Expenses reference participants by ID**, keeping a single source of truth when someone is renamed.
- **No cent is lost.** When `1.00 €` is split three ways, the leftover cent goes to one participant (`0.34 + 0.33 + 0.33`), and the tests check that every balance sums to zero.

## Settling up

Each participant's balance is what they paid minus what they owe. A greedy algorithm then turns balances into transfers: the largest debtor pays the largest creditor the smaller of the two amounts, and the process repeats until everyone is at zero.

This produces at most *n − 1* transfers. Finding the true minimum is NP-hard, so the greedy approach is a deliberate trade-off.

## Running the tests

```bash
cd Packages/PartageCore
swift test
```

## Roadmap

- [x] Domain models
- [x] Balances with cent-accurate rounding
- [x] Debt simplification
- [ ] SwiftUI app with SwiftData persistence
- [ ] Accessibility and French/English localization
- [ ] Receipt scanning with Vision
- [ ] Sharing between users with CloudKit

## License

MIT

import Foundation
import CryptoKit

final class Transaction {

    // MARK: - Properties

    let transactionID: String
    let setOfOperations: [Operation]
    let nonce: Int

    // MARK: - Initializer

    private init(operations: [Operation], nonce: Int) {
        self.setOfOperations = operations
        self.nonce = nonce
        self.transactionID = Transaction.calculateHash(
            operations: operations,
            nonce: nonce
        )
    }

    // MARK: - Factory method

    static func createTransaction(
        operations: [Operation],
        nonce: Int
    ) -> Transaction? {

        guard !operations.isEmpty else {
            print("Transaction must contain at least one operation")
            return nil
        }

        // Перевірка всіх операцій
        for op in operations {
            if !op.verifyOperation() {
                print("Invalid operation in transaction")
                return nil
            }
        }

        return Transaction(operations: operations, nonce: nonce)
    }

    // MARK: - Hashing

    private static func calculateHash(
        operations: [Operation],
        nonce: Int
    ) -> String {

        var data = ""

        for op in operations {
            data += op.toString()
        }

        data += "\(nonce)"

        let hash = SHA256.hash(
            data: data.data(using: .utf8)!
        )

        return hash.compactMap {
            String(format: "%02x", $0)
        }.joined()
    }

    // MARK: - Debug

    func toString() -> String {
        return "Transaction(id: \(transactionID), operations: \(setOfOperations.count), nonce: \(nonce))"
    }

    func printTransaction() {
        print(toString())
    }
}

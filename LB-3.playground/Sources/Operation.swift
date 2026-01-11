import Foundation
import CryptoKit

final class Operation {

    // MARK: - Properties

    let sender: Account
    let receiver: Account
    let amount: Int
    let signature: Data

    // MARK: - Initializer

    private init(
        sender: Account,
        receiver: Account,
        amount: Int,
        signature: Data
    ) {
        self.sender = sender
        self.receiver = receiver
        self.amount = amount
        self.signature = signature
    }

    // MARK: - Factory method

    static func createOperation(
        sender: Account,
        receiver: Account,
        amount: Int,
        keyIndex: Int
    ) -> Operation? {

        guard amount > 0 else {
            print("Invalid amount")
            return nil
        }

        guard sender.getBalance() >= amount else {
            print("Insufficient balance")
            return nil
        }

        let message = buildMessage(
            senderID: sender.accountID,
            receiverID: receiver.accountID,
            amount: amount
        )

        guard let signature = sender.signData(
            message: message,
            keyIndex: keyIndex
        ) else {
            return nil
        }

        return Operation(
            sender: sender,
            receiver: receiver,
            amount: amount,
            signature: signature
        )
    }

    // MARK: - Verification

    func verifyOperation() -> Bool {

        // Перевірка суми
        guard amount > 0 else { return false }

        // Перевірка балансу
        guard sender.getBalance() >= amount else { return false }

        let message = Operation.buildMessage(
            senderID: sender.accountID,
            receiverID: receiver.accountID,
            amount: amount
        )

        // Перевірка підпису (по всіх ключах гаманця)
        for keyPair in sender.wallet {
            let isValid = Signature.verifySignature(
                signature: signature,
                publicKey: keyPair.publicKey,
                message: message
            )
            if isValid {
                return true
            }
        }

        return false
    }

    // MARK: - Helpers

    private static func buildMessage(
        senderID: String,
        receiverID: String,
        amount: Int
    ) -> Data {
        return "\(senderID)->\(receiverID):\(amount)"
            .data(using: .utf8)!
    }

    // MARK: - Debug

    func toString() -> String {
        return "Operation(sender: \(sender.accountID), receiver: \(receiver.accountID), amount: \(amount))"
    }

    func printOperation() {
        print(toString())
    }
}

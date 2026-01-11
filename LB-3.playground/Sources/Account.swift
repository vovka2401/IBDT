import Foundation
import CryptoKit

final class Account {

    // MARK: - Properties

    let accountID: String
    private(set) var wallet: [KeyPair]
    private var balance: Int

    // MARK: - Initializer

    private init(wallet: [KeyPair], balance: Int) {
        self.wallet = wallet
        self.balance = balance

        // accountID = hash від публічного ключа першої пари
        let publicKeyData = wallet[0].publicKey.rawRepresentation
        let hash = SHA256.hash(data: publicKeyData)
        self.accountID = hash.compactMap {
            String(format: "%02x", $0)
        }.joined()
    }

    // MARK: - Factory method

    static func genAccount(initialBalance: Int = 0) -> Account {
        let keyPair = KeyPair.genKeyPair()
        return Account(wallet: [keyPair], balance: initialBalance)
    }

    // MARK: - Wallet methods

    func addKeyPairToWallet() {
        let newKeyPair = KeyPair.genKeyPair()
        wallet.append(newKeyPair)
    }

    // MARK: - Balance methods

    func updateBalance(amount: Int) {
        balance += amount
    }

    func getBalance() -> Int {
        return balance
    }

    func printBalance() {
        print("Balance of account \(accountID): \(balance)")
    }

    // MARK: - Signing

    func signData(message: Data, keyIndex: Int) -> Data? {
        guard wallet.indices.contains(keyIndex) else {
            print("Invalid key index")
            return nil
        }

        let keyPair = wallet[keyIndex]
        return Signature.signData(
            privateKey: keyPair.getPrivateKey(),
            message: message
        )
    }

    // MARK: - Payment operation (заглушка)

    func createPaymentOp(
        to recipient: Account,
        amount: Int,
        keyIndex: Int
    ) -> String? {

        guard amount > 0 else { return nil }
        guard balance >= amount else {
            print("Insufficient balance")
            return nil
        }

        let message = "\(accountID)->\(recipient.accountID):\(amount)"
            .data(using: .utf8)!

        guard let signature = signData(message: message, keyIndex: keyIndex) else {
            return nil
        }

        // Тимчасово повертаємо строку (далі буде Operation)
        return "PaymentOp(amount: \(amount), signature: \(signature.base64EncodedString()))"
    }

    // MARK: - Debug

    func printAccount() {
        print("AccountID: \(accountID)")
        print("Keys in wallet: \(wallet.count)")
        print("Balance: \(balance)")
    }
}

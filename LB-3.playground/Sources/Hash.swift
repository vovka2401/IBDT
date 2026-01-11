import Foundation
import CryptoKit

final class Hash {
    static func toSHA1(_ input: String) -> String {
        let data = input.data(using: .utf8)!
        let digest = Insecure.SHA1.hash(data: data)
        return digest.compactMap { String(format: "%02x", $0) }.joined()
    }

    static func toSHA256(_ input: String) -> String {
        let data = input.data(using: .utf8)!
        let digest = SHA256.hash(data: data)
        return digest.compactMap { String(format: "%02x", $0) }.joined()
    }
}
final class Block {

    let blockID: String
    let prevHash: String
    let setOfTransactions: [Transaction]

    private init(transactions: [Transaction], prevHash: String) {
        self.setOfTransactions = transactions
        self.prevHash = prevHash
        self.blockID = Block.calculateHash(transactions: transactions, prevHash: prevHash)
    }

    // Фабричний метод
    static func createBlock(transactions: [Transaction], prevHash: String) -> Block {
        return Block(transactions: transactions, prevHash: prevHash)
    }

    // Генерація ідентифікатора блоку
    private static func calculateHash(transactions: [Transaction], prevHash: String) -> String {
        var data = prevHash
        for tx in transactions {
            data += tx.transactionID
        }
        return Hash.toSHA256(data)
    }

    // Debug
    func toString() -> String {
        return "Block(ID: \(blockID), prevHash: \(prevHash), txCount: \(setOfTransactions.count))"
    }

    func printBlock() {
        print(toString())
    }
}

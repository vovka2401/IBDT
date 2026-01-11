import Foundation
import CryptoKit

final class KeyPair {

    // Приватний ключ (доступний тільки всередині класу)
    private let privateKey: P256.Signing.PrivateKey

    // Публічний ключ (може бути доступний зовні)
    let publicKey: P256.Signing.PublicKey

    // Приватний ініціалізатор
    private init(privateKey: P256.Signing.PrivateKey) {
        self.privateKey = privateKey
        self.publicKey = privateKey.publicKey
    }

    // Генерація ключової пари
    static func genKeyPair() -> KeyPair {
        let privateKey = P256.Signing.PrivateKey()
        return KeyPair(privateKey: privateKey)
    }

    // Метод доступу до приватного ключа (для Signature)
    func getPrivateKey() -> P256.Signing.PrivateKey {
        return privateKey
    }

    // Опціонально
    func printKeyPair() {
        print("Public key: \(publicKey.rawRepresentation.base64EncodedString())")
    }
}

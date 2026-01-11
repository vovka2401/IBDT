final class Signature {

    // Підпис даних
    static func signData(
        privateKey: P256.Signing.PrivateKey,
        message: Data
    ) -> Data {

        let signature = try! privateKey.signature(for: message)
        return signature.derRepresentation
    }

    // Перевірка підпису
    static func verifySignature(
        signature: Data,
        publicKey: P256.Signing.PublicKey,
        message: Data
    ) -> Bool {

        do {
            let ecdsaSignature = try P256.Signing.ECDSASignature(
                derRepresentation: signature
            )
            return publicKey.isValidSignature(ecdsaSignature, for: message)
        } catch {
            return false
        }
    }

    // Опціонально
    static func printSignature(_ signature: Data) {
        print("Signature: \(signature.base64EncodedString())")
    }
}

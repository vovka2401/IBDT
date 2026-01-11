import Foundation

struct VigenereCipher {

    private static let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    // MARK: - Encrypt

    static func encrypt(_ plaintext: String, key: String) -> String {
        return transform(text: plaintext, key: key, encrypting: true)
    }

    // MARK: - Decrypt

    static func decrypt(_ ciphertext: String, key: String) -> String {
        return transform(text: ciphertext, key: key, encrypting: false)
    }

    // MARK: - Shared logic

    private static func transform(text: String, key: String, encrypting: Bool) -> String {
        let keyIndices = key.uppercased().compactMap { alphabet.firstIndex(of: $0) }
        guard !keyIndices.isEmpty else { return text }

        var result = ""
        var keyIndex = 0

        for char in text {
            let isLowercase = char.isLowercase
            let upperChar = Character(char.uppercased())

            guard let textIndex = alphabet.firstIndex(of: upperChar) else {
                result.append(char)
                continue
            }

            let shift = keyIndices[keyIndex % keyIndices.count]
            let newIndex = encrypting
                ? (textIndex + shift) % alphabet.count
                : (textIndex - shift + alphabet.count) % alphabet.count

            let newChar = alphabet[newIndex]
            result.append(isLowercase ? Character(newChar.lowercased()) : newChar)

            keyIndex += 1
        }

        return result
    }
}

let plaintext = "Hello World"
let key = "KEY"

let encrypted = VigenereCipher.encrypt(plaintext, key: key)
print(encrypted) // Rijvs Uyvjn

let decrypted = VigenereCipher.decrypt(encrypted, key: key)
print(decrypted) // Hello World

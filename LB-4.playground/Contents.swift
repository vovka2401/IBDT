import Foundation

struct EndianConverter {

    // MARK: HEX -> Little Endian UInt
    static func hexToLittleEndian(_ hex: String) -> UInt {
        let bytes = hexToBytes(hex)
        var result: UInt = 0
        for (i, byte) in bytes.enumerated() {
            result += UInt(byte) << (i * 8)
        }
        return result
    }

    // MARK: HEX -> Big Endian UInt
    static func hexToBigEndian(_ hex: String) -> UInt {
        let bytes = hexToBytes(hex)
        var result: UInt = 0
        for byte in bytes {
            result = (result << 8) + UInt(byte)
        }
        return result
    }

    // MARK: Little Endian UInt -> HEX
    static func littleEndianToHex(_ value: UInt, byteCount: Int) -> String {
        var val = value
        var hex = ""
        for _ in 0..<byteCount {
            let byte = UInt8(val & 0xFF)
            hex += String(format: "%02X", byte)
            val >>= 8
        }
        return hex
    }

    // MARK: Big Endian UInt -> HEX
    static func bigEndianToHex(_ value: UInt, byteCount: Int) -> String {
        var val = value
        var bytes: [UInt8] = Array(repeating: 0, count: byteCount)
        for i in (0..<byteCount).reversed() {
            bytes[i] = UInt8(val & 0xFF)
            val >>= 8
        }
        return bytes.map { String(format: "%02X", $0) }.joined()
    }

    // MARK: HEX -> [UInt8] helper
    private static func hexToBytes(_ hex: String) -> [UInt8] {
        var bytes: [UInt8] = []
        var hexStr = hex
        if hexStr.count % 2 != 0 {
            hexStr = "0" + hexStr
        }
        var index = hexStr.startIndex
        while index < hexStr.endIndex {
            let nextIndex = hexStr.index(index, offsetBy: 2)
            let byteStr = String(hexStr[index..<nextIndex])
            bytes.append(UInt8(byteStr, radix: 16) ?? 0)
            index = nextIndex
        }
        return bytes
    }
}


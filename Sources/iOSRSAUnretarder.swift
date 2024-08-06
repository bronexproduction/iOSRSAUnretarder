//
//  iOSRSAUnretarder.swift
//
//  Created by Artur Danielewski on 06/08/2024.
//

import Foundation
import CommonCrypto

extension SecKey {
    
    public func toDER() -> Data? {
        
        // ASN.1 identifiers
        let bitStringIdentifier: UInt8 = 0x03
        let sequenceIdentifier: UInt8 = 0x30
        
        // ASN.1 AlgorithmIdentfier for RSA encryption: OID 1 2 840 113549 1 1 1 and NULL
        let algorithmIdentifierForRSAEncryption: [UInt8] = [0x30, 0x0d, 0x06,
                                                            0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00]
        
        guard let rsaPublicKeyData = try? self.toData() else {
            return nil
        }
        
        var derEncodedKeyBytes = [UInt8](rsaPublicKeyData)
        
        // Insert ASN.1 BIT STRING bytes at the beginning of the array
        derEncodedKeyBytes.insert(0x00, at: 0)
        derEncodedKeyBytes.insert(contentsOf: lengthField(of: derEncodedKeyBytes), at: 0)
        derEncodedKeyBytes.insert(bitStringIdentifier, at: 0)
        
        // Insert ASN.1 AlgorithmIdentifier bytes at the beginning of the array
        derEncodedKeyBytes.insert(contentsOf: algorithmIdentifierForRSAEncryption, at: 0)
        
        // Insert ASN.1 SEQUENCE bytes at the beginning of the array
        derEncodedKeyBytes.insert(contentsOf: lengthField(of: derEncodedKeyBytes), at: 0)
        derEncodedKeyBytes.insert(sequenceIdentifier, at: 0)
        
        return Data(derEncodedKeyBytes)
    }
    
    private func lengthField(of valueField: [UInt8]) -> [UInt8] {
        var length = valueField.count
        
        if length < 128 {
            return [ UInt8(length) ]
        }
        
        // Number of bytes needed to encode the length
        let lengthBytesCount = Int((log2(Double(length)) / 8) + 1)
        
        // First byte encodes the number of remaining bytes in this field
        let firstLengthFieldByte = UInt8(128 + lengthBytesCount)
        
        var lengthField: [UInt8] = []
        for _ in 0..<lengthBytesCount {
            // Take the last 8 bits of length
            let lengthByte = UInt8(length & 0xff)
            // Insert them at the beginning of the array
            lengthField.insert(lengthByte, at: 0)
            // Delete the last 8 bits of length
            length = length >> 8
        }
        
        // Insert firstLengthFieldByte at the beginning of the array
        lengthField.insert(firstLengthFieldByte, at: 0)
        
        return lengthField
    }
}

//
//  3DES_DESEncryption.swift
//  NFCTest
//
//  Created by Andy Qua on 07/06/2019.
//  Copyright © 2019 Andy Qua. All rights reserved.
//

import Foundation
import CommonCrypto


public func tripleDESEncrypt(key:[UInt8], message:[UInt8], iv:[UInt8]) -> [UInt8] {
    // Fix key data - if length is 16 then take the first 98 bytes and append them to the end to make 24 bytes
    var fixedKey = key
    if key.count == 16 {
        fixedKey += key[0..<8]
    }
    
    let dataLength = message.count
    
    let cryptLen = message.count + kCCBlockSize3DES
    var cryptData = Data(count: cryptLen)
    
    let keyLength              = size_t(kCCKeySize3DES)
    let operation: CCOperation = UInt32(kCCEncrypt)
    let algorithm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
    let options:   CCOptions   = UInt32(0)
    
    var numBytesEncrypted = 0
    
    let cryptStatus = fixedKey.withUnsafeBytes {keyBytes in
        message.withUnsafeBytes{ dataBytes in
            iv.withUnsafeBytes{ ivBytes in
                cryptData.withUnsafeMutableBytes{ cryptBytes in
                    CCCrypt(operation,
                            algorithm,
                            options,
                            keyBytes.baseAddress,
                            keyLength,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress,
                            dataLength,
                            cryptBytes.bindMemory(to: UInt8.self).baseAddress,
                            cryptLen,
                            &numBytesEncrypted)
                    
                }
            }
        }
    }

    if cryptStatus == kCCSuccess {
        cryptData.count = Int(numBytesEncrypted)
        
        return [UInt8](cryptData)
    } else {
        Log.debug("Error: \(cryptStatus)")
    }
    return []
}

public func tripleDESDecrypt(key:[UInt8], message:[UInt8], iv:[UInt8]) -> [UInt8] {
    var fixedKey = key
    if key.count == 16 {
        fixedKey += key[0..<8]
    }

    let data = Data(message)
    let dataLength = message.count
    
    let cryptLen = data.count + kCCBlockSize3DES
    var cryptData = Data(count: cryptLen)
    
    let keyLength              = size_t(kCCKeySize3DES)
    let operation: CCOperation = UInt32(kCCDecrypt)
    let algorithm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
    let options:   CCOptions   = UInt32(0)
    
    var numBytesEncrypted = 0
    
    let cryptStatus = fixedKey.withUnsafeBytes {keyBytes in
        message.withUnsafeBytes{ dataBytes in
            cryptData.withUnsafeMutableBytes{ cryptBytes in
                CCCrypt(operation,
                        algorithm,
                        options,
                        keyBytes.baseAddress,
                        keyLength,
                        iv,
                        dataBytes.baseAddress,
                        dataLength,
                        cryptBytes.bindMemory(to: UInt8.self).baseAddress,
                        cryptLen,
                        &numBytesEncrypted)

            }
        }
    }
    
    if cryptStatus == kCCSuccess {
        cryptData.count = Int(numBytesEncrypted)
        
        return [UInt8](cryptData)
    } else {
        Log.debug("Error: \(cryptStatus)")
    }
    return []
}


public func DESEncrypt(key:[UInt8], message:[UInt8], iv:[UInt8], options:UInt32 = 0) -> [UInt8] {
    
    let dataLength = message.count
    
    let cryptLen = message.count + kCCBlockSizeDES
    var cryptData = Data(count: cryptLen)
    
    let keyLength              = size_t(kCCKeySizeDES)
    let operation: CCOperation = UInt32(kCCEncrypt)
    let algorithm:  CCAlgorithm = UInt32(kCCAlgorithmDES)
    let options:   CCOptions   = options
    
    var numBytesEncrypted = 0
    
    let cryptStatus = key.withUnsafeBytes {keyBytes in
        message.withUnsafeBytes{ dataBytes in
            iv.withUnsafeBytes{ ivBytes in
                cryptData.withUnsafeMutableBytes{ cryptBytes in
                    CCCrypt(operation,
                            algorithm,
                            options,
                            keyBytes.baseAddress,
                            keyLength,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress,
                            dataLength,
                            cryptBytes.bindMemory(to: UInt8.self).baseAddress,
                            cryptLen,
                            &numBytesEncrypted)
                    
                }
            }
        }
    }
    
    if cryptStatus == kCCSuccess {
        cryptData.count = Int(numBytesEncrypted)
        
        return [UInt8](cryptData)
    } else {
        Log.debug("Error: \(cryptStatus)")
    }
    return []
}

public func DESDecrypt(key:[UInt8], message:[UInt8], iv:[UInt8], options:UInt32 = 0) -> [UInt8] {
    
    let dataLength = message.count
    
    let cryptLen = message.count + kCCBlockSizeDES
    var cryptData = Data(count: cryptLen)
    
    let keyLength              = size_t(kCCKeySizeDES)
    let operation: CCOperation = UInt32(kCCDecrypt)
    let algorithm:  CCAlgorithm = UInt32(kCCAlgorithmDES)
    let options:   CCOptions   = options
    
    var numBytesEncrypted = 0
    
    let cryptStatus = key.withUnsafeBytes {keyBytes in
        message.withUnsafeBytes{ dataBytes in
            iv.withUnsafeBytes{ ivBytes in
                cryptData.withUnsafeMutableBytes{ cryptBytes in
                    CCCrypt(operation,
                            algorithm,
                            options,
                            keyBytes.baseAddress,
                            keyLength,
                            nil,
                            dataBytes.baseAddress,
                            dataLength,
                            cryptBytes.bindMemory(to: UInt8.self).baseAddress,
                            cryptLen,
                            &numBytesEncrypted)
                    
                }
            }
        }
    }
    
    if cryptStatus == kCCSuccess {
        cryptData.count = Int(numBytesEncrypted)
        
        return [UInt8](cryptData)
    } else {
        Log.debug("Error: \(cryptStatus)")
    }
    return []
}

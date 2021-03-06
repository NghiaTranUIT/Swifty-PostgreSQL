
//
//  Decoder.swift
//  Swifty-PostgreSQL
//
//  Created by Nghia Tran on 1/20/17.
//  Copyright © 2017 Titan. All rights reserved.
//

import Foundation
import libpq

//
// MARK: - Decoder
/// It's default decoder
/// Parse raw data to Row
public struct Decoder {
    
    //
    // MARK: - Variable
    fileprivate let resultPtr: OpaquePointer!
    fileprivate let rowIndex: Int!
    fileprivate let column: ColumnTypeProtocol
    
    //
    // MARK: - Init
    public init(resultPtr: OpaquePointer, rowIndex: Int, column: ColumnTypeProtocol) {
        self.resultPtr = resultPtr
        self.column = column
        self.rowIndex = rowIndex
    }
}

//
// MARK: - Decodable
extension Decoder: Decodable {
    
    public func isNull() -> Bool {
        return PQgetisnull(self.resultPtr, Int32(self.rowIndex), Int32(self.column.colIndex)) == 1
    }
    
    public func getRawData() -> String {
        return String(cString: PQgetvalue(self.resultPtr, Int32(self.rowIndex), Int32(self.column.colIndex)))
    }
    
    public func decodeRawData(_ rawData: String, column: ColumnTypeProtocol) -> Any {
        var value: Any!
        
        switch column.colType {
        case .boolean:
            value = rawData == "t" ? true : false
        case .int16:
            value = Int16(rawData)
        case .int32:
            value = Int32(rawData)
        case .int64:
            value = Int64(rawData)
        case .singleFloat:
            value = Float(rawData)
        case .doubleFloat:
            value = Double(rawData)
        case .byte:
            value = Int8(rawData)
        case .json:
            
            guard let rawData = rawData.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
                Logger.error("Can't parse rawData JSON")
                fatalError("Can't parse rawData JSON")
                return value
            }
            guard let json = try? JSONSerialization.jsonObject(with: rawData,
                                                            options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
                Logger.error("Can't parse JSON")
                fatalError("Can't parse JSON")
                return value
            }
            value = json
        case .timestamp:
            return Date()
        case .date:
            return Date()
        case .time:
            return rawData
        case .char:
            return rawData
        case .varchar:
            return rawData
        case .unsupport:
            return rawData
        case .text:
            return rawData
        case .intArray:
            return rawData
        case .charArray:
            return rawData
        case .jsonArray:
            return rawData
        case .numeric:
            return rawData
        }
        return value
    }
}

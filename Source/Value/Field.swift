//
//  Field.swift
//  Swifty-PostgreSQL
//
//  Created by Nghia Tran on 1/21/17.
//  Copyright © 2017 Titan. All rights reserved.
//

import Foundation

//
// MARK: - Field
/// Represent data for field
open class Field: Presentable {
    
    //
    // MARK: - Variable
    
    /// Decoder
    fileprivate var decoder: Decodable!
    
    /// Column
    fileprivate var _column: ColumnTypeProtocol!
    public var column: ColumnTypeProtocol { return _column }
    
    /// Real data
    fileprivate lazy var _realData: Any = self.parseRealData()
    public var realData: Any { return self._realData }
    
    /// Raw data
    /// Intent for presentation in Field cell
    /// We use it to reduce hit performance. Only parse to real data if possible
    fileprivate lazy var _rawData: String = self.parseRawData()
    public var rawData: String {
        return self._rawData
    }
    
    /// Determine if current value is <null>
    /// Store it as NSNull
    fileprivate var _isNull: Bool = false
    public var isNull: Bool { return self._isNull }
    
    /// Col type
    public var colType: ColumnType { return self.column.colType }
    
    //
    // MARK: - Init
    init(resultPtr: OpaquePointer, rowIndex: Int, column: Column) {
        self._column = column
        self.parseData(resultPtr: resultPtr, rowIndex: rowIndex, column: column)
    }
}


//
// MARK: - Private
extension Field {
    
    fileprivate func parseData(resultPtr: OpaquePointer, rowIndex: Int, column: Column) {
        
        // Decoder
        self.decoder = Decoder(resultPtr: resultPtr, rowIndex: rowIndex, column: column)
        
        // Is Null
        guard decoder.isNull() == false else {
            self._isNull = true
            return
        }
    }
    
    fileprivate func parseRealData() -> Any {
        
        // Is null
        guard self.isNull == false else {
            return NSNull()
        }
        
        // Real data
        let value = self.decoder.decodeRawData(self.rawData, column: self.column)
        return value
    }
    
    fileprivate func desctiptionValue() -> String {
        return "[\(self.rawData):\(self._column.colType)]"
    }
    
    fileprivate func parseRawData() -> String {
        if self.isNull {
            return "NULL"
        }
        return decoder.getRawData()
    }
}

//
// MARK: - CustomDebugStringConvertible
extension Field: CustomDebugStringConvertible {
    public var debugDescription: String {
        return self.desctiptionValue()
    }
}

//
// MARK: - CustomStringConvertible
extension Field: CustomStringConvertible {
    public var description: String {
        return self.desctiptionValue()
    }
}

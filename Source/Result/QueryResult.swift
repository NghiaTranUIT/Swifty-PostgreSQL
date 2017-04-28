//
//  Result.swift
//  Swifty-PostgreSQL
//
//  Created by Nghia Tran on 11/15/16.
//  Copyright © 2016 Titan. All rights reserved.
//

import Foundation
import libpq

open class QueryResult {
    
    //
    // MARK: - Variable
    
    /// Result Pointer
    /*
    Returns a PGresult pointer or possibly a NULL pointer.
     
    A non-null pointer will generally be returned except in out-of-memory conditions 
    or serious errors such as inability to send the command to the server.
     
    The PQresultStatus function should be called to check the return value for any errors 
    (including the value of a null pointer, in which case it will return PGRES_FATAL_ERROR).
    Use PQerrorMessage to get more information about such errors.
     
    // Ref: https://www.postgresql.org/docs/9.1/static/libpq-exec.html
    */
    public var resultPtr: OpaquePointer?
    
    /// Status
    public let resultStatus: ResultStatus!
    public let resultMessage: String!
    
    //
    // MARK: - Query Result
    
    // Number of col
    public lazy var numberOfColumns: Int = {
        guard let resultPtr = self.resultPtr else {return 0}
        return Int(PQnfields(resultPtr))
    }()
    
    /// Number of row
    public lazy var numberOfRows: Int = {
        guard let resultPtr = self.resultPtr else {return 0}
        return Int(PQntuples(resultPtr))
    }()
    
    /// Rows
    public lazy var rows: [Row] = self.getRows()
    public lazy var columns: [Column] = self.getColumns()
    
    /// Col name at index
    fileprivate lazy var columnsName: [String] = self.getColumnsName()
    
    /// Type of colums
    fileprivate lazy var columnTypes: [ColumnType] = self.getTypeOfColIndex()
    
    /// Command Status
    public lazy var commandStatus: String = {
        guard let resultPtr = self.resultPtr else {return ""}
        return String(cString:PQcmdStatus(resultPtr))
    }()
    
    /// Rows affected
    public lazy var rowsAffected: Int = {
        guard let resultPtr = self.resultPtr else {return -1}
        return Int(String(cString:PQcmdTuples(resultPtr))) ?? -1
    }()
    
    //
    // MARK: - Pagination
    var isHaveNextPage: Bool { return false }
    
    //
    // MARK: - Init
    public init(_ resultPtr: OpaquePointer?) {
        self.resultPtr = resultPtr
        self.resultStatus = ResultStatus(resultPtr)
        self.resultMessage = self.resultStatus.toString()
    }
    
    deinit {
        Logger.error("QueryResult Deinit")
        PQclear(self.resultPtr)
    }
}


//
// MARK: - Private
extension QueryResult {
    
    /// Lazy get Row
    fileprivate func getRows() -> [Row] {
        
        guard let resultPtr = self.resultPtr else { return [] }

        // Map Row
        return (0..<self.numberOfRows).map { i -> Row in
            return Row.buildResultRow(atRowIndex: Int32(i),
                                      columns: self.columns,
                                      resultPtr: resultPtr)
        }
    }
    
    // Lazy get columns
    fileprivate func getColumns() -> [Column] {
        
        // Map Column
        return self.columnsName.enumerated().map { (i, element) -> Column in
            let nameCol = self.columnsName[i]
            let colType = self.columnTypes[i]
            return Column(colName: nameCol, colIndex: i, colType: colType)
        }
    }
    
    /// Lazy get type of cols
    fileprivate func getTypeOfColIndex() -> [ColumnType] {
        guard let resultPtr = self.resultPtr else {return []}
        
        // Map Column Type
        return (0..<self.numberOfColumns).map { (i) -> ColumnType in
            let typeId = PQftype(resultPtr, Int32(i))
            let type = ColumnType.build(rawValue: typeId)
            
            // Debug
            #if DEBUG
                if type == .unsupport {
                    let name = self.columnsName[Int(i)]
                    Logger.error("Unsupport name \(name), oid = \(typeId)")
                }
            #endif
            
            return type
        }
    }
    
    /// Lazy get col name
    fileprivate func getColumnsName() -> [String] {
        guard let resultPtr = self.resultPtr else {return []}
        
        // Map
        return (0..<self.numberOfColumns).map({return String(cString: PQfname(resultPtr, Int32($0)))})
    }
}

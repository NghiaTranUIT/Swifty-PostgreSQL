//
//  Table.swift
//  Swifty-PostgreSQL
//
//  Created by Nghia Tran on 1/20/17.
//  Copyright © 2017 Titan. All rights reserved.
//

import Foundation

//
// MARK: - TableSchema
public enum TableSchema: String {
    case pgCatalog          = "pg_catalog"
    case `public`           = "public"
    case informationSchema  = "information_shema"
    case none
}

//
// MARK: - TableType
public enum TableType: String {
    case baseTable          = "BASE TABLE"
    case view               = "VIEW"
    case forignTable        = "FOREIGN TABLE"
    case temporaryTable     = "LOCAL TEMPORARY"
    case none
}

//
// MARK: - Represent Table in PostgreSQL
open class Table {
    
    //
    // MARK: - Variable
    
    // Connection
    weak var connection: Connection?
    
    /// Catolog name
    public let tableCatalog: String?
    
    /// Table Schema
    public var tableSchema: TableSchema = TableSchema.none
    
    /// Table Name
    public let tableName: String!
    
    /// Table Type
    public var tableType: TableType = TableType.none
    
    /// Is insertable
    public let isInsertableInto: Bool?
    
    /// Is Typed
    public let isTyped: Bool?
    
    /// ID
    public let id: String = UUID.shortUUID()
    
    // Primary key
    public var primaryKey: String {
        return self.primaryColumn.colName
    }
    
    // Primary Column
    public lazy var primaryColumn: Column = self.getPrimaryColumn()
    
    // Total Row
    public lazy var totalRows: Int = self.getTotalRows()
    
    // Estimate row
    public lazy var estimateRows: Int = self.getEstimateRows()
    
    //
    // MARK: - Init
    init(connection: Connection, tableCatalog: String, tableSchema: String, tableName: String, tableType: String, isInsertableInto: Bool, isTyped: Bool) {
        self.tableCatalog = tableCatalog
        self.tableSchema = TableSchema(rawValue: tableSchema) ?? TableSchema.none
        self.tableName = tableName
        self.tableType = TableType(rawValue: tableType) ?? TableType.none
        self.isInsertableInto = isInsertableInto
        self.isTyped = isTyped
        self.connection = connection
    }
    
    init(connection: Connection, resultRow: Row) {
        self.tableCatalog = resultRow.field(with: "table_catalog")!.rawData
        let schema = resultRow.field(with: "table_schema")!.rawData
        self.tableSchema = TableSchema(rawValue: schema) ?? TableSchema.none
        self.tableName = resultRow.field(with: "table_name")!.rawData
        let type = resultRow.field(with: "table_type")!.rawData
        self.tableType = TableType(rawValue: type) ?? TableType.none
        
        // Trick 
        // Store as formation_schema.yes_or_no -> Varchar
        // Need to stupid compare and parsing to boolean
        self.isInsertableInto = (resultRow.field(with: "is_insertable_into")!.realData as? String) == "YES"
        self.isTyped = (resultRow.field(with: "is_typed")!.realData as? String) == "YES"
        self.connection = connection
    }
    
    deinit {
        Logger.error("Table Deinit")
    }
}

//
// MARK: - Private
extension Table {
    
    fileprivate func tableDescription() -> String {
        var debug =  "[Table]:"
        if let tableName = self.tableName {
            debug += " name=\(tableName)"
        }
        return debug
    }
    
    fileprivate func getPrimaryColumn() -> Column {
        guard let connection = self.connection else {
            fatalError("[getPrimaryColumn]: Connection was closed.")
        }

        // Query
        let query = QueryFactory.queryGetPrimaryKey(with: self)
        let result = connection.execute(query: query)
        let column = result.columns.first!
        let row = result.rows.first!
        let primaryCol = Column(colName: row.field(with: column)!.rawData, colIndex: 0, colType: column.colType)
        return primaryCol
    }
    
    fileprivate func getTotalRows() -> Int {
        
        guard let connection = self.connection else {
            fatalError("[getPrimaryColumn]: Connection was closed.")
        }
        
        // Query
        let query = QueryFactory.queryTotalRow(with: self)
        let result = connection.execute(query: query)
        return Int(result.rows.first!.field(with: "count")!.rawData)!
    }
    
    fileprivate func getEstimateRows() -> Int {
        guard let connection = self.connection else {
            fatalError("[getPrimaryColumn]: Connection was closed.")
        }
        
        // Query
        let query = QueryFactory.queryEstimateRows(with: self)
        let result = connection.execute(query: query)
        return Int(result.rows.first!.field(with: "estimate")!.rawData)!
    }
}

//
// MARK: - CustomStringConvertible
extension Table: CustomStringConvertible {
    public var description: String {
        return self.tableDescription()
    }
}

//
// MARK: - CustomDebugStringConvertible
extension Table: CustomDebugStringConvertible {
    public var debugDescription: String {
        return self.tableDescription()
    }
}

//
// MARK: - Equatable
extension Table: Equatable {
    
    public static func ==(lhs: Table, rhs: Table) -> Bool {
        return lhs.id == rhs.id
    }
}

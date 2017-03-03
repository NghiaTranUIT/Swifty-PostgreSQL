//
//  QueryFactory.swift
//  Swifty-PostgreSQL
//
//  Created by Nghia Tran on 3/3/17.
//  Copyright © 2017 Titan. All rights reserved.
//

import Foundation

struct QueryFactory {
    
    // Get primary Key from Table
    static func queryGetPrimaryKey(with table: Table) -> Query {
        let tableName = table.tableName
        let rawQuery = "SELECT a.attname, format_type(a.atttypid, a.atttypmod) AS data_type " +
                            "FROM   pg_index i " +
                            "JOIN   pg_attribute a ON a.attrelid = i.indrelid " +
                            "AND a.attnum = ANY(i.indkey) " +
                            "WHERE  i.indrelid = \'\(tableName!)\' ::regclass AND i.indisprimary;"
        let query = Query(stringLiteral: rawQuery)
        return query
    }
    
    // Get all Public table
    static func queryGetAllPublicTable() -> Query {
        let query: Query = "SELECT * FROM information_schema.tables WHERE table_schema='public'"
        return query
    }
}

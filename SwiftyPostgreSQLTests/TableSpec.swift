//
//  TableSpec.swift
//  Swifty-PostgreSQL
//
//  Created by Nghia Tran on 3/3/17.
//  Copyright © 2017 Titan. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import SwiftyPostgreSQL

class TableSpec: QuickSpec {

    override func spec() {
        
        var database: Database!
        var connectionResult: ConnectionResult!
        var connection: Connection!
        var validParam: ConnectionParam!
        let userTableName = "users"
        var userTable: Table!
        var tables: [Table]!
        
        beforeEach {
            database = Database()
            validParam =  ConnectionParam.validConnectionParam
            connectionResult = database.connectDatabase(withParam: validParam)
            
            connection = connectionResult.connection!
            tables = connection.publicTables
            userTable = tables.filter({ (table) -> Bool in
                return table.tableName == userTableName
            }).first
        }
        
        describe("Get User table") {
            context("Get User Table", {
                it("Success", closure: {
                    
                    // Expectation
                    expect(tables.count) > 0
                    expect(userTable).notTo(beNil())
                    expect(userTable!.isInsertableInto).to(equal(true))
                    expect(userTable!.tableName).to(equal(userTableName))

                })
                
                
                it("Primary key", closure: {
                    
                    let primaryCol = userTable!.primaryColumn
                    expect(primaryCol.colName) == "id"
                    expect(userTable.primaryKey) == "id"
                })
            })
        }
    }

}

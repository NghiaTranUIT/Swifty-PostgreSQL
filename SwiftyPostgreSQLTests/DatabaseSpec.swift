//
//  Database.swift
//  Swifty-PostgreSQL
//
//  Created by Nghia Tran on 11/15/16.
//  Copyright © 2016 Titan. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import SwiftyPostgreSQL

class DatabaseSpec: QuickSpec {
    
    override func spec() {
        
        describe("Connection to Database") {
            
            var database: Database!
            
            beforeEach {
                database = Database()
            }
            
            context("Valid localhost database", {
                
                it("Success", closure: {
                    
                    // Valid
                    let validParam = ConnectionParam.validConnectionParam
                    
                    let result = database.connectDatabase(withParam: validParam)
                    expect(result.connection).toNot(beNil())
                    
                    
                    if result.status != ConnectionStatus.CONNECTION_OK {
                        
                        assert(false, "Look like you forgot to configuration your database")
                        
                        /*
                         Please navigate to ConnectionParam.validConnectionParam
                         and setup your database like that
                         */
                    }
                    
                    expect(result.status) == ConnectionStatus.CONNECTION_OK

                })
            })
            
            context("Invalid localhost database", { 
                
                it("Got Error", closure: {
                    
                    // invalid
                    let invalidParam = ConnectionParam.invalidConnectionParam
                    
                    let result = database.connectDatabase(withParam: invalidParam)
                    expect(result.connection).to(beNil())
                    expect(result.status) != ConnectionStatus.CONNECTION_OK
                })
            })
        }
    }
}

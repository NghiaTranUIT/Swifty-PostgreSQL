//
//  ParamConnection+Helper.swift
//  Swifty-PostgreSQL
//
//  Created by Nghia Tran on 11/15/16.
//  Copyright © 2016 Titan. All rights reserved.
//

import Foundation
import SwiftyPostgreSQL

extension ConnectionParam {
    
    
    /// Valid
    static var validConnectionParam: ConnectionParam {
        return ConnectionParam(host: "localhost", port: "5432", options: "", databaseName: "feels_v2_development", user: "feels", password: "feels536")
    }
    
    
    /// Invalid
    static var invalidConnectionParam: ConnectionParam {
        return ConnectionParam(host: "localhost_123", port: "5432", options: "", databaseName: "pixai_dashboard_development", user: "feels", password: "feels536")
    }
}

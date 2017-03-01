<h3 align="center">
    <img src="https://raw.githubusercontent.com/NghiaTranUIT/Swifty-PostgreSQL/master/Screenshots/background.png" width="100%" />
</h3>
  
<p align="center">
  <a href="http://nghiatran.me">Mad lab</a> &bull;
  <a href="https://github.com/NghiaTranUIT/Titan-Postgresql">Titan</a> &bull;
  <b>Swifty PostgreSQL</b> &bull;
  <a href="https://github.com/NghiaTranUIT/FeSpinner">FeSpinner</a>
  <br> &nbsp;
  <a href="https://github.com/NghiaTranUIT/iOS-Awesome-Starter-Kit/edit/master/README.md">iOS Awesome Starter Kit</a> &bull;
  <a href="https://github.com/NghiaTranUIT/FeSlideFilter">FeSlideFilter</a>
</p>

Swifty PostgreSQL
------------
  
Swifty-PostgreSQL driver, written by Swift 3.0, and using in TitanKit.   
The Swifty warpper PostgreSQL's pointer and C functions, and handle allocate/dellocate memory automatically.   
Offer ability to connect many database simultaneously, modeling all PostgreSQL's enum and constants.   
   
Field model adopt Presentable protocol, so you can get rawString or realData depend on kind of data eaiser, all expensive operations are lazy computed as well.   

![](https://img.shields.io/badge/Swift-3.0-blue.svg?style=flat)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![License](https://img.shields.io/npm/l/express.svg?style=flat)
![Platform](https://img.shields.io/badge/platform-osx-green.svg?style=flat)

Roadmap
------------

- [x] Sketch
- [x] Base Foundation (50%)
- [ ] Fully Common PostgreSQL
- [ ] Prefix searching - implement by Prefix Tree
- [ ] Smart Query
- [ ] Write Test 

Installation
------------

- OSX

```bash
$ brew install postgresql
```

- Carthage

```swift
github "NghiaTranUIT/Swifty-PostgreSQL" ~> 0.1
```

Documentation
------------

- Connection Database
```swift
let param = ConnectionParam(host: "localhost", port: "5432", options: "",
databaseName: "my-database", user: "nghiatran", password: "mypassword")
let database = Database()

// Connection
let result = database.connectDatabase(withParam: param)

// Check result
guard result.status == .CONNECTION_OK else {return}
let connection = result.connection!

// Disconnection
database.closeConnection()
```

- Public tables
```swift
let connection = result.connection!
let tables: [Table] = connection.publicTables
```

- Query
```swift
let query: Query = "SELECT id, first_name, last_name, email FROM users ORDER BY id DESC LIMIT 10"
let result = connection.execute(query: query)

guard result == .PGRES_TUPLES_OK else {return}
print(result.rows) // [Row]
print(result.columns) // [Columns]
print(result.numberOfColumns)
print(result.numberOfRows)
print(result.rowsAffected)
```

- Data type
```swift
public enum ColumnType: UInt32 {
    
    case boolean = 16
    case int64 = 20
    case int16 = 21
    case int32 = 23
    case text = 25
    case singleFloat = 700
    case doubleFloat = 701
    case varchar = 1043
    case byte = 17
    case char = 18
    case json = 114
    case date = 1082
    case time = 1083
    case timestamp = 1114
    case unsupport = 0
}
```

- Access data
```swift
let firstRow = selfrows.first!

// Id
let field_id = firstRow!.field(with: "id")
print(field_id.rawData) // String
print(field_id.isNull)  // Check if it's NULL
print(field_id.realData)// Real data, lazy computed, auto mapping data to json or NSDate, ...
print(field_id.colType) // Int32
```

Run Test
------------
(Progessing)  
Will implement Docker for testing purpose. Currently, The test only passed in my laptop.

Contact
------------
  
Vinh Nghia Tran

http://github.com/NghiaTranUIT  
http://www.nghiatran.me  
vinhnghiatran@gmail.com  
  
Contributor
------------

It would be greatly appreciated  when you make a pull-quest  🤗

License
------------

Swifty PostgreSQL is available under the MIT license. See the LICENSE file for more info.

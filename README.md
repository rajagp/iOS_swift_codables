# iOS_swift_codables
Swift Playground for Exploring Swift4 Codables for JSON Parsing

# Requirements
- Xcode 9 and above
- Swift 4

# To Begin
- Open `SwiftCodables.playground` in Xcode
- Start with `Toc.xcplayground` page which from where you can navigate to the other playground pages. Make sure you check the `Render Documentation` checkbox.

![](https://raw.githubusercontent.com/couchbaselabs/iOS_swift_codables/master/begin.png)

# Execution
- Navigate to the playground that you want to Execute a playground by clicking on the "Run" button 
![](https://raw.githubusercontent.com/couchbaselabs/iOS_swift_codables/master/execute.gif)

# Examples
Examples demonstrating transformation between JSON and Swift native types using  swift4 Codables. Each chapter looks at various use cases.
 
 - [The Basics](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/The%20Basics.xcplaygroundpage/Contents.swift)
     - The examples introduce the Swift Encodable and Decodable protocols
  - [Date](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/Date.xcplaygroundpage/Contents.swift)
     - The example discuss the use of built in `Date` encoders/decoders
 - [Simple Custom Codable Type](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/Simple%20Custom%20Codable%20Type.xcplaygroundpage/Contents.swift)
     - The examples discuss the use of nested `Codable` types
 - [Introduction to Codable Keys](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/Intro%20to%20Codable%20Keys.xcplaygroundpage/Contents.swift)
     - The examples introduce the `CodableKey` protocol and how you can use it to specify the mapping of JSON-native properties
 - [Containers](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/Containers.xcplaygroundpage/Contents.swift)
     - The examples introduce the concept of `Containers` includeing `KeyedContainer`, `UnkeyedContainer` and `ValueContainer`
 - [Changing Types](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/Changing%20Types.xcplaygroundpage/Contents.swift)
     - The examples demonstrate how you can change the type of a property to an appropriate native type when it is tranformed to a swift type and back
 - [Flattening Types](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/Flattening%20Types.xcplaygroundpage/Contents.swift)
   - The examples demonstrate how you can flatten a nested JSON object when converting to native type
 - [Associative Enums](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/Associative%20Enums.xcplaygroundpage/Contents.swift)
     - The examples demonstrate the encoding / decoding of a swift associative enum type to correpsonding JSON types
 - [Subclasses](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/subclasses.xcplaygroundpage/Contents.swift)
      - The examples demonstrate the encoding/decoding of native subclasses to corresponding JSON types
 - [Dynamic Coding Keys](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/Dynamic%20Coding%20Keys.xcplaygroundpage/Contents.swift)
      -  The examples demonstrate the encoding / decoding JSON objects that hold dynamic set of keys
 - [Context](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/Context.xcplaygroundpage/Contents.swift)
      -  The examples demonstrate the use of context data for encoding/decoding
 - [All Together](https://github.com/couchbaselabs/iOS_swift_codables/blob/master/SwiftCodables.playground/Pages/All%20Together.xcplaygroundpage/Contents.swift)
     -  A more complete example that puts together all the concepts showcased in previous examples 

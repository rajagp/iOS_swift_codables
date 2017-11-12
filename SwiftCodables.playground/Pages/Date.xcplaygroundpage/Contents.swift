//
//  Date
//  SwiftCodables.playground
//
//  Created by Priya Rajagopal on 11/03/2017
//

/*:
 [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)
 ****
 
 Example shows how you can encode/decode to/from an external representation such as JSON to corresponding swift native type. In this example, the property types include `Date` value. JSON does not include a build-in `Date` type. So  date values are typically specified as a UTC long value of as a ISO 8601 formatted string.
 
 In this example, we show how we can encode/decode swift `Date` types to ISO8601 formatted date strings
 
 */


import Foundation
import PlaygroundSupport

/*:
 JSON Representation of a User Profile. The dob date value if in ISO 8601 format
 */
let userProfile =
"""
{
"id": 1002889,
"name": {"first":"Leanne",
"last":"Graham"},
"email": "Sincere@april.biz",
"address": "101, Main street",
"phone": ["555-736-8031","555-8933"],
"dob":"2017-11-12T20:06:28+00:00"
}
"""

/*:
 UserProfile is the corresponding native representation conforming to Encodable and Decodable protocols.
 Decodable implies that you can decode from external representation such as JSON type to the native type
 Encodable implies that you can encode from the native type to external representation such as JSON.
 In this example, we will look at how you can extend the [Basics](The%20%Basics) example so the encoding/decoding Since the `title` in the JSON can only take one of 4 possible values, it would make sense to define that as a enum type. This would ensure that when encoding/decoding, that the `title` takes on only one of the 4 allowed values - else you will end up with a "The data couldn’t be read because it isn’t in the correct format" class.
 
 */
struct UserProfile:Codable {
    let id:Int
    let name:[String:String]
    let email:String
    let address:String
    let phone:[String]
    let dob:Date
    
}


/*:
 Encoding and Decoding Logic
 
 */
if let jsonData = userProfile.data(using: .utf8) {
    
    do {
        // Decode from JSON representation to Decodable type
        // Instance of JSON Decoder
        let decoder = JSONDecoder.init()
        decoder.dateDecodingStrategy = .iso8601
        
        let myUser = try decoder.decode(UserProfile.self, from: jsonData)
        print ("*****\nDecoded Native Representation \(myUser)")
        
        
        // Now encode this back
        let encoder = JSONEncoder.init()
        encoder.outputFormatting = .prettyPrinted
        let myUserData = try encoder.encode(myUser)
        
        
        let myUserDataStr = String.init(data: myUserData, encoding: .utf8)
        print("\n *****\nEncoded String Representation:  \(String(describing: myUserDataStr))")
        
        
    }
    catch {
        print("Error \(error.localizedDescription)")
    }
    
}

//: [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)


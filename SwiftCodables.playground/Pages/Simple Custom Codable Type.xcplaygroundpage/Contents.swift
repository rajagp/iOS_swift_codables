//
//  Simple Custom Codable Type
//  SwiftCodables.playground
//
//  Created by Priya Rajagopal on 11/03/2017
//
/*:
 [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)
 ****
 
 Example shows how you can encode/decode to/from an external representation such as JSON to corresponding swift native type. In this example, the property types include custom data types */


import Foundation
import PlaygroundSupport

/*:
 JSON Representation of a User Profile. In this case assume that the `title` value can take one of the following values
 - engineer
 - manager
 - support
 - qa
 */
let userProfile =
"""
{
"id": 1002889,
"name": {"first":"Leanne",
"last":"Graham"},
"title": "qa",
"email": "Sincere@april.biz",
"address": "101, Main street",
"phone": ["555-736-8031","555-8933"],
"imageurl": "http://hildegard.org"
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
    let title:Title
    let email:String
    let address:String
    let phone:[String]
    let imageurl:URL
}

/*:
 Title is enum type that conforms to the `Codable` type. Every enumeration case has a raw value that is the name of the case. By enforcing that the `title` proper
 
 */
enum Title:String, Codable {
    case engineer
    case manager
    case support
    case qa
}

/*:
 Encoding and Decoding Logic
 
 */
if let jsonData = userProfile.data(using: .utf8) {
    
    do {
        // Decode from JSON representation to Decodable type
        // Instance of JSON Decoder
        let decoder = JSONDecoder.init()
        
        let myUser = try decoder.decode(UserProfile.self, from: jsonData)
        print ("*****\nDecoded Native Representation \(myUser)")
        
        
        // Now encode this back
        let encoder = JSONEncoder.init()
        encoder.outputFormatting = .prettyPrinted
        let myUserData = try encoder.encode(myUser)
        
        
        let myUserDataStr = String.init(data: myUserData, encoding: .utf8)
        print("\n*****\nEncoded String Representation:  \(String(describing: myUserDataStr))")
        
        
    }
    catch {
        print("Error \(error.localizedDescription)")
    }
    
}

//: [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)

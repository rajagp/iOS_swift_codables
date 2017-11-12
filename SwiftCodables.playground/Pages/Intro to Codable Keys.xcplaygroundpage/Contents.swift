//
//  Intro to Codable Keys
//  SwiftCodables.playground
//
//  Created by Priya Rajagopal on 11/03/2017
//
/*:
 [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)
 ****
 
 Example shows how you can encode/decode to/from an external representation such as JSON to corresponding swift native type.
 
 In this example, we will see how you can customize the mapping of properties between JSON and swift representations.  */


import Foundation
import PlaygroundSupport

/*:
 JSON Representation of a User Profile. 
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
 Encodable implies that you can encode from the native type to external representation such as.
 Here CodingKeys type confirms to the `CodingKey` protocol. It specifies that mapping of the JSON name to the corresponding property name. When raw type is not specified, it implies that the name is the same in both cases.
 Also notice that the native type includes `key` property that is not in the corresponding JSON.  This would be for instance, a key that you may store and use locally in your app but don;t want to tranform to an external representation and share.
 Properties that do not have a CodingKey must be provided a default value.
 */
struct UserProfile:Codable {
    let id:Int
    let name:[String:String]
    let title:String
    let email:String
    let phone:[String]
    let imageUrl:URL
    var key:Data = Data()
    
    enum CodingKeys:String,CodingKey {
        case id
        case name
        case title
        case email
        case imageUrl = "imageurl"
        case phone
        
    }
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

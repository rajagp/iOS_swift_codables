//
//  The Basics
//  SwiftCodables.playground
//
//  Created by Priya Rajagopal on 11/03/2017
//

/*:
  [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)
****
 
 Example shows how you can encode/decode to/from an external representation such as JSON to corresponding swift native type with properties of standard data types that automatically conform to Codable Protocol  */
import Foundation
import PlaygroundSupport

/*:
 JSON Representation of a User Profile
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
 UserProfile is the corresponding native representation conforming to Encodable and Decodable protocols
 Decodable implies that you can decode from external representation such as JSON type to the native type
 Encodable implies that you can encode from the native type to external representation such as JSON
 
 This is the simplest example of the same
 */
struct UserProfile:Decodable,Encodable {
    let id:Int
    let name:[String:String]
    let title:String
    let email:String
    let address:String
    let phone:[String]
    let imageurl:URL
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
        print("***** \n Decoded Native Representation \(myUser)")
        
        
        // Now encode this back
        let encoder = JSONEncoder.init()
        encoder.outputFormatting = .prettyPrinted
        let myUserData = try encoder.encode(myUser)
        
    
        let myUserDataStr = String.init(data: myUserData, encoding: .utf8)
        print("\n ***** \n Encoded String Representation:  \(String(describing: myUserDataStr))")
        
        
    }
    catch {
        print("Error \(error.localizedDescription)")
    }

}
//:  [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)

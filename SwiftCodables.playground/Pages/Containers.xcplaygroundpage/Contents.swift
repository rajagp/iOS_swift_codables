//
//  Containers
//  SwiftCodables.playground
//
//  Created by Priya Rajagopal on 11/03/2017
//

/*:
 [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)
 ****
 
 Example shows how you can encode/decode to/from an external representation such as JSON to corresponding swift native type.
 In this example, we will demonstrate the use of the different container types .
 From json.org
 In JSON, they take on these forms:
 
 - An object is an unordered set of name/value pairs. An object begins with { (left brace) and ends with } (right brace). Each name is followed by : (colon) and the name/value pairs are separated by , (comma).
 - An array is an ordered collection of values. An array begins with [ (left bracket) and ends with ] (right bracket). Values are separated by , (comma).
 
 - A value can be a string in double quotes, or a number, or true or false or null, or an object or an array. These structures can be nested.
 
 Once you have the top level container, you can use the ValueContainer to get to individual values
 
 */


import Foundation
import PlaygroundSupport

/*:
 Case 1: JSON Representation of a User Profile. Top level object is a dictionary.
 */
let userProfile =
"""
{
"id": 1002889,
"name": "Leanne Graham",
"email": "Sincere@april.biz",
"phone": ["555-736-8031","555-8933"]

}
"""

/*:
 Native Representation of a User Profile. Encoding and Decoding is done using the KeyedContainer
 Note that we will be implementing the encodable and decodable protocol ** for demonstration purposes only **. Since
 the the types are all conformant to Codable, the compiler would generate the implementation
 */
struct UserProfile: Codable {
    var id:Int
    var name:String
    var email:String
    var phone:[String]
    
    enum CodingKeys:String,CodingKey {
        case id
        case name
        case email
        case phone
        
    }
    
}

/*:
 This extension to UserProfile handles coding and decoding manually
 In the decoding function, the string value of name in JSON is split up and the `name` property is updated
 In the encoding function, the first and last values in `Name` struct is encoded as a string
 We use a keyed value container to encode and decode the values
 */
extension UserProfile {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: UserProfile.CodingKeys.id)
        self.name = try container.decode(String.self, forKey: UserProfile.CodingKeys.name)
        self.email = try container.decode(String.self, forKey: UserProfile.CodingKeys.email)
        self.phone = try container.decode([String].self, forKey: UserProfile.CodingKeys.phone)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: UserProfile.CodingKeys.id)
        try container.encode(self.email, forKey: UserProfile.CodingKeys.email)
        try container.encode(self.phone, forKey: UserProfile.CodingKeys.phone)
        
    }
}

/*:
 Encoding and Decoding Logic with KeyedValueContainer
 
 */
if let jsonData1 = userProfile.data(using: .utf8) {
    
    do {
        // Decode from JSON representation to Decodable type
        // Instance of JSON Decoder
        let decoder = JSONDecoder.init()
        
        let myUser = try decoder.decode(UserProfile.self, from: jsonData1)
        print ("Decoded Native Representation \(myUser)")
        
        
        // Now encode this back
        let encoder = JSONEncoder.init()
        encoder.outputFormatting = .prettyPrinted
        let myUserData = try encoder.encode(myUser)
        
        
        let myUserDataStr = String.init(data: myUserData, encoding: .utf8)
        print("Encoded String Representation:  \(String(describing: myUserDataStr))")
        
        
    }
    catch {
        print("Error \(error.localizedDescription)")
    }
    
}

/*:
 Case 2:  JSON Representation of a User Profile. Top level object is an array of objects
 */
let userProfiles =
"""
[{
"id": 1002889,
"name": "Leanne Graham",
"email": "Sincere@april.biz",
"phone": ["555-736-8031","555-8933"]
},
{
"id": 1009009,
"name": "John Grisham",
"email": "Sincere@example.biz",
"phone": ["555-736-7892","555-1900"],
}]
"""

/*:
 Native Representation of a User Profiles array. Encoding and Decoding is done using the unkeyedContainer
 Note that we will be implementing the encodable and decodable protocol ** for demonstration purposes only **. Since
 the the types are all conformant to Codable, the compiler would generate the implementation
 */

struct UserProfiles:Codable {
    var profiles:[UserProfile] = [UserProfile]()
    public init(from decoder: Decoder) throws {
    
        var container = try decoder.unkeyedContainer()
        
        while container.isAtEnd == false {
            let userProf = try container.decode(UserProfile.self)
            profiles.append(userProf)
        }
    }
        
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(contentsOf: profiles)
   
    }
}

/*:
 Encoding and Decoding Logic with UnKeyedValueContainer
 
 */
if let jsonData2 = userProfiles.data(using: .utf8) {
    
    do {
        // Decode from JSON representation to Decodable type
        // Instance of JSON Decoder
        let decoder = JSONDecoder.init()
        
        let myUser = try decoder.decode(UserProfiles.self, from: jsonData2)
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



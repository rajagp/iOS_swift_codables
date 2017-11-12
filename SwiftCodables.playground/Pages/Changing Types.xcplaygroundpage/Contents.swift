//
//  Changing Types
//  SwiftCodables.playground
//
//  Created by Priya Rajagopal on 11/03/2017
//

/*:
 [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)
 ****
 
 Example shows how you can encode/decode to/from an external representation such as JSON to corresponding swift native type.
 In this example, we will see how you can can change the type of a property as it is transformed from JSON to swift representation and back.  */


import Foundation
import PlaygroundSupport

/*:
 JSON Representation of a User Profile.
 */
let userProfile =
"""
{
"id": 1002889,
"name": "Leanne Graham",
"title": "qa",
"email": "Sincere@april.biz",
"phone": ["555-736-8031","555-8933"],
"imageurl": "https://example.com/profile.png",

}
"""

/*:
 UserProfile is native representation of the User Profile string.
 Decodable implies that you can decode from external representation such as JSON type to the native type
 Encodable implies that you can encode from the native type to external representation such as JSON
 Here notice property `name` of type "Name" is defined as struct of first and last name. So we are going to essentially map from "name" which is "string" type in JSON to the struct.
 */

struct UserProfile: Codable {
    var id:Int
    var name:Name
    var title:Title
    var email:String
    var phone:[String]
    var imageUrl:URL
    
    enum CodingKeys:String,CodingKey {
        case id
        case name
        case title
        case email
        case imageUrl = "imageurl"
        case phone
        
    }
    
    struct Name :Codable {
        var first:String
        var last:String
    }
    
}

enum Title:String, Codable {
    case engineer
    case manager
    case support
    case qa
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
        self.title = try container.decode(Title.self, forKey: UserProfile.CodingKeys.title)
        self.email = try container.decode(String.self, forKey: UserProfile.CodingKeys.email)
        self.phone = try container.decode([String].self, forKey: UserProfile.CodingKeys.phone)
        self.imageUrl = try container.decode(URL.self, forKey: UserProfile.CodingKeys.imageUrl)
        let nameVal = try container.decode(String.self, forKey: UserProfile.CodingKeys.name)
        let parts = nameVal.split(separator:Character.init(" "))
        self.name = Name(first: String.init(parts[0]), last: String.init(parts[1]))
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: UserProfile.CodingKeys.id)
        try container.encode(self.title, forKey: UserProfile.CodingKeys.title)
        try container.encode(self.email, forKey: UserProfile.CodingKeys.email)
        try container.encode(self.phone, forKey: UserProfile.CodingKeys.phone)
        try container.encode(self.imageUrl, forKey: UserProfile.CodingKeys.imageUrl)
        let nameVal = "\(self.name.first) \(self.name.last)"
        try container.encode(nameVal, forKey: UserProfile.CodingKeys.name)
        
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


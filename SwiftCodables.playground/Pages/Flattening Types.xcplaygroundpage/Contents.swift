//
//  Flattening Types
//  SwiftCodables.playground
//
//  Created by Priya Rajagopal on 11/03/2017
//

/*:
 [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)
 ****
 
 Example shows how you can encode/decode to/from an external representation such as JSON to corresponding swift native type.
 In this example, we will see how you can can unnest a nested type in a JSON when it is transformed to swift representation and back.  */


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
"imageurl": "http://hildegard.org",
"interests" : {
"sports":["football","baseball"],
"music":["violin","classical"]
}
}
"""

/*:
 UserProfile is native representation of the User Profile string.
 Decodable implies that you can decode from external representation such as JSON type to the native type
 Encodable implies that you can encode from the native type to external representation such as JSON
 Here notice that there are two properties `sports` and `music`. So we are going to essentially flatten the "interests" object in JSON to "sports" and "music" properties.
 */
struct UserProfile: Codable {
    var id:Int
    var name:Name
    var title:Title
    var email:String
    var phone:[String]
    var imageUrl:URL
    var sports:[String]
    var music:[String]
    
    enum MainCodingKeys:String,CodingKey {
        case id
        case name
        case title
        case email
        case imageUrl = "imageurl"
        case phone
        case interests
        
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
 In the decoding function, the `interests` in JSON is flattened into `sports` and `music`
 In the encoding function, the `sports` and `music` values iis encoded as a JSON object

 The `InterestsCodingKeys` conforms to CodingKey.  We use a nested container to encode and decode the value of "interests" 
 */

extension UserProfile {
    enum InterestsCodingKeys:String,CodingKey {
        case sports
        case music
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MainCodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: UserProfile.MainCodingKeys.id)
        self.title = try container.decode(Title.self, forKey: UserProfile.MainCodingKeys.title)
        self.email = try container.decode(String.self, forKey: UserProfile.MainCodingKeys.email)
        self.phone = try container.decode([String].self, forKey: UserProfile.MainCodingKeys.phone)
        self.imageUrl = try container.decode(URL.self, forKey: UserProfile.MainCodingKeys.imageUrl)
        let nameVal = try container.decode(String.self, forKey: UserProfile.MainCodingKeys.name)
        let parts = nameVal.split(separator:Character.init(" "))
        self.name = Name(first: String.init(parts[0]), last: String.init(parts[1]))
        
        let interestContainer = try container.nestedContainer(keyedBy: InterestsCodingKeys.self, forKey: UserProfile.MainCodingKeys.interests)
        self.sports = try interestContainer.decode([String].self, forKey: UserProfile.InterestsCodingKeys.sports)
        self.music  = try interestContainer.decode([String].self, forKey: UserProfile.InterestsCodingKeys.music)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MainCodingKeys.self)
        try container.encode(self.id, forKey: UserProfile.MainCodingKeys.id)
        try container.encode(self.title, forKey: UserProfile.MainCodingKeys.title)
        try container.encode(self.email, forKey: UserProfile.MainCodingKeys.email)
        try container.encode(self.phone, forKey: UserProfile.MainCodingKeys.phone)
        try container.encode(self.imageUrl, forKey: UserProfile.MainCodingKeys.imageUrl)
        
        var interestContainer = container.nestedContainer(keyedBy: InterestsCodingKeys.self, forKey: UserProfile.MainCodingKeys.interests)
        
        try interestContainer.encode(self.sports, forKey: UserProfile.InterestsCodingKeys.sports)
        try interestContainer.encode(self.music, forKey: UserProfile.InterestsCodingKeys.music)
        
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

//:  [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)

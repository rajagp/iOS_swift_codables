//
//  Associative Enums
//  SwiftCodables.playground
//
//  Created by Priya Rajagopal on 11/03/2017
//

/*:
 [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)
 ****
 
 Example shows how you can encode/decode to/from an external representation such as JSON to corresponding swift native type.
 In this example, we will show how you can map a JSON element to an associative enum type */
import Foundation

/* :
 This version of userProfile string specifies the "image" as a Base-64 encoded string
 */
let userProfile1 =
"""
{
"id": 1002889,
"name": "Leanne Graham",
"title": "qa",
"email": "Sincere@april.biz",
"phone": ["555-736-8031","555-8933"],
"image": "http://example.com/headshot.png"

}
"""
/* :
 This version of userProfile string specifies  "image" as a Base-64 encoded string
 */
let userProfile2 =
"""
{
"id": 1002889,
"name": "Leanne Graham",
"title": "qa",
"email": "Sincere@april.biz",
"phone": ["555-736-8031","555-8933"],
"image": "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"

}
"""

/*:
 UserProfile is native representation of the User Profile string.
 Decodable implies that you can decode from external representation such as JSON type to the native type
 Encodable implies that you can encode from the native type to external representation such as JSON
 Notice that `image` property is of type ImageType
 */
struct UserProfile: Codable {
    var id:Int
    var name:Name
    var title:Title
    var email:String
    var phone:[String]
    var image:ImageType
    
    enum MainCodingKeys:String,CodingKey {
        case id
        case name
        case title
        case email
        case image = "image"
        case phone
        
    }
    
    struct Name :Codable {
        var first:String
        var last:String
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MainCodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: UserProfile.MainCodingKeys.id)
        self.title = try container.decode(Title.self, forKey: UserProfile.MainCodingKeys.title)
        self.email = try container.decode(String.self, forKey: UserProfile.MainCodingKeys.email)
        self.phone = try container.decode([String].self, forKey: UserProfile.MainCodingKeys.phone)
        let nameVal = try container.decode(String.self, forKey: UserProfile.MainCodingKeys.name)
        let parts = nameVal.split(separator:Character.init(" "))
        self.name = Name(first: String.init(parts[0]), last: String.init(parts[1]))
        
        self.image = try container.decode(ImageType.self, forKey: UserProfile.MainCodingKeys.image)
        
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MainCodingKeys.self)
        try container.encode(self.id, forKey: UserProfile.MainCodingKeys.id)
        try container.encode(self.title, forKey: UserProfile.MainCodingKeys.title)
        try container.encode(self.email, forKey: UserProfile.MainCodingKeys.email)
        try container.encode(self.phone, forKey: UserProfile.MainCodingKeys.phone)
        try container.encode(self.image, forKey: UserProfile.MainCodingKeys.image)
        
    }
}

enum Title:String, Codable {
    case engineer
    case manager
    case support
    case qa
}

/*:
 This extension to UserProfile defines  `ImageType` which is an associative enum that can take value of `url` or `string` type.
 Depending on whether the "image" in the JSON is a URL or string, the appropriate type is assigned.
 We use a single value container to encode and decode the value of "image" 
*/
extension UserProfile {
    enum ImageType :Codable {
        case url(URL)
        case base64String(String)
        
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let imageStr = try? container.decode(String.self),
                ImageType.isValidURLString(imageStr) == true,
                let imageUrl =  URL.init(string: imageStr){
                    self = ImageType.url(imageUrl)
            }
            else {
                let imageData = try? container.decode(String.self)
                self = ImageType.base64String(imageData ?? "")
                
            }
            
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch self {
            case .url(let url):
                try container.encode(url)
            case . base64String(let str):
                try container.encode(str)
            }
            
        }
        
        
        static func isValidURLString(_ urlString: String) -> Bool {
            if let urlComponents = URLComponents.init(string: urlString), urlComponents.host != nil, urlComponents.url != nil
            {
                return true
            }
            return false
        }
    }
   
    
   
}


/*:
 Encoding and Decoding Logic - When image is specified as a URL
 
 */

if let jsonData1 = userProfile1.data(using: .utf8) {
    
    do {
        // Decode from JSON representation to Decodable type
        // Instance of JSON Decoder
        let decoder = JSONDecoder.init()
        
        let myUser = try decoder.decode(UserProfile.self, from: jsonData1)
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

/*:
 Encoding and Decoding Logic - When image is specified as a base64 encoded string
 
 */

if let jsonData2 = userProfile2.data(using: .utf8) {
    
    do {
        // Decode from JSON representation to Decodable type
        // Instance of JSON Decoder
        let decoder = JSONDecoder.init()
        
        let myUser = try decoder.decode(UserProfile.self, from: jsonData2)
        print ("\n*****\nDecoded Native Representation \(myUser)")
        
        
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

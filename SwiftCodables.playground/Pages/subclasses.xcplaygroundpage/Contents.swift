//
//  subclasses
//  SwiftCodables.playground
//
//  Created by Priya Rajagopal on 11/03/2017
//


/*:
 [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)
 ****
 
 Example shows how you can encode/decode to/from an external representation such as JSON to corresponding swift native type.
 In this example, we will demonstrate how you can encode/decode from/to native types that is a subclass of another native types */
import Foundation

/* :
 JSON string that defines a user profile.
 
 */
let userProfile =
"""
{
"id": 1002889,
"name": "Leanne Graham",
"title": "qa",
"email": "Sincere@april.biz",
"phone": ["555-736-8031","555-8933"]
}
"""

/* :
JSON string that defines a student profile. Notice that the profile is identical to the userProfile string defined above but with addition of the "university" key.
 Based on the  string definitions, it would make sense that the native swift representation of the JSON subclass the original UserProfile type.

 */
let studentProfile =
"""
{
"id": 1002889,
"name": "Leanne Graham",
"title": "qa",
"email": "Sincere@april.biz",
"phone": ["555-736-8031","555-8933"],
"university":"RPI"
}
"""

/*:
 UserProfile is native representation of the User Profile string. Notice that this is class type so it can be
 subclassed.
 Decodable implies that you can decode from external representation such as JSON type to the native type
 Encodable implies that you can encode from the native type to external representation such as JSON
 
 */
class UserProfile: Codable {
    var id:Int
    var name:Name
    var title:Title
    var email:String
    var phone:[String]
    
    enum MainCodingKeys:String,CodingKey {
        case id
        case name
        case title
        case email
        case phone
        
    }
    
    struct Name :Codable {
        var first:String
        var last:String
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MainCodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: UserProfile.MainCodingKeys.id)
        self.title = try container.decode(Title.self, forKey: UserProfile.MainCodingKeys.title)
        self.email = try container.decode(String.self, forKey: UserProfile.MainCodingKeys.email)
        self.phone = try container.decode([String].self, forKey: UserProfile.MainCodingKeys.phone)
        let nameVal = try container.decode(String.self, forKey: UserProfile.MainCodingKeys.name)
        let parts = nameVal.split(separator:Character.init(" "))
        self.name = Name(first: String.init(parts[0]), last: String.init(parts[1]))
     }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MainCodingKeys.self)
        try container.encode(self.id, forKey: UserProfile.MainCodingKeys.id)
        try container.encode(self.title, forKey: UserProfile.MainCodingKeys.title)
        try container.encode(self.email, forKey: UserProfile.MainCodingKeys.email)
        try container.encode(self.phone, forKey: UserProfile.MainCodingKeys.phone)
        
    }
}

enum Title:String, Codable {
    case engineer
    case manager
    case support
    case qa
}

/*:
 StudentProfile is native representation of the Student Profile string. It is subclass of UserProfile and
 includes `university` property
 Notice that the encoding and decoding functions invoke the corresponding functions of the UserProfile superclass
 
 */
class StudentProfile:UserProfile {
    var university:String
    
    enum StudentCodableKeys:CodingKey {
        case university
    }
    
    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: StudentCodableKeys.self)
        self.university = try container.decode(String.self, forKey: StudentProfile.StudentCodableKeys.university)
        
        try super.init(from: decoder)
        
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: StudentCodableKeys.self)
        try container.encode(self.university, forKey: StudentProfile.StudentCodableKeys.university)
    }
    
}

/*:
 Encoding and Decoding Logic
 
 */
if let jsonData = studentProfile.data(using: .utf8) {
    
    do {
        // Decode from JSON representation to Decodable type
        // Instance of JSON Decoder
        let decoder = JSONDecoder.init()
        
        let myUser = try decoder.decode(StudentProfile.self, from: jsonData)
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


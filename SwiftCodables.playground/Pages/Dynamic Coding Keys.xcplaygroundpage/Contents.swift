//
//  Dynamic Coding Keys
//  SwiftCodables.playground
//
//  Created by Priya Rajagopal on 11/03/2017
//

/*:
 [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)
 ****
 
 Example shows how you can encode/decode to/from an external representation such as JSON to corresponding swift native type.
 In this example, we will demonstrate advanced CodingKey concept. In this case, the keys are not static */
import Foundation

/* :
 JSON string that defines a user profile.
 Notice that the "education" type is an array of JSON objects . The key values of JSON objects is not fixed. In naive case, the corresponding native type could just be an array of [String:String]. But that is not preferrable. It is probably more desirable to map this to a native type that is easier to process within the app
 
 */
let userProfile =
"""
{
"id": 1002889,
"name": "Leanne Graham",
"title": "qa",
"email": "Sincere@april.biz",
"phone": ["555-736-8031","555-8933"],
"education":[
    {"RPI":"01/01/2000"},
    {"UMich":"09/01/1998"}
    ]
}
"""

/*:
 UserProfile is native representation of the User Profile string.
 Notice that education is of an array of type `Education`. Let say we would like to decode ["RPI":"01/01/2000"] to  a struct with two properties { "name":"RPI", "graduation":"01/01/2000" }
 
 (You could trivially define edication to be of type [[String:String]])
 
 */
struct UserProfile: Codable {
    var id:Int
    var name:Name
    var title:Title
    var email:String
    var phone:[String]
    var education:[Education]
    
    enum MainCodingKeys:String,CodingKey {
        case id
        case name
        case title
        case email
        case phone
        case education
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
        
        self.education = try container.decode([Education].self, forKey: UserProfile.MainCodingKeys.education)
       
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MainCodingKeys.self)
        try container.encode(self.id, forKey: UserProfile.MainCodingKeys.id)
        try container.encode(self.title, forKey: UserProfile.MainCodingKeys.title)
        try container.encode(self.email, forKey: UserProfile.MainCodingKeys.email)
        try container.encode(self.phone, forKey: UserProfile.MainCodingKeys.phone)
        try container.encode(self.education, forKey: UserProfile.MainCodingKeys.education)
    }
    
}

enum Title:String, Codable {
    case engineer
    case manager
    case support
    case qa
}


/*:
 Education is native representation of the `education` property. Notice that the CodingKey is not defined as a simple enum of possible key names. This is because the key is not known upfront.
 So instead we define it as a struct that confors to `CodingKey` protocol.
 While decoding to the struct, walk through all the keys in the container - these keys correspond to university names. Then for each key, we get the corresponding value and set that as the graduation date.
 
 */
struct Education:Codable {
    var name:String = ""
    var graduation:String = ""
    
    struct EducationKeys:CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    public init(from decoder: Decoder) throws {
        print(#function)
        let container = try decoder.container(keyedBy: EducationKeys.self)
        
        for  key in container.allKeys {
            self.name = key.stringValue
            self.graduation = try container.decode(String.self, forKey: key)

        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EducationKeys.self)
        if let nameKey = EducationKeys(stringValue: self.name) {
            try container.encode(self.graduation, forKey: nameKey)
        }
    }
    
}


/*:
 Encoding and Decoding Logic
 
 */
if let jsonData = userProfile.data(using: .utf8) {
    
    // Instance of JSON Decoder
    let decoder = JSONDecoder.init()
    
    // Decode from JSON representation to Decodable type
    do {
        let myUser = try decoder.decode(UserProfile.self, from: jsonData)
        print ("*****\ndecoded value is \(myUser)")
        
        
        // Now encode this back
        
        let encoder = JSONEncoder.init()
        let myUserData = try encoder.encode(myUser)
        
        
        
        let myUserDataStr = String.init(data: myUserData, encoding: .utf8)
        print("\n*****\nmyUserDataStr \(myUserDataStr)")
   
        
    }
    catch {
        print("Error \(error.localizedDescription)")
    }
}


//: [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)

//
//  All Together
//  SwiftCodables.playground
//
//  Created by Priya Rajagopal on 11/03/2017
//

/*: [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)
 ****
 
 Example shows how you can encode/decode to/from an external representation such as JSON to corresponding swift native type.
 Here, we discuss a more complerte example and will leverage some of the capabilties discussed in earlier examples.
 The "extension" type below can include an arbitrary number of key-value pairs
 */

import Foundation

/*:
 Consider this (rather ugly looking) userProfile JSON representation.
 */
var userProfile =
"""
{
"active": true,
"address": {
"resourceType": "Address",
"text": "25 Cliveden Pl, Belgravia, London SW1W 8HD, UK"
},
"birthDate": "1987-01-01",
"e": "test3",
"extension": {
"Hello": "World!",
"music": "Acid Jazz"
},
"gender": {
"text": "Male"
},
"id": "0f62b5cb-3735-45f6-8ee9-deaeee7f308a",
"name": [
{
"family": [
"Krug"
],
"given": [
"Perry"
]
}
],
"resourceType": "Patient"
}
"""


/*:
 We would like to transform the above to the following swift struct  representation.
 Notice that
 - We are only interested in a subset of fields
 - we would like them to have a more consistent representation so it simplifies our code logic for parsing the data within the app for rendering and such (Example : flattening address)
 - we are renaming some of the keys more suited for the app
 - We are changing the type of Extension to be an array of extension type each of which has a consistent format that is easy to parse
 
 -
 {
    "id": "1002889",
    "names": [UserProfile.Name("last": "Krug", "first": "Perry")],
     "gender": UserProfile.Gender.Male,
     "birthDate": "1987-01-01",
     "address": "25 Cliveden Pl, Belgravia, London SW1W 8HD, UK",
     "extensions" :[
         {
             "name": "Hello"
             "value": "World!"
         },
         {
         "name": "music"
         "value": "Acid Jazz"
         }
     ]
 }

 */

struct UserProfile: Codable {
    var id:String
    var names:[Name]
    var gender:Gender
    var birthDate:String
    var address:String
    var extensions:[Extension] = [Extension]()
    
    enum MainCodingKeys:String,CodingKey {
        case id
        case names = "name"
        case gender
        case birthDate
        case address
        case extensions = "extension"
    }
    
}

extension UserProfile {
    static let AddressResourceType:String = "Address"
    enum AddressCodingKeys:String,CodingKey {
        case resourceType
        case text
    }
}

extension UserProfile {
    struct Name :Codable {
        var first:[String]
        var last:[String]
        enum NameCodingKeys: String, CodingKey {
            case first = "given"
            case last = "family"
        }
        
        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: NameCodingKeys.self)
            self.first =  try container.decode([String].self, forKey: NameCodingKeys.first)
            self.last = try container.decode([String].self, forKey: NameCodingKeys.last)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: NameCodingKeys.self)
            try container.encode(self.first, forKey:  NameCodingKeys.first)
            try container.encode(self.last, forKey:  NameCodingKeys.last)
        }
    }
}

extension UserProfile {
    enum GenderCodingKeys:String,CodingKey {
         case text
    }
    enum Gender:String, Codable {
        case Male
        case Female
        case Other
        case Unspecified
    }

}

extension UserProfile {

    struct Extension {
        var key:String
        var value:String
    }
    
    // The keys are dynamic
    struct ExtensionKeys:CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
            return nil
        }
    }
}
extension UserProfile {
    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: MainCodingKeys.self)
        
        // Id : no change from JSON representation
        self.id = try container.decode(String.self, forKey: UserProfile.MainCodingKeys.id)
        
        print(self.id)
        
        // birthdate : no change to JSON representation
        self.birthDate = try container.decode(String.self, forKey: UserProfile.MainCodingKeys.birthDate)
        
          print(self.birthDate)
          // gender: use enum type for mapping
        
        let genderContainer = try container.nestedContainer(keyedBy: GenderCodingKeys.self, forKey: UserProfile.MainCodingKeys.gender)
        self.gender = try genderContainer.decode(UserProfile.Gender.self, forKey: UserProfile.GenderCodingKeys.text)
        
         print(self.gender )
        
        // name : use custom Name type
        self.names = try container.decode([UserProfile.Name].self, forKey: UserProfile.MainCodingKeys.names)
        print(self.names)

        // address: Get nested container for address and flatten it
        let addrContainer = try container.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: UserProfile.MainCodingKeys.address)
        self.address = try addrContainer.decode(String.self, forKey: UserProfile.AddressCodingKeys.text)
        
         print(self.address)
        // extensions: Dynamic coding keys. We need to transform this dictionary into an array of K,V pairs
        // Get the nested container for extensions
        let extnContainer = try container.nestedContainer(keyedBy: UserProfile.ExtensionKeys.self, forKey: UserProfile.MainCodingKeys.extensions)
        
        // Now iteate over the keys in the "extension" object
        for  key in extnContainer.allKeys {
            // Get the key
            let key = key.stringValue
            // Get the value corresponding to the key.
            let value = try extnContainer.decode(String.self, forKey:ExtensionKeys.init(stringValue: key)!)
            let decodedExtn = Extension.init(key: key, value: value)
            
            self.extensions.append(decodedExtn)
            
        }
        
         print(self.extensions)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MainCodingKeys.self)
        // id:
        try container.encode(self.id, forKey: UserProfile.MainCodingKeys.id)
        
        // birthdate:
        try container.encode(self.birthDate, forKey: UserProfile.MainCodingKeys.birthDate)
        
        // names:
        try container.encode(self.names, forKey: UserProfile.MainCodingKeys.names)
        
        // gender :
        var genderContainer =  container.nestedContainer(keyedBy: GenderCodingKeys.self, forKey: UserProfile.MainCodingKeys.gender)
        try genderContainer.encode(self.gender, forKey: UserProfile.GenderCodingKeys.text)
        
        // address:
        var addrContainer =  container.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: UserProfile.MainCodingKeys.address)
        try addrContainer.encode(UserProfile.AddressResourceType, forKey: UserProfile.AddressCodingKeys.resourceType)
        try addrContainer.encode(self.address, forKey: UserProfile.AddressCodingKeys.text)
        
        // extensions: Transform it
        // Iterate over the extension array and then encode each extension struct
        var extnContainer = container.nestedContainer(keyedBy: ExtensionKeys.self, forKey: UserProfile.MainCodingKeys.extensions)
        for extensionVal in extensions {
            let key = extensionVal.key
            let value = extensionVal.value
            
            try extnContainer.encode(value, forKey: ExtensionKeys.init(stringValue: key)!)
        }
        
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
        print ("*****\n Decoded Native Representation \(myUser)")
        
        
        // Now encode this back
        let encoder = JSONEncoder.init()
        encoder.outputFormatting = .prettyPrinted
        let myUserData = try encoder.encode(myUser)
        
        let myUserDataStr = String.init(data: myUserData, encoding: .utf8)
        print("\n*****\n Encoded String Representation:  \(String(describing: myUserDataStr))")
        
    }
    catch {
        print("Error \(error.localizedDescription)")
    }
}

//: [Table of Contents](ToC) | [Previous](@previous) | [Next](@next)



//
//  File.swift
//  
//
//  Created by Juan Pedro Lozano Baño on 7/7/21.
//

import Foundation

enum UserDefaultKey: String, CaseIterable {
    case sampleRate
    case sampleRateTimestamp
    case rolleDiceValue
    case rolledDicedate
    case lastArchivedDate
    case debug
}

final class UserDefaultsHelper {
static func setData<T>(value: T, key: UserDefaultKey) {
   let defaults = UserDefaults.standard
   defaults.set(value, forKey: key.rawValue)
}
static func getData<T>(type: T.Type, forKey: UserDefaultKey) -> T? {
   let defaults = UserDefaults.standard
   let value = defaults.object(forKey: forKey.rawValue) as? T
   return value
}
static func removeData(key: UserDefaultKey) {
   let defaults = UserDefaults.standard
   defaults.removeObject(forKey: key.rawValue)
}
}

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}


extension UserDefaults {
    func decode<T : Codable>(for type : T.Type, using key : String) -> T? {
        let decoder = JSONDecoder()
        let defaults = UserDefaults.standard
        if let existing = defaults.object(forKey: key) as? Data{
            do {
                let loaded = try decoder.decode(type, from: existing)
                return loaded
            } catch (let error) {
                print(error)
            }
        }
        
        return nil
    }
    
    func encode<T : Codable>(for type : T, using key : String) {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(type)
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        } catch (let error) {
            print(error)

        }
    
    }
}

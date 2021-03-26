//
//  Answers.swift
//  What animal should i get?
//
//  Created by Tanya on 25.03.2021.
//

struct Answer: Decodable {
    let text: String
    let type: AnimalType
}

enum AnimalType: Character, Decodable {
    case cat = "🐈"
    case dog = "🐩"
    case mouse = "🦝"
    case fish = "🐠"
    
    enum CodingKeys: String, CodingKey {
        case codingCat = "cat"
        case codingDog = "dog"
        case codingMouse = "mouse"
        case codingFish = "fish"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if (try? container.decode(String.self, forKey: .codingCat)) != nil {
            self = .cat
            return
        }
        else if (try? container.decode(String.self, forKey: .codingDog)) != nil {
            self = .dog
            return
        }
        else if (try? container.decode(String.self, forKey: .codingFish)) != nil {
            self = .fish
            return
        }
        else if (try? container.decode(String.self, forKey: .codingMouse)) != nil {
            self = .mouse
            return
        }
        else {
            self = .cat
            return
        }
    }
    
    var definitionAnimal: String {
        switch self {
        case .cat:
            return "You are restrained and love freedom. You value not the quantity, but the quality of your friends"
        case .dog:
            return "You are friendly and open. You like to surround yourself with people and you are always ready to help"
        case .mouse:
            return "You are resourceful and elusive. You are always on the move and love to work hard"
        case .fish:
            return "You are calm and reasonable. You value consistency and comfort"
        }
    }
}


//
//  Questions.swift
//  What animal should i get?
//
//  Created by Tanya on 25.03.2021.
//

import Foundation
import Alamofire

struct Question: Decodable {
    let text: String
    let type: ResponseType
    let answers: [Answer]
}

enum ResponseType: String, Decodable {
    case single
    case multiple
    case ranged
}


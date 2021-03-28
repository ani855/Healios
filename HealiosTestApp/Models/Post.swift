//
//  Post.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/23/21.
//

import Foundation

struct Post {
    var id, userId: Int16
    var title, body: String?
    
    init(id: Int16, userId: Int16, title: String? = "", body: String? = "") {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}

extension Post: Decodable {
    
    enum Codingkeys: String, CodingKey {
        case id = "id"
        case userId = "userId"
        case title = "title"
        case body = "body"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Codingkeys.self)
        id = try container.decode(Int16.self, forKey: .id)
        userId = try container.decode(Int16.self, forKey: .userId)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
    }
}

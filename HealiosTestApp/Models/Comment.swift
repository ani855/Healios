//
//  Comment.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/23/21.
//

import Foundation

struct Comment {
    let id, postId: Int16
    let name, email, body: String?
    
    init(id: Int16, postId: Int16, name: String? = "", email: String? = "", body: String? = "") {
        self.id = id
        self.postId = postId
        self.name = name
        self.email = email
        self.body = body
    }
}

extension Comment: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case postId = "postId"
        case name = "name"
        case email = "email"
        case body = "body"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int16.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        postId = try container.decode(Int16.self, forKey: .postId)
        email = try container.decode(String.self, forKey: .email)
        body = try container.decode(String.self, forKey: .body)
    }
}

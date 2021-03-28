//
//  PostDetail.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/23/21.
//

import Foundation

struct User {
    var id: Int16
    var name, username, email, phone, website: String?
    var company: Company?
    var address: Address?
    
    init(id: Int16, name: String? = "", username: String? = "", email: String? = "", phone: String? = "", website: String? = "", company: Company, address: Address) {
        self.id = id
        self.username = username
        self.email = email
        self.phone = phone
        self.website = website
        self.company = company
        self.address = address
        self.name = name
    }
}

extension User: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case phone = "phone"
        case website = "website"
        case address = "address"
        case company = "company"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int16.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        website = try container.decode(String.self, forKey: .website)
        address = try container.decode(Address.self, forKey: .address)
        company = try container.decode(Company.self, forKey: .company)
    }
}

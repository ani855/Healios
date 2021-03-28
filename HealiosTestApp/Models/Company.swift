//
//  Company.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/23/21.
//

import Foundation

struct Company {
    let name, catchPhrase, bs: String?
    
    init(name: String? = "", catchPhrase: String? = "", bs: String? = "") {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}

extension Company: Decodable {
   
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case catchPhrase = "catchPhrase"
        case bs = "bs"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        catchPhrase = try container.decode(String.self, forKey: .catchPhrase)
        bs = try container.decode(String.self, forKey: .bs)
    }
}

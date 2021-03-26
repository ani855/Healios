//
//  API.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/25/21.
//

import Foundation

import Moya

enum API {
    case posts
    case comments
    case users
}

extension API: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "http://jsonplaceholder.typicode.com/") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .posts:
            return "posts"
        case .comments:
            return "comments"
        case .users:
            return "users"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var task: Task {
        return .requestPlain
    }

    public var validationType: ValidationType {
      return .successCodes
    }
}

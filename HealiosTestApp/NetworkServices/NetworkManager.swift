//
//  NetworkManager.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/25/21.
//

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<API> { get }
    func getPosts(completion: @escaping ([Post]?, Error?) -> ())
    func getComments(completion: @escaping ([Comment]?, Error?) -> ())
    func getUsers(completion: @escaping ([User]?, Error?) -> ())
}

struct NetworkManager: Networkable {
    var provider = MoyaProvider<API>()
    
    func getPosts(completion: @escaping ([Post]?, Error?) -> ()) {
        
        provider.request(.posts) { (result) in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode([Post].self, from: response.data)
                    completion(results, nil)
                }catch let error {
                    completion(nil, error)
                    print(error)
                }
            case let .failure(error):
                completion(nil, error)
                print(error)
            }
        }
    }
    
    func getComments(completion: @escaping ([Comment]?, Error?) -> ()) {
        
        provider.request(.comments) { (result) in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode([Comment].self, from: response.data)
                    completion(results, nil)
                }catch let error {
                    completion(nil, error)
                    print(error)
                }
            case let .failure(error):
                completion(nil, error)
                print(error)
            }
        }
    }
    
    func getUsers(completion: @escaping ([User]?, Error?) -> ()) {
        
        provider.request(.users) { (result) in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode([User].self, from: response.data)
                    completion(results, nil)
                }catch let error {
                    completion(nil, error)
                    print(error)
                }
            case let .failure(error):
                completion(nil, error)
                print(error)
            }
        }
    }
}

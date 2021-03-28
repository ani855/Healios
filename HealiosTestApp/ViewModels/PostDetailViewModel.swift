//
//  PostDetailViewModel.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/24/21.
//

import Foundation
import CoreData

class PostDetailViewModel: NSObject {
    
    // MARK: - Properties
    private(set) var post: Post?
    private(set) var postUser: User?
    private(set) var postComments: [Comment]?
    private var users: [User]?
    private var comments: [Comment]?
    private var cdHandler: CDHandler?
    private var apiHandler: APIHandler?
    
    // MARK: - Lifecycle
    override init() {
        super.init()
    }
    
    init(post: Post) {
        super.init()
        self.post = post
    }
    
    // MARK: - Methods
    
    func getPostDetail(completion: @escaping ([User]?,[Comment]?, Error?) -> ()) {
        cdHandler = CDHandler()
        cdHandler?.fetchUsersFromCoreData(completion: { (users, isSucceed) in
            if isSucceed {
                self.users = users
                self.cdHandler?.fetchCommentsFromCoreData(completion: { (comments, isSucceed) in
                    if isSucceed {
                        self.comments = comments
                        self.filterComments()
                        self.filterPostUser()
                        completion(users, comments, nil)
                    }else{
                        
                    }
                })
            }else {
                self.apiHandler = APIHandler()
                self.apiHandler?.getPostDetailData(completion: { (users, comments, error) in
                    guard let _ = users, let _ = comments else {
                        completion(nil, nil, error)
                        return
                    }
                    self.users = users!
                    self.comments = comments!
                    self.cdHandler?.saveUsersInCoreDataWith(users: self.users!)
                    self.cdHandler?.saveCommentsInCoreDataWith(comments: self.comments!)
                    self.filterComments()
                    self.filterPostUser()
                    completion(users, comments, nil)
                })
            }
        })
    }
    
    func filterComments() {
        postComments = comments?.filter{ $0.postId == post?.id }
    }
    
    func filterPostUser() {
        postUser = users?.filter{ $0.id == post?.userId }.first
    }
}

fileprivate class APIHandler {
    
    // MARK: - Properties
    private var networkProvider: NetworkManager = NetworkManager()
    
    // MARK: - Methods
    func getPostDetailData(completion: @escaping ([User]?, [Comment]?, Error?) -> ()) {
        networkProvider.getUsers { (users, error) in
            var resultUsers = [User]()
            var resultComment = [Comment]()
            
            guard let _ = error else {
                if let _ = users {
                    resultUsers = users!
                    self.getComments { (comments, error) in
                        guard let _ = error else {
                            resultComment = comments!
                            completion(resultUsers, resultComment, nil)
                            return
                        }
                        completion(nil, nil, error)
                    }
                }
                return
            }
            completion(nil, nil, error)
        }
    }
    
    func getComments(completion: @escaping ([Comment]?, Error?) -> ()) {
        
        self.networkProvider.getComments { (comments, error) in
            guard let _ = error else {
                completion(comments, nil)
                return
            }
            completion(nil, error)
        }
    }
}

fileprivate class CDHandler {
    
    // MARK: - Users Methods
    private func createUsersEntityFrom(resultUser: User) -> NSManagedObject? {
        
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let user = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context) as? UserEntity {
            
            user.id = resultUser.id
            user.username = resultUser.username
            user.email = resultUser.email
            user.phone = resultUser.phone
            user.website = resultUser.website
            user.name = resultUser.name
            
            if let company = NSEntityDescription.insertNewObject(forEntityName: "CompanyEntity", into: context) as? CompanyEntity {
                company.bs = resultUser.company?.bs
                company.catchPhrase = resultUser.company?.catchPhrase
                company.name = resultUser.company?.name
                user.company = company
            }
            
            if let address = NSEntityDescription.insertNewObject(forEntityName: "AddressEntity", into: context) as? AddressEntity {
                address.street = resultUser.address?.street
                address.suite = resultUser.address?.suite
                address.zipcode = resultUser.address?.zipcode
                address.city = resultUser.address?.city
                if let geoLocation = NSEntityDescription.insertNewObject(forEntityName: "GeoLocationEntity", into: context) as? GeoLocationEntity {
                    address.geoLocation?.latitude = geoLocation.latitude
                    address.geoLocation?.longitude = geoLocation.longitude
                    address.geoLocation = geoLocation
                }
                user.address = address
            }
            return user
        }
        return nil
    }
    
    func saveUsersInCoreDataWith(users: [User]) {
            _ = users.map{self.createUsersEntityFrom(resultUser: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }

    func fetchUsersFromCoreData(completion: @escaping ([User]?, _ isSucceed: Bool) -> ()) {

        var CDUsers = [User]()
        let postsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        do {
            let fetchedUsers = try CoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(postsFetch) as! [UserEntity]
            for userEntity in fetchedUsers {
                
                let company: Company = Company(name: userEntity.company?.name, catchPhrase: userEntity.company?.catchPhrase, bs: userEntity.company?.bs)
                let address:Address = Address(street: userEntity.address?.street, suite: userEntity.address?.suite, zipcode: userEntity.address?.zipcode, city: userEntity.address?.city)
                
                CDUsers.append(User(id: userEntity.id, name: userEntity.name, username: userEntity.username, email: userEntity.email, phone: userEntity.phone, website: userEntity.website, company:company, address: address))
            }
            if CDUsers.count < 1 {
                completion(nil, false)
            }
            completion(CDUsers, true)
        } catch {
            completion(nil, false)
        }
    }

    // MARK: - Comments Methods
    private func createCommentsEntityFrom(resultComment: Comment) -> NSManagedObject? {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let comment = NSEntityDescription.insertNewObject(forEntityName: "CommentEntity", into: context) as? CommentEntity {
            
            comment.id = resultComment.id
            comment.postId = resultComment.postId
            comment.name = resultComment.name
            comment.email = resultComment.email
            comment.body = resultComment.body
            
            return comment
        }
        return nil
    }
    
    func saveCommentsInCoreDataWith(comments: [Comment]) {
            _ = comments.map{self.createCommentsEntityFrom(resultComment: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func fetchCommentsFromCoreData(completion: @escaping ([Comment]?, _ isSucceed: Bool) -> ()) {
        
        var CDComments = [Comment]()
        let postsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CommentEntity")
        do {
            let fetchedComments = try CoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(postsFetch) as! [CommentEntity]
            for commentEntity in fetchedComments {
                
                CDComments.append(Comment(id: commentEntity.id, postId: commentEntity.postId, name: commentEntity.name, email: commentEntity.email, body: commentEntity.body))
            }
            if CDComments.count < 1 {
                completion(nil, false)
            }
            completion(CDComments, true)
        } catch {
            completion(nil, false)
        }
    }
}

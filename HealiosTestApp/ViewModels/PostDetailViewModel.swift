//
//  PostDetailViewModel.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/24/21.
//

import Foundation

class PostDetailViewModel: NSObject {
    
    // MARK: - Properties
    private var networkProvider: NetworkManager!
    private(set) var post: Post?
    private(set) var postUser: User?
    private(set) var postComments: [Comment]?
    private var users: [User]?
    private var comments: [Comment]?
    
    // MARK: - Closures
    var bindPostsDetailViewModelToController : ((Error?) -> ()) = {_ in }
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        setInit()
    }
    
    init(post: Post) {
        super.init()
        self.post = post
        setInit()
    }
    
    // MARK: - Methods
    func setInit() {
        networkProvider = NetworkManager()
        getPostDetailData()
    }
    
    func getPostDetailData() {
        networkProvider.getUsers { (users, error) in
            guard error != nil else {
                if let _ = users {
                    self.users = users
                    self.getComments()
                }
                return
            }
            self.bindPostsDetailViewModelToController(error)
        }
    }
    
    func getComments() {
        
        self.networkProvider.getComments { (comments, error) in
            guard error != nil else {
                self.comments = comments
                self.filterComments()
                self.filterPostUser()
                self.bindPostsDetailViewModelToController(nil)
                return
            }
            self.bindPostsDetailViewModelToController(error)
        }
    }
    
    func filterComments() {
        postComments = comments?.filter{ $0.postId == post?.id }
    }
    
    func filterPostUser() {
        postUser = users?.filter{ $0.id == post?.userId }.first
    }
}

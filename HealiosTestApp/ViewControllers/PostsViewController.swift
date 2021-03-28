//
//  ViewController.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/23/21.
//

import UIKit
import NVActivityIndicatorView

class PostsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var postsTableView: UITableView!
    
    // MARK: - Properties
    var viewModel: PostsViewModel!
    private var dataSource: TableViewDataSource<PostTableViewCell, Post>!
    private var delegate: TableViewDelegate!
    private var activityIndicator: NVActivityIndicatorView?
    
   
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        updateUIByViewModel()
    }

    // MARK: - Methods
    func setUpView() {
        self.title = "Posts"
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: 200, width: 50, height: 150), type: .ballClipRotate, color: .systemOrange, padding: nil)
        self.view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    
    func updateUIByViewModel() {
        viewModel = PostsViewModel()
        viewModel.getPostsData { (posts, error) in
            if error != nil {
                self.presentAlert(withTitle: "Server Error", message: error?.localizedDescription ?? "Something went wrong")
                self.activityIndicator?.stopAnimating()
                return
            }else{
                self.updateDataSource()
            }
        }
    }
    
    func updateDataSource() {
        self.delegate = TableViewDelegate()
        self.dataSource = TableViewDataSource(cellIdentifier: "PostTableViewCell", items: self.viewModel.posts, configureCell: { (cell, post) in
            cell.titleLabel.text = post.title
            cell.bodyLabel.text = post.body
        })

        DispatchQueue.main.async {
            let nib = UINib(nibName: "PostTableViewCell",bundle: nil)
            self.postsTableView.register(nib, forCellReuseIdentifier: "PostTableViewCell")
            self.postsTableView.dataSource = self.dataSource
            self.postsTableView.delegate = self.delegate
            self.delegate.cellSelectedInIndexPath = { (index) -> () in
                self.openDetailPageBy(index: index)
            }
            self.postsTableView.reloadData()
            self.activityIndicator?.stopAnimating()
        }
    }
    
    func openDetailPageBy(index: Int) {
        
        let postDetailviewModel: PostDetailViewModel = PostDetailViewModel(post: self.viewModel.posts[index])
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postDetailViewController: PostDetailViewController = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController 
        
        postDetailViewController.viewModel = postDetailviewModel
        self.navigationController?.pushViewController(postDetailViewController, animated: true)
    }
}


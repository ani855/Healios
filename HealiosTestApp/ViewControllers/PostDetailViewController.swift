//
//  PostDetailViewController.swift
//  HealiosTestApp
//
//  Created by Ani Klekchyan on 3/24/21.
//

import UIKit
import NVActivityIndicatorView

class PostDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
 
    @IBOutlet weak var postDetailTableView: UITableView!
    
    // MARK: - Properties
    var viewModel: PostDetailViewModel = PostDetailViewModel()
    private var dataSource: TableViewDataSource<CommentTableViewCell, Comment>!
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
        self.title = "Post Detail"
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: 200, width: 50, height: 150), type: .ballClipRotate, color: .systemOrange, padding: nil)
        self.view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    
    func createHeaderView() -> PostDetailHeaderView {
        
        let headerView: PostDetailHeaderView = .fromNib()
        headerView.bodyLabel.text = viewModel.post?.body
        headerView.titleLabel.text = viewModel.post?.title
        headerView.userNameLabel.text = self.viewModel.postUser?.name
        return headerView
    }
    
    func updateUIByViewModel() {
        viewModel.bindPostsDetailViewModelToController = { error in
            guard error == nil else {
                self.presentAlert(withTitle: "Server Error", message: error?.localizedDescription ?? "Something went wrong")
                self.activityIndicator?.stopAnimating()
                return
            }
            self.updateDataSource()
        }
    }
    
    func updateDataSource() {
        
        if let _ = self.viewModel.postComments {
            self.dataSource = TableViewDataSource(cellIdentifier: "CommentTableViewCell", items: self.viewModel.postComments!, configureCell: { (cell, comment) in
                cell.nameLabel.text = comment.name
                cell.emailLabel.text = comment.email
                cell.commentLabel.text = comment.body
            })

            DispatchQueue.main.async {
                let nib = UINib(nibName: "CommentTableViewCell",bundle: nil)
                self.postDetailTableView.register(nib, forCellReuseIdentifier: "CommentTableViewCell")
                self.postDetailTableView.dataSource = self.dataSource
                self.postDetailTableView.delegate = self.delegate
                self.postDetailTableView.setTableHeaderView(headerView: self.createHeaderView())
                self.postDetailTableView.reloadData()
                self.activityIndicator?.stopAnimating()
            }
        }
    }
}

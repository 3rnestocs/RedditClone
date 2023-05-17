//
//  HomeViewController.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 15/5/23.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - Properties
    private let viewModel = HomeViewModel()
    private var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: - Setup
    private func setup() {
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupData() {
        showActivityIndicator()
        viewModel.didFailed = { error in
            if let error = error {
                print("T3ST", error)
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            self.hideActivityIndicator()
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .red
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: .plain, target: nil, action: nil)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: HomeTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: HomeTableViewCell.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func showActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        loadingView.isHidden = false
        let frameSize: CGPoint = CGPoint(
            x: UIScreen.main.bounds.size.width * 0.5,
            y: UIScreen.main.bounds.size.height * 0.5
        )
        activityIndicatorView?.center = frameSize
        self.view.addSubview(activityIndicatorView!)
        self.view.bringSubviewToFront(activityIndicatorView!)
        activityIndicatorView?.startAnimating()
    }
    
    private func hideActivityIndicator() {
        if activityIndicatorView != nil {
            activityIndicatorView?.stopAnimating()
            activityIndicatorView = nil
            loadingView.isHidden = true
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getPosts().count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.cellIdentifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == viewModel.getPosts().count {
            viewModel.paginate()
            let loadingCell = UITableViewCell()
            loadingCell.addIndicator()
            return loadingCell
        } else {
            cell.setupCell(post: viewModel.getPosts()[indexPath.row])
            return cell
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == viewModel.getPosts().count + 1 {
            return 40
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = getVC(.detailVC) as? DetailViewController else {
            return
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
        detailVC.setupViewModel(with: viewModel.getPosts()[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

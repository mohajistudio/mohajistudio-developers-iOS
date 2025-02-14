//
//  BlogViewController.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/6/25.
//

import UIKit

class BlogViewController: UIViewController {
    
    private let blogView = BlogView()
    private let viewModel: BlogViewModel

    init(viewModel: BlogViewModel = BlogViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "Bg 1")
        
        blogView.delegate = self
        
        blogView.blogTableView.delegate = self
        blogView.blogTableView.dataSource = self
        
        

    }
    
    override func loadView() {
        view = blogView
    }

}

extension BlogViewController: BlogViewDelegate {
    
    func didSearch(_ query: String) {
        viewModel.filterPosts(by: query)
    }
    
    func didSelectTag(_ tag: String) {
        viewModel.filterPosts(byTag: tag)
    }
    
}

extension BlogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        
        let tag = viewModel.tags[indexPath.item]
        cell.configure(with: tag)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTag = viewModel.tags[indexPath.item]
        print("\(selectedTag) tag tap !")
        blogView.delegate?.didSelectTag(selectedTag)
    }
    
}

extension BlogViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        
        cell.configure(title: viewModel.title, date: viewModel.date, tag: viewModel.postTags)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeTableViewHeaderView.identifier) as? HomeTableViewHeaderView else {
            return nil
        }
        
        header.tagCollectionView.delegate = self
        header.tagCollectionView.dataSource = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

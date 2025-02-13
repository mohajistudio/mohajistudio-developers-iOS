//
//  HomeViewController.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/6/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let sideMenuView = SideMenuView()
    private let viewModel: HomeViewModel

    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(homeView)
        homeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(sideMenuView)
        sideMenuView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        homeView.delegate = self
        sideMenuView.getMenuView().delegate = self
        
        homeView.homeTableView.delegate = self
        homeView.homeTableView.dataSource = self
        
        print("Tags count: \(viewModel.tags.count)")

    }
    
    @objc func handleMenuToggle() {
        sideMenuView.toggleMenu()
    }
    
}

extension HomeViewController: HomeViewDelegate {
    
    func homeViewDidTapSideMenu() {
        print("sideMenu Tap")
        handleMenuToggle()
    }
    
    func didSearch(_ query: String) {
        viewModel.filterPosts(by: query)
    }
    
    func didSelectTag(_ tag: String) {
        viewModel.filterPosts(byTag: tag)
    }
    
//    func homeViewDidTapLogin() {
//        print("homeViewDidTapLogin 탭")
//        
//        let loginViewModel = LoginViewModel()
//        let vc = LoginViewController(viewModel: loginViewModel)
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.setNavigationBarHidden(true, animated: false)
//        
////        loginViewModel.loginSuccess = { [weak self] in
////            self?.dismiss(animated: true)
////            // 로그인 후 필요한 처리
////        }
//        
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true)
//    }
    
    
    
    func homeViewDidTapPost() {
        print("post 버튼 tap")
        let profileDetailViewModel = ProfileDetailViewModel()
        let vc = ProfileDetailTabViewController(viewModel: profileDetailViewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        homeView.delegate?.didSelectTag(selectedTag)
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(title: viewModel.title, date: viewModel.date, tag: viewModel.postTags)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetailVC = PostDetailViewController()
        self.present(postDetailVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let tableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeTableViewHeaderView.identifier) as? HomeTableViewHeaderView else {
            return nil
        }
        
        tableViewHeaderView.tagCollectionView.delegate = self
        tableViewHeaderView.tagCollectionView.dataSource = self
        
        return tableViewHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension HomeViewController: MenuViewDelegate {
    func didTapCloseButton() {
        sideMenuView.toggleMenu()
    }
}

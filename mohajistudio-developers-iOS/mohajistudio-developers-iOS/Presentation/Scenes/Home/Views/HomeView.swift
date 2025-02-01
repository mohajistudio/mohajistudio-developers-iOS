//
//  HomeView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/12/25.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    func homeViewDidTapLogin()
    func didSearch(_ query: String)
    func didSelectTag(_ tag: String)
}

class HomeView: UIView {

    weak var delegate: HomeViewDelegate?
    private let tableViewHeaderView = HomeTableViewHeaderView()
    
    var tagCollectionView: UICollectionView {
        return tableViewHeaderView.tagCollectionView
    }
    
    let headerView = UIView().then {
        $0.backgroundColor = UIColor(named: "Bg 1")
    }
    
    private let logo = UIImageView().then {
        $0.image = UIImage(named: "Logo")
    }
    
    private let postButton = UIButton().then {
        $0.setImage(UIImage(named: "Post"), for: .normal)
        $0.tintColor = UIColor(named: "Primary")
    }
    
    private let loginButton = UIButton().then {
        $0.setImage(UIImage(named: "Menu"), for: .normal)
        $0.tintColor = UIColor(named: "Primary")
    }
    
    let homeTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        $0.register(HomeTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeTableViewHeaderView.identifier)
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 370
        $0.rowHeight = UITableView.automaticDimension
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupActions()
        hideKeyboardWhenTappedBackground()
        tableViewHeaderView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    // MARK: - UI 설정
    
    private func setupUI() {
        backgroundColor = UIColor(named: "Bg 1")
        
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        
        addSubview(headerView)
        
        headerView.addSubview(logo)
        headerView.addSubview(postButton)
        headerView.addSubview(loginButton)
        
        addSubview(homeTableView)
    }
    
    private func setupConstraints() {
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        logo.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        postButton.snp.makeConstraints {
            $0.trailing.equalTo(loginButton.snp.leading).offset(-24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        homeTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    @objc private func didTapLoginButton() {
        delegate?.homeViewDidTapLogin()
    }
}

extension HomeView: HomeTableViewHeaderViewDelegate {
    func didSearch(_ query: String) {
        delegate?.didSearch(query)
    }
    
    func didSelectTag(_ tag: String) {
        delegate?.didSelectTag(tag)
    }
    
    
}

extension HomeView {
    func hideKeyboardWhenTappedBackground() {
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapEvent.cancelsTouchesInView = false
        addGestureRecognizer(tapEvent)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}

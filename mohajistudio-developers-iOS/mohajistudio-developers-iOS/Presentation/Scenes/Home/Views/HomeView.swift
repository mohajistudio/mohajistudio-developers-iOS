//
//  HomeView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/12/25.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    func homeViewDidTapLogin()
    func homeView(_ view: HomeView, didSearch query: String)
    func homeView(_ view: HomeView, didSelectTag tag: String)
}

class HomeView: BaseView {

    weak var delegate: HomeViewDelegate?
    
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
    
    private let searchHeaderView = HeaderWithIconView().then {
        $0.configure(iconName: "Search", headerTitle: "Search")
    }
    
    private let searchView = UIView().then {
        $0.backgroundColor = UIColor(named: "Bg 2")
        $0.layer.cornerRadius = 8
        $0.isUserInteractionEnabled = true
    }
    
    private let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.backgroundColor = .clear
        $0.searchTextField.borderStyle = .none
        $0.searchTextField.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.searchTextField.backgroundColor = .clear
        $0.searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "Gray 3")])
        $0.searchTextField.leftView = nil
        $0.searchTextField.leftViewMode = .never
        $0.isUserInteractionEnabled = true
    }
    
    private let tagHeaderView = HeaderWithIconView().then {
        $0.configure(iconName: "Tag", headerTitle: "Tags")
    }
    
    let tagCollectionView: UICollectionView = {
        let layout = TagFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.allowsMultipleSelection = true
        
        return cv
    }()

    private let postHeaderView = HeaderWithIconView().then {
        $0.configure(iconName: "File", headerTitle: "All Post")
    }
    
    let postTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 370
        $0.rowHeight = UITableView.automaticDimension
        $0.isScrollEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupActions()
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
        headerView.addSubview(logo)
        headerView.addSubview(postButton)
        headerView.addSubview(loginButton)
        
        contentView.addSubview(searchHeaderView)
        contentView.addSubview(searchView)
        searchView.addSubview(searchBar)
        
        contentView.addSubview(tagHeaderView)
        contentView.addSubview(tagCollectionView)
        
        contentView.addSubview(postHeaderView)
        contentView.addSubview(postTableView)
    }
    
    private func setupConstraints() {
        
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
        
        searchHeaderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(28)
            $0.height.equalTo(24)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(searchHeaderView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        searchBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tagHeaderView.snp.makeConstraints {
            $0.leading.trailing.equalTo(searchHeaderView)
            $0.top.equalTo(searchBar.snp.bottom).offset(40)
            $0.height.equalTo(24)
        }
        
        tagCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(searchHeaderView)
            $0.top.equalTo(tagHeaderView.snp.bottom).offset(12)
            $0.height.equalTo(150)
        }
        
        postHeaderView.snp.makeConstraints {
            $0.leading.trailing.equalTo(searchHeaderView)
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(40)
            $0.height.equalTo(24)
        }
        
        postTableView.snp.makeConstraints {
            $0.leading.trailing.equalTo(searchHeaderView)
            $0.top.equalTo(postHeaderView.snp.bottom).offset(12)
            $0.height.equalTo(1200)
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(postTableView.snp.bottom).offset(24)
        }
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        searchBar.delegate = self
    }
    
    @objc private func didTapLoginButton() {
        delegate?.homeViewDidTapLogin()
    }
}

extension HomeView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.homeView(self, didSearch: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchButtonClicked")
        searchBar.resignFirstResponder()
    }
}

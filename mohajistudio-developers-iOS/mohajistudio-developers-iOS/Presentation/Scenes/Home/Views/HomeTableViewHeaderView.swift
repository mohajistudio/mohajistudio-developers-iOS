//
//  HomeTableViewHeaderView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/1/25.
//

import UIKit

protocol HomeTableViewHeaderViewDelegate: AnyObject {
    func didSearch(_ query: String)
    func didSelectTag(_ tag: String)
}

class HomeTableViewHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "HomeTableViewHeaderView"
    
    weak var delegate: HomeTableViewHeaderViewDelegate?

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
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(named: "Bg 1")
        
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(searchHeaderView)
        contentView.addSubview(searchView)
        searchView.addSubview(searchBar)
        
        contentView.addSubview(tagHeaderView)
        contentView.addSubview(tagCollectionView)
        contentView.addSubview(postHeaderView)  // contentView에 추가
    }
    
    private func setupConstraints() {
        
        
        searchHeaderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(40)
            $0.height.equalTo(24)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(searchHeaderView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(searchHeaderView)
            $0.height.equalTo(40)
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()  // 중앙 정렬로 변경
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
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(28)
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
    }
    
    private func setupActions() {
        searchBar.delegate = self
    }

}

extension HomeTableViewHeaderView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didSearch(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchButtonClicked")
        searchBar.resignFirstResponder()
    }
}

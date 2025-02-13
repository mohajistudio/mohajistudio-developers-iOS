//
//  BlogView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/10/25.
//

import UIKit

protocol BlogViewDelegate: AnyObject {
    func didSearch(_ query: String)
    func didSelectTag(_ tag: String)
}

class BlogView: UIView {
    
    weak var delegate: BlogViewDelegate?
    
    private let topDivider = UIView().then {
        $0.backgroundColor = UIColor(named: "Bg 2")
    }
    
    let blogTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        $0.register(HomeTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeTableViewHeaderView.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
    }
    
    private let reusedHeaderView = HomeTableViewHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        reusedHeaderView.delegate = self
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setupUI() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        addSubview(topDivider)
        addSubview(blogTableView)
    }
    
    private func setupConstraints() {
        
        topDivider.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        blogTableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(topDivider.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }

}

extension BlogView: HomeTableViewHeaderViewDelegate {
    func didSearch(_ query: String) {
        delegate?.didSearch(query)
    }
    
    func didSelectTag(_ tag: String) {
        delegate?.didSelectTag(tag)
    }
    
    
}

//
//  BlogTableViewHeaderView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/3/25.
//

import UIKit

class BlogTableViewHeaderView: UITableViewHeaderFooterView {

    private let reusedHeader = HomeTableViewHeaderView()
    private let profileView = UIView()
    
    private let profileImage = UIImageView().then {
        $0.backgroundColor = UIColor.gray
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "Black")
    }
    
    private let roleLabel = UILabel().then {
        $0.text = "Developer"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "Gray 3")
    }

    private let introduceLabel = UILabel().then {
        $0.text = "iOS 앱 개발 지망생의 블로그입니다.\n개발 과정에서 배운 것들을 기록합니다."
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "Gray 1")
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
        backgroundColor = UIColor(named: "Bg 1")
        
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(profileView)
        contentView.addSubview(reusedHeader)

        
        profileView.addSubview(profileImage)
        profileView.addSubview(introduceLabel)
    }
    
    private func setupConstraints() {
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.bottom.equalTo(introduceLabel.snp.bottom).offset(40)
        }
        
        profileImage.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(40)
            $0.width.height.equalTo(76)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(profileImage.snp.bottom).offset(16)
        }
        
    }
    
    private func setupActions() {
        
    }

}


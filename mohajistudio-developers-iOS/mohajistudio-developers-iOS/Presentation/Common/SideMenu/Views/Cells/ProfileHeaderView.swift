//
//  ProfileHeaderView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/13/25.
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {

    static let identifier = "ProfileHeaderView"
    
    private let thumbnailImage = UIImageView().then {
        $0.image = UIImage(named: "TempProfileImage") // 임시 프로필 이미지
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "Name"
        $0.textColor = UIColor(named: "Black")
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
    }
    
    private let roleLabel = UILabel().then {
        $0.text = "Developer"
        $0.textColor = UIColor(named: "Gray 3")
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = UIColor(named: "Bg 2")
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
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(roleLabel)
        contentView.addSubview(separatorView)
    }
    
    private func setupConstraints() {
        thumbnailImage.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(44)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(thumbnailImage.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        roleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        separatorView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func setupActions() {
        
    }

    func configure(user: User) {
        nameLabel.text = user.nickname
        roleLabel.text = user.role
    }
    
}

//
//  ProfileHeaderView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/13/25.
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "ProfileHeaderView"
    
    var onLoginTapped: (() -> Void)?
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "Default_profile") // 임시 프로필 이미지
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "Name"
        $0.textColor = UIColor(named: "Black")
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
    }
    
    private let roleLabel = UILabel().then {
        $0.text = "Developer"
        $0.textColor = UIColor(named: "Gray 3")
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(UIColor(named: "Primary"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
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
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(roleLabel)
        contentView.addSubview(loginButton)
        contentView.addSubview(separatorView)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(44)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        roleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        loginButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
        
        separatorView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    @objc private func didTapLoginButton() {
        onLoginTapped?()
    }

    func configureForGuest() {
        profileImageView.image = UIImage(systemName: "person")?.withTintColor((UIColor(named: "Primary")!))
        nameLabel.text = "로그인이 필요합니다"
        roleLabel.text = ""
        loginButton.isHidden = false
    }
    
    func configure(user: SimpleUserInfo) {
        print("유저 정보 업데이트 - 사이드 메뉴")
        if let profileImage = user.profileImage {
            // 이미지 로딩 로직
        } else {
            profileImageView.image = UIImage(named: "Default_profile")
        }
        
        nameLabel.text = user.nickname
        roleLabel.text = user.role
        loginButton.isHidden = true
    }
    
}

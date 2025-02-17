//
//  ProfileView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/7/25.
//

import UIKit

class ProfileView: UIView {

    private let scrollView = UIScrollView()
    
    private let contentView = UIView().then {
        $0.backgroundColor = UIColor(named: "Bg 1")
    }
    
    private let topDivider = UIView().then {
        $0.backgroundColor = UIColor(named: "Bg 2")
    }
    
    private let profileHeaderView = HeaderWithIconView().then {
        $0.configure(iconName: "User", headerTitle: "Profile")
    }
    
    private let profileBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(named: "Surface 1")
        $0.layer.cornerRadius = 16
    }
    
    private let nameLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.text = "Name"
        $0.textColor = UIColor(named: "Black")
        $0.textAlignment = .left
    }
    
    private let roleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.text = "Developer"
        $0.textColor = UIColor(named: "Gray 3")
        $0.textAlignment = .left
    }
    
    private let introduceLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "Gray 1")
        $0.text = "Introduce"
        $0.textAlignment = .left
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "TempProfileImage")
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let contactHeaderView = HeaderWithIconView().then {
        $0.configure(iconName: "Contact", headerTitle: "Contact")
    }
    
    private let contactsView = ContactsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(topDivider)
        contentView.addSubview(profileHeaderView)
        
        contentView.addSubview(profileBackgroundView)
        profileBackgroundView.addSubview(profileImageView)
        profileBackgroundView.addSubview(nameLabel)
        profileBackgroundView.addSubview(roleLabel)
        profileBackgroundView.addSubview(introduceLabel)
        
        contentView.addSubview(contactHeaderView)
        contentView.addSubview(contactsView)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        
        topDivider.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        profileHeaderView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(40)
            $0.height.equalTo(24)
        }
        
        profileBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(profileHeaderView.snp.bottom).offset(12)
            $0.bottom.equalTo(introduceLabel.snp.bottom).offset(32)
        }
        
        profileImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(profileImageView)
        }
        
        roleLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(nameLabel)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(roleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(roleLabel)
        }
        
        contactHeaderView.snp.makeConstraints {
            $0.top.equalTo(profileBackgroundView.snp.bottom).offset(40)
            $0.horizontalEdges.equalTo(profileHeaderView)
            $0.height.equalTo(24)
        }
        
        contactsView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contactHeaderView)
            $0.top.equalTo(contactHeaderView.snp.bottom).offset(12)
            $0.bottom.equalTo(contactsView.getContactStackView().snp.bottom).offset(20)
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(contactsView.snp.bottom).offset(20)
        }
    }
    
    func configure(userDetail: UserDetailResponse, contacts: [Contact]) {
        // profileImageView에 프로필 이미지 링크 메서드
        nameLabel.text = userDetail.nickname
        roleLabel.text = userDetail.role
        introduceLabel.text = userDetail.bio
        
        contactsView.configure(contacts: contacts)
        
        guard let profileImageUrl = userDetail.profileImageUrl, profileImageUrl != "" else {
            profileImageView.image = UIImage(named: "Default_profile")
            return
        }
        
    }
    
}

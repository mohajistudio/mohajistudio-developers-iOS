//
//  ProfileView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/7/25.
//

import UIKit
import SnapKit

class ProfileView: UIView {

    private var isEditMode: Bool = false
    
    private var dynamicButtonHeightConstraint: Constraint?
    
    private let profileCardView = ProfileCardView()
    
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
    
    private let editModeButton = UIButton().then {
        $0.setImage(UIImage(named: "Post_edit"), for: .normal)
        $0.tintColor = UIColor(named: "Primary")
    }
    
    private let profileBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(named: "Surface 1")
        $0.layer.cornerRadius = 16
    }
    
    private let contactHeaderView = HeaderWithIconView().then {
        $0.configure(iconName: "Contact", headerTitle: "Contact")
    }
    
    private let contactsView = ContactsView()
    
    private let dynamicButtonView = UIView() // 취소 저장 버튼을 담을 뷰
    
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.backgroundColor = UIColor(named: "Surface 1")
        $0.setTitleColor(UIColor(named: "Gray 1"), for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    private let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.backgroundColor = UIColor(named: "Success")
        $0.setTitleColor(UIColor(named: "white"), for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    private let deleteAccountBlock = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let deleteAccountHeaderView = HeaderWithIconView().then {
        $0.configure(iconName: "Logout", headerTitle: "Delete Account")
    }
    
    private let deleteAccountButton = UIButton().then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(UIColor(named: "Error"), for: .normal)
        $0.backgroundColor = UIColor(named: "Surface 1")
    }
    
    private let bottomStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 40
        $0.distribution = .fill
    }
    
    private var originalUserInfo: (name: String, career: String, bio: String)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupAction()
        
        profileCardView.setViewMode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setupUI() {
        setupHierarchy()
        setupConstraints()
        setupBottomStackView()
    }
    
    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(topDivider)
        contentView.addSubview(profileHeaderView)
        contentView.addSubview(editModeButton)
        
        contentView.addSubview(profileBackgroundView)
        profileBackgroundView.addSubview(profileCardView)
        
        contentView.addSubview(contactHeaderView)
        contentView.addSubview(contactsView)
        
        contentView.addSubview(bottomStackView)
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
        
        editModeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(profileHeaderView)
            $0.size.equalTo(24)
        }
        
        profileBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(profileHeaderView.snp.bottom).offset(12)
            $0.bottom.equalTo(profileCardView.snp.bottom)
        }
        
        profileCardView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        contactHeaderView.snp.makeConstraints {
            $0.top.equalTo(profileBackgroundView.snp.bottom).offset(40)
            $0.horizontalEdges.equalTo(profileHeaderView)
            $0.height.equalTo(24)
        }
        
        contactsView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contactHeaderView)
            $0.top.equalTo(contactHeaderView.snp.bottom).offset(12)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(contactsView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(bottomStackView.snp.bottom).offset(20)
        }
    }
    
    func setupBottomStackView() {
        
        dynamicButtonView.addSubview(saveButton)
        dynamicButtonView.addSubview(cancelButton)
        
        bottomStackView.addArrangedSubview(dynamicButtonView)
        bottomStackView.addArrangedSubview(deleteAccountBlock)
        
        dynamicButtonView.snp.makeConstraints {
            dynamicButtonHeightConstraint = $0.height.equalTo(0).constraint
            $0.horizontalEdges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalTo(dynamicButtonView.snp.centerX).offset(-4)
        }
        
        saveButton.snp.makeConstraints {
            $0.leading.equalTo(dynamicButtonView.snp.centerX).offset(4)
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        saveButton.isHidden = true
        cancelButton.isHidden = true
        
        deleteAccountBlock.addSubview(deleteAccountHeaderView)
        deleteAccountBlock.addSubview(deleteAccountButton)
        
        deleteAccountHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.top.equalTo(deleteAccountHeaderView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    private func setupAction() {
        editModeButton.addTarget(self, action: #selector(didTapEditModeButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    }
    
    @objc private func didTapEditModeButton() {
        profileCardView.toggleCurrentMode()
        editModeButton.isHidden = true
        
        saveButton.isHidden = false
        cancelButton.isHidden = false
        
        dynamicButtonHeightConstraint?.update(offset: 32)
        
        let userInfo = profileCardView.getEditedUserInfo()
        originalUserInfo = userInfo
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func didTapSaveButton() {
        self.profileCardView.toggleCurrentMode()
        self.editModeButton.isHidden = false
        
        saveButton.isHidden = true
        cancelButton.isHidden = true
        dynamicButtonHeightConstraint?.update(offset: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        
        // 수정된 사용자 정보 가져와 UI 반영
        let editedInfo = profileCardView.getEditedUserInfo()
        // 이후 업데이트 로직 수행
    }
    
    @objc private func didTapCancelButton() {
        self.profileCardView.toggleCurrentMode()
        self.editModeButton.isHidden = false
        
        saveButton.isHidden = true
        cancelButton.isHidden = true
        
        dynamicButtonHeightConstraint?.update(offset: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        // 수정 취소니 이전 값 다시 돌려주는 로직 필요. 에딧 모드로 전환 시 기존 값 따로 저장해둬야함.
        if let originalUserInfo = originalUserInfo {
            profileCardView.configureUserInfo(name: originalUserInfo.name,
                                              career: originalUserInfo.career,
                                              bio: originalUserInfo.bio,
                                              profileImageUrl: "")
        }
    }
    
    func configure(userDetail: UserDetailResponse, contacts: [Contact]) {
        // profileImageView에 프로필 이미지 링크 메서드
        if let profileImageUrl = userDetail.profileImageUrl {
            profileCardView.configureUserInfo(name: userDetail.nickname, career: userDetail.role, bio: userDetail.bio, profileImageUrl: profileImageUrl)
        } else {
            profileCardView.configureUserInfo(name: userDetail.nickname, career: userDetail.role, bio: userDetail.bio, profileImageUrl: "")
        }
        
        contactsView.configure(contacts: contacts)
        
    }
    
    
}

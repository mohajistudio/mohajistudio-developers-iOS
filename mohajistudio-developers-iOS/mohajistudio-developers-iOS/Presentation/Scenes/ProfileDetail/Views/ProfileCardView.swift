//
//  EditModeProfileView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 3/7/25.
//

import UIKit
import SnapKit

class ProfileCardView: UIView {
    
    enum Mode {
        case normal
        case edit
    }
    
    private var currentMode: Mode = .normal
    
    // 공통 컴포넌트
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "TempProfileImage")
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    // 뷰 모드 컴포넌트
    private let nameLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.text = "Name"
        $0.textColor = UIColor(named: "Black")
        $0.textAlignment = .left
    }
    
    private let careerLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.text = "Developer"
        $0.textColor = UIColor(named: "Gray 3")
        $0.textAlignment = .left
    }
    
    private let bioLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "Gray 1")
        $0.text = "Introduce"
        $0.textAlignment = .left
    }
    
    // 에딧 모드 컴포넌트
    private let nicknameEditTextField = UITextField().then {
        $0.keyboardType = .default
        $0.layer.borderColor = UIColor(named: "Bg 2")?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .clear
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        $0.leftView = paddingView
        $0.leftViewMode = .always
        $0.rightView = paddingView
        $0.rightViewMode = .always
    }
    
    private let careerEditTextField = UITextField().then {
        $0.keyboardType = .default
        $0.layer.borderColor = UIColor(named: "Bg 2")?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .clear
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        $0.leftView = paddingView
        $0.leftViewMode = .always
        $0.rightView = paddingView
        $0.rightViewMode = .always
    }
    
    private let bioEditTextView = UITextView().then {
        $0.keyboardType = .default
        $0.layer.borderColor = UIColor(named: "Bg 2")?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .clear
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 7, bottom: 8, right: 7) // 기본적으로 5를 가지기에 총 12를 가짐 좌우로.
    }
    
    private let deleteImageButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor(named: "Error")?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.setTitle("이미지 삭제", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(UIColor(named: "Error"), for: .normal)
        
    }
    
    private let nicknameHeaderLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "Gray 2")
        $0.text = "닉네임"
    }
    
    private let careerHeaderLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "Gray 2")
        $0.text = "커리어"
    }
    
    private let bioHeaderLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "Gray 2")
        $0.text = "소개"
    }

    private var normalModeBottomConstraint: Constraint?
    private var editModeBottomConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupAction()
        setViewMode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setupUI() {
        setupHierarchy()
        setupConstraints()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func setupHierarchy() {
        addSubview(profileImageView)
        addSubview(deleteImageButton)
        addSubview(nicknameHeaderLabel)
        addSubview(nicknameEditTextField)
        addSubview(careerHeaderLabel)
        addSubview(careerEditTextField)
        addSubview(bioHeaderLabel)
        addSubview(bioEditTextView)
        
        addSubview(nameLabel)
        addSubview(careerLabel)
        addSubview(bioLabel)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(profileImageView.snp.horizontalEdges)
        }
        
        careerLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(profileImageView.snp.horizontalEdges)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        bioLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(profileImageView.snp.horizontalEdges)
            $0.top.equalTo(careerLabel.snp.bottom).offset(16)
            
            normalModeBottomConstraint = $0.bottom.equalToSuperview().offset(-32).constraint
            normalModeBottomConstraint?.isActive = (currentMode == .normal)
        }
        
        deleteImageButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(profileImageView.snp.horizontalEdges)
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.height.equalTo(40)
        }
        
        nicknameHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(deleteImageButton.snp.bottom).offset(16)
            $0.leading.equalTo(deleteImageButton.snp.leading)
        }
        
        nicknameEditTextField.snp.makeConstraints {
            $0.horizontalEdges.equalTo(deleteImageButton.snp.horizontalEdges)
            $0.top.equalTo(nicknameHeaderLabel.snp.bottom).offset(8)
            $0.height.equalTo(38)
        }
        
        careerHeaderLabel.snp.makeConstraints {
            $0.leading.equalTo(deleteImageButton.snp.leading)
            $0.top.equalTo(nicknameEditTextField.snp.bottom).offset(16)
        }
        
        careerEditTextField.snp.makeConstraints {
            $0.horizontalEdges.equalTo(deleteImageButton.snp.horizontalEdges)
            $0.top.equalTo(careerHeaderLabel.snp.bottom).offset(8)
            $0.height.equalTo(38)
        }
        
        bioHeaderLabel.snp.makeConstraints {
            $0.leading.equalTo(deleteImageButton.snp.leading)
            $0.top.equalTo(careerEditTextField.snp.bottom).offset(16)
        }
        
        bioEditTextView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(deleteImageButton.snp.horizontalEdges)
            $0.top.equalTo(bioHeaderLabel.snp.bottom).offset(8)
            $0.height.equalTo(76)
            
            editModeBottomConstraint = $0.bottom.equalToSuperview().offset(-32).constraint
            editModeBottomConstraint?.isActive = (currentMode == .edit)
        }
    }
    
    private func updateViewVisibility() {
        let normalModeViews = [nameLabel, careerLabel, bioLabel]
        normalModeViews.forEach { $0.isHidden = (currentMode == .edit) }
        
        let editModeViews = [deleteImageButton, nicknameHeaderLabel, nicknameEditTextField, careerHeaderLabel, careerEditTextField, bioHeaderLabel, bioEditTextView]
        editModeViews.forEach { $0.isHidden = (currentMode == .normal) }
    }
    
    func setViewMode() {
        currentMode = .normal
        
        normalModeBottomConstraint?.isActive = true
        editModeBottomConstraint?.isActive = false
        
        updateViewVisibility()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setEditMode() {
        currentMode = .edit
        
        nicknameEditTextField.text = nameLabel.text
        careerEditTextField.text = careerLabel.text
        bioEditTextView.text = bioLabel.text
        
        normalModeBottomConstraint?.isActive = false
        editModeBottomConstraint?.isActive = true
        
        updateViewVisibility()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func configureUserInfo(name: String, career: String, bio: String, profileImageUrl: String) {
        nameLabel.text = name
        careerLabel.text = career
        bioLabel.text = bio
        // 이미지 스토리지에서 로드하는 로직 구현 필요
        profileImageView.image = UIImage(named: "Default_profile")
    }
    
    private func setupAction() {
        deleteImageButton.addTarget(self, action: #selector(didTapDeleteImageButton), for: .touchUpInside)
    }
    
    @objc private func didTapDeleteImageButton() {
        print("이미지 삭제 버튼 탭")
    }
    
    func toggleCurrentMode() {
        if currentMode == .edit {
            setViewMode()
        }
        else {
            setEditMode()
        }
    }
    
    func getEditedUserInfo() -> (name: String, career: String, bio: String) {
        return (
            name: nicknameEditTextField.text ?? nameLabel.text ?? "",
            career: careerEditTextField.text ?? careerLabel.text ?? "",
            bio: bioEditTextView.text ?? bioLabel.text ?? ""
        )
    }
    
}

//
//  SetNicknameView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/29/24.
//

import UIKit
import SnapKit

protocol SetProfileNameViewDelegate: AnyObject {
    func setProfileNameViewDidTapBack()
    func setProfileNameViewDidTapNext(nickname: String)
}

class SetProfileNameView: BaseStepView {
    
    private let titleLabel = UILabel().then {
        $0.text = "환영합니다!"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "닉네임을 설정해주세요"
        $0.textColor = UIColor(hexCode: "666666")
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let emailTitleLabel = UILabel().then {
        $0.text = "email"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let emailLabel = UILabel().then {
        $0.text = "Mohaji@naver.com"
        $0.textColor = UIColor(hexCode: "999999")
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let profileNameFieldBlock = InputFormView(contentTitle: "프로필 이름", fieldPlaceholder: "Mohaji_Developer", type: .name)
    
    private let nextButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "0A0A0A")
        $0.layer.cornerRadius = 8.0
        $0.layer.cornerCurve = .continuous
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textColor = .white
    }
    
    // MARK: - Properties
    weak var delegate: SetProfileNameViewDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = UIColor(named: "BackgroundColor")
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        [titleLabel, subTitleLabel, emailTitleLabel, emailLabel, profileNameFieldBlock, nextButton]
            .forEach { surfaceView.addSubview($0) }
    }
    
    private func setupConstraints() {
        surfaceView.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(20)
            $0.bottom.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        emailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(60)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(22)
            $0.leading.equalTo(emailTitleLabel.snp.leading).offset(10)
            $0.trailing.equalTo(titleLabel)
        }
        
        profileNameFieldBlock.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(emailLabel.snp.bottom).offset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(profileNameFieldBlock.snp.bottom).offset(40)
            $0.height.equalTo(44)
        }
        
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        profileNameFieldBlock.getTextField().addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func configure(email: String?) {
        self.emailLabel.text = email
    }
    
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        delegate?.setProfileNameViewDidTapBack()
    }
    
    @objc private func nextButtonTapped() {
        guard let nickname = profileNameFieldBlock.getValue(), nickname != "" else {
            profileNameFieldBlock.representError(isHidden: false, errorMessage: "프로필 이름을 입력해주세요.")
            return
        }
        
        delegate?.setProfileNameViewDidTapNext(nickname: nickname)
    }
    
    @objc private func textFieldDidChange() {
        resetVerificationError()
    }
    
    func showVerificationError(error: String) {
        profileNameFieldBlock.representError(isHidden: false, errorMessage: error)
        
        setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            print("height 업데이트 완료")
        }
    }
    
    func resetVerificationError() {
        profileNameFieldBlock.representError(isHidden: true, errorMessage: nil)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    

}

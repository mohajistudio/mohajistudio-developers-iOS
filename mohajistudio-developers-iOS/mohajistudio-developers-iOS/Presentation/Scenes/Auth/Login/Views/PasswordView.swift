//
//  PasswordView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/16/24.
//

import UIKit
import SnapKit
import Then

protocol PasswordViewDelegate: AnyObject {
    func passwordViewDidTapLogin(password: String)
    func passwordViewDidTapBackBtn()
}

class PasswordView: UIView {
    // MARK: - UI 컴포넌트 설정
    private let surfaceView = SurfaceView()
    
    private let backButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular)
        let image = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        
        $0.setImage(image, for: .normal)
        $0.tintColor = UIColor(hexCode: "0A0A0A")
    }
    
    private let logoLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Bold", size: 30)
        $0.text = "Mohaji Tech Blog"
        $0.textAlignment = .left
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textColor = UIColor(hexCode: "666666")
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.text = "비밀번호를 입력해주세요"
        $0.textAlignment = .left
    }
    
    private let passwordFieldBlock = InputFormView(contentTitle: "password", fieldPlaceholder: "********", type: .password)
    
    private let loginButton = AuthButton(title: "로그인")
    
    private let toSignUpButton = UIButton().then {
        
        let fullString = "비밀번호를 잊으셨나요? 비밀번호 찾기"
        let attributedString = NSMutableAttributedString(string: fullString)
        
        attributedString.addAttributes([
            .font: UIFont(name: "Pretendard-Medium", size: 14),
            .foregroundColor: UIColor(hexCode: "1E96FF")
        ], range: NSRange(location: 0, length: 12))
        
        attributedString.addAttributes([
            .font: UIFont(name: "Pretendard-Bold", size: 14),
            .foregroundColor: UIColor(hexCode: "1E96FF")
        ], range: NSRange(location: 13, length: 7))
        
        $0.setAttributedTitle(attributedString, for: .normal)
    }
    
    weak var delegate: PasswordViewDelegate?
    
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
        backgroundColor = UIColor(named: "BackgroundColor")
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        addSubview(surfaceView)
        [backButton, logoLabel, subtitleLabel, passwordFieldBlock, loginButton, toSignUpButton].forEach { surfaceView.addSubview($0) }
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
        
        logoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(186)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(20)
            $0.trailing.leading.equalTo(logoLabel)
        }
        
        passwordFieldBlock.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(60)
            $0.leading.trailing.equalTo(logoLabel)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordFieldBlock.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(logoLabel)
            $0.height.equalTo(44)
        }
        
        toSignUpButton.snp.makeConstraints {
            $0.top.equalTo(loginButton).offset(60)
            $0.leading.trailing.equalTo(logoLabel)
            
        }
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        guard let password = passwordFieldBlock.getValue() else { return }
        
        delegate?.passwordViewDidTapLogin(password: password)
    }
    
    @objc private func backButtonTapped() {
        delegate?.passwordViewDidTapBackBtn()
    }
    
}

//
//  SignUpView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/16/24.
//

import UIKit
import SnapKit
import Then

// MARK: - Delgate Protocol
protocol SignUpViewDelegate: AnyObject {
    func signUpViewDidTapBack()
    func signUpViewDidTapNext(email: String)
}

final class SignUpView: BaseStepView {
    // MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = UIColor(named: "Black")
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "계정 생성을 위해 이메일을 입력해주세요"
        $0.textColor = UIColor(named: "Gray 2")
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let emailLabel = UILabel().then {
        $0.text = "email"
        $0.textColor = UIColor(named: "Black")
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let emailFieldView = UITextField().then {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftView = paddingView
        $0.leftViewMode = .always
        
        $0.backgroundColor = UIColor(named: "Bg 1")
        $0.autocapitalizationType = .none
        $0.attributedPlaceholder = NSAttributedString(
            string: "Mohaji@naver.com",
            attributes: [.foregroundColor: UIColor(named: "Gray 3")]
        )
        $0.textAlignment = .center
        $0.layer.cornerRadius = 8.0
        $0.layer.cornerCurve = .continuous
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let errorLabel = UILabel().then {
        $0.textColor = UIColor(named: "Error")
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    private let nextButton = UIButton().then {
        $0.backgroundColor = UIColor(named: "Primary")
        $0.layer.cornerRadius = 8.0
        $0.layer.cornerCurve = .continuous
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textColor = .white
    }
    
    // MARK: - Properties
    weak var delegate: SignUpViewDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
        setupTextFieldDelegate(for: emailFieldView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = UIColor(named: "Bg 1")
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        [titleLabel, subTitleLabel, emailLabel, emailFieldView, errorLabel, nextButton]
            .forEach { surfaceView.addSubview($0) }
    }
    
    private func setupConstraints() {
        //       surfaceView.snp.makeConstraints {
        //           $0.top.leading.equalTo(safeAreaLayoutGuide).offset(20)
        //           $0.bottom.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
        //       }
        //
        //       backButton.snp.makeConstraints {
        //           $0.leading.equalToSuperview().offset(20)
        //           $0.top.equalToSuperview().offset(20)
        //       }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(186)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        emailLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(60)
        }
        
        emailFieldView.snp.makeConstraints {
            $0.trailing.equalTo(titleLabel)
            $0.leading.equalTo(emailLabel.snp.leading).offset(-2)
            $0.height.equalTo(39)
            $0.top.equalTo(emailLabel.snp.bottom).offset(12)
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(emailFieldView.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(emailFieldView)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(43)
            $0.top.equalTo(emailFieldView.snp.bottom).offset(40)
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        emailFieldView.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        delegate?.signUpViewDidTapBack()
    }
    
    @objc private func nextButtonTapped() {
        guard let email = emailFieldView.text else { return }
        if ValidationUtility.isValidEmail(email) {
            delegate?.signUpViewDidTapNext(email: email)
        }
        else {
            showVerificationError(error: "올바른 이메일 형식이 아닙니다.")
        }
    }
    
    @objc private func textFieldDidChange() {
        resetVerificationError()
    }
    
    func showVerificationError(error: String) {
        emailFieldView.layer.borderColor = UIColor.red.cgColor
        emailFieldView.layer.borderWidth = 1.0
        errorLabel.text = error
        errorLabel.isHidden = false
    }
    
    func resetVerificationError() {
        emailFieldView.layer.borderWidth = 0
        errorLabel.text = ""
        errorLabel.isHidden = true
    }
}

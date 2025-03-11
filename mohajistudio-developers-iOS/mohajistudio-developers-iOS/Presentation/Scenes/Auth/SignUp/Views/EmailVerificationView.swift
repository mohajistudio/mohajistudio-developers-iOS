//
//  EmailVerificationView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/27/24.
//

import UIKit

protocol EmailVerificationViewDelegate : AnyObject {
    func emailVerificationViewDidTapBack()
    func emailVerificationViewDidTapResend(email: String)
    func emailVerificationViewDidTapNext(code: String)
}

class EmailVerificationView: BaseStepView {
    
    private var viewModel: SignUpViewModel?
    private var email: String?
    
    private let titleLabel = UILabel().then {
        $0.text = "이메일 인증"
        $0.textColor = UIColor(named: "Black")
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "이메일 인증코드가 발송되었습니다.\n인증 코드를 입력하세요"
        $0.textColor = UIColor(named: "Gray 2")
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let verificationCodeField = UITextField().then {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 0))
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftView = paddingView
        $0.leftViewMode = .always
        
        $0.backgroundColor = UIColor(named: "Bg 1")
        $0.autocapitalizationType = .none
        $0.attributedPlaceholder = NSAttributedString(
            string: "123456",
            attributes: [.foregroundColor: UIColor(named: "Gray 3")]
        )
        $0.textAlignment = .left
        $0.layer.cornerRadius = 8.0
        $0.layer.cornerCurve = .continuous
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let timerLabel = UILabel().then {
        $0.textColor = UIColor(named: "Primary")
        $0.font = UIFont(name: "Pretendard-Light", size: 12)
        $0.textAlignment = .center
        $0.text = "05:00"
    }
    
    private let errorLabel = UILabel().then {
        $0.textColor = UIColor(named: "Error")
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    private let resendButton = UIButton().then {
        $0.setTitle("재전송", for: .normal)
        $0.backgroundColor = UIColor(named: "Info")
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.layer.cornerRadius = 8.0
        $0.layer.cornerCurve = .continuous
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
    weak var delegate: EmailVerificationViewDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
        setupTextFieldDelegate(for: verificationCodeField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func bindViewModel() {
        viewModel?.onTimerUpdate = { [weak self] timeString in
            DispatchQueue.main.async {
                print("타이머 업데이트: \(timeString)")
                self?.timerLabel.text = timeString
            }
        }
        
        viewModel?.onTimerFinished = { [weak self] in
            DispatchQueue.main.async {
                print("타이머 종료")
                self?.handleTimerFinished()
            }
        }
    }
    
    private func handleTimerFinished() {
        timerLabel.text = "00:00"
    }
    
    func startTimer(expirationDate: String) {
        print("타이머 시작: \(expirationDate)")
        viewModel?.startTimer(expirationDate: expirationDate)
    }
    
    private func setupUI() {
        backgroundColor = UIColor(named: "Bg 1")
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        [titleLabel, subTitleLabel, verificationCodeField, timerLabel, errorLabel, resendButton, nextButton]
            .forEach { surfaceView.addSubview($0) }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(186)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        verificationCodeField.snp.makeConstraints {
            $0.trailing.equalTo(resendButton.snp.leading).offset(-8)
            $0.leading.equalTo(subTitleLabel.snp.leading)
            $0.height.equalTo(40)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(60)
        }
        
        timerLabel.snp.makeConstraints {
            $0.trailing.equalTo(verificationCodeField.snp.trailing).offset(-12)
            $0.centerY.equalTo(verificationCodeField.snp.centerY)
        }
        
        errorLabel.snp.makeConstraints {
            $0.centerX.equalTo(verificationCodeField.snp.centerX)
            $0.top.equalTo(verificationCodeField.snp.bottom).offset(8)
        }
        
        resendButton.snp.makeConstraints {
            $0.trailing.equalTo(subTitleLabel.snp.trailing)
            $0.width.equalTo(80)
            $0.height.equalTo(verificationCodeField.snp.height)
            $0.top.equalTo(verificationCodeField.snp.top)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(43)
            $0.top.equalTo(verificationCodeField.snp.bottom).offset(60)
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        resendButton.addTarget(self, action: #selector(resendButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        verificationCodeField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        delegate?.emailVerificationViewDidTapBack()
    }
    
    @objc private func resendButtonTapped() {
        self.verificationCodeField.text = ""
        resetVerificationError()
        print("email: \(email)")
        
        guard let email = email else {
            print("resendButtonTapped - email is nil")
            return
        }
        
        delegate?.emailVerificationViewDidTapResend(email: email)
    }
    
    @objc private func nextButtonTapped() {
        guard let code = verificationCodeField.text else {
            print("이메일 인증 코드 필드 값이 비었습니다.")
            return
        }
        
        delegate?.emailVerificationViewDidTapNext(code: code)
    }
    
    @objc private func textFieldDidChange() {
        resetVerificationError()
    }
    
    func configure(with email: String?, viewModel: SignUpViewModel? = nil) {
        print("[EmailVerification] configure 호출 - email: \(email ?? "nil"), viewModel: \(viewModel != nil ? "있음" : "nil")")
        self.email = email
        self.viewModel = viewModel
        if viewModel != nil {
            print("[EmailVerificationView] viewModel 있음, 바인딩 시작")
            bindViewModel()
        } else {
            print("[EmailVerificationView] viewModel이 nil임, 바인딩 안 함")
        }
    }
    
    func showVerificationError(error: String) {
        verificationCodeField.layer.borderColor = UIColor.red.cgColor
        verificationCodeField.layer.borderWidth = 1.0
        errorLabel.text = error
        errorLabel.isHidden = false
    }
    
    func resetVerificationError() {
        verificationCodeField.layer.borderWidth = 0
        errorLabel.text = ""
        errorLabel.isHidden = true
    }
}

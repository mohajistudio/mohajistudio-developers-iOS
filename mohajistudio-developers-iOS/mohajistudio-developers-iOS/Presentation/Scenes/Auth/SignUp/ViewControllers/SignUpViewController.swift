//
//  ViewController.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/8/24.
//

import UIKit


final class SignUpViewController: UIViewController {
    
    enum Step {
        case email
        case emailVerification
        case setPassword
        case setProfileName
        
        func view(delegate: Any, viewModel: SignUpViewModel? = nil, email: String? = nil) -> UIView {
            switch self {
            case .email:
                let view = SignUpView()
                view.delegate = delegate as? SignUpViewDelegate
                return view
            case .emailVerification:
                print("Creating EmailVerificationView with email:", email ?? "nil")
                let view = EmailVerificationView()
                view.delegate = delegate as? EmailVerificationViewDelegate
                view.configure(with: email, viewModel: viewModel)
                return view
            case .setPassword:
                let view = SetPasswordView()
                view.delegate = delegate as? SetPasswordViewDelegate
                return view
            case .setProfileName:
                let view = SetProfileNameView()
                view.delegate = delegate as? SetProfileNameViewDelegate
                view.configure(email: email)
                return view
            }
        }
    }
    
    // MARK: - Properties
    private var currentStep: Step = .email
    private let viewModel: SignUpViewModel
    
    private let containerView = UIView()
    
    // MARK: - Initialization
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = containerView
        view.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(for: currentStep)
    }
    
    private func updateView(for step: Step, animated: Bool = false, reverseAnimation: Bool = false) {
        let newView = step.view(delegate: self, viewModel: viewModel, email: viewModel.getCurrentEmail())
        
        if animated {
            containerView.addSubview(newView)
            newView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            containerView.layoutIfNeeded()
            
            if let newStepView = newView as? BaseStepView,
               let oldView = containerView.subviews.first(where: { $0 != newView }),
               let oldStepView = oldView as? BaseStepView {
                
                // surfaceView의 width를 기준으로 offset 계산
                let surfaceWidth = newStepView.surfaceView.bounds.width
                let initialOffset = (reverseAnimation ? -surfaceWidth : surfaceWidth) * 0.2
                
                // backButton은 애니메이션에서 제외하고 고정
                newStepView.backButton.alpha = 1
                newStepView.backButton.transform = .identity
                oldStepView.backButton.alpha = 1
                oldStepView.backButton.transform = .identity
                
                // 새로운 뷰의 컴포넌트들 초기 위치 설정 (backButton 제외)
                newStepView.surfaceView.subviews.forEach { subview in
                    if subview != newStepView.backButton {
                        subview.transform = CGAffineTransform(translationX: initialOffset, y: 0)
                        subview.alpha = 0.3
                    }
                }
                
                // 애니메이션 적용
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               options: [.curveEaseOut]) {
                    // 새로운 컴포넌트들은 원래 위치로
                    newStepView.surfaceView.subviews.forEach { subview in
                        if subview != newStepView.backButton {
                            subview.transform = .identity
                            subview.alpha = 1
                        }
                    }
                    
                    // 현재 컴포넌트들은 반대 방향으로
                    let exitOffset = (reverseAnimation ? surfaceWidth : -surfaceWidth) * 0.2
                    oldStepView.surfaceView.subviews.forEach { subview in
                        if subview != oldStepView.backButton {
                            subview.transform = CGAffineTransform(translationX: exitOffset, y: 0)
                            subview.alpha = 0.3
                        }
                    }
                } completion: { _ in
                    oldView.removeFromSuperview()
                }
            }
        } else {
            containerView.subviews.forEach { $0.removeFromSuperview() }
            containerView.addSubview(newView)
            newView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    private func moveToRegistrationStep(email: String) async {
        
        do {
            // 상태 체크
            try await viewModel.checkSignUpStatus(email: email)
            
            await MainActor.run {
                // 상태 코드에 따라 적절한 단계로 이동
                moveToNextStep()
            }
        } catch let error as NetworkError {
            switch error {
                
            case .unknownUser:
                viewModel.setEmail(email)
            case .passwordNotSet:
                currentStep = .setPassword
                viewModel.setEmail(email)
                updateView(for: .setPassword, animated: true)
                
            case .profileNameNotSet:
                currentStep = .setProfileName
                viewModel.setEmail(email)
                updateView(for: .setProfileName, animated: true)
                
            default:
                await MainActor.run {
                    showAlert(message: "예기치 못한 오류가 발생했습니다.")
                }
                
            }
        } catch {
            await MainActor.run {
                showAlert(message: "예기치 못한 오류가 발생했습니다.\n다시 시도해주세요.")
            }
        }
    }
    
    private func checkSignUpStatusWithoutUI(email: String) async -> NetworkError {
        do {
            try await viewModel.checkSignUpStatus(email: email)
            return .alreadyRegistered
        } catch let error as NetworkError {
            switch error {
            case .unknownUser:
                return .unknownUser
            case .passwordNotSet:
                return .passwordNotSet
            case .profileNameNotSet:
                return .profileNameNotSet
            default:
                return .unknown(error.errorMessage)
            }
        } catch {
            return .unknown("예기치 못한 오류가 발생했습니다.\n다시 시도해주세요.")
        }
    }
    
    
    func moveToNextStep() {
        switch currentStep {
        case .email:
            currentStep = .emailVerification
            updateView(for: .emailVerification, animated: true, reverseAnimation: false)
        case .emailVerification:
            currentStep = .setPassword
            updateView(for: .setPassword, animated: true, reverseAnimation: false)
        case .setPassword:
            currentStep = .setProfileName
            updateView(for: .setProfileName, animated: true, reverseAnimation: false)
        case .setProfileName:
            showAlert(title: "회원가입 완료" ,message: "로그인 페이지로 이동합니다.", confirmHandler:  {
                self.navigationController?.popViewController(animated: true)
                KeychainHelper.shared.clearTokens()
            })
        }
    }
    
    func moveToPreviousStep() {
        switch currentStep {
        case .email:
            return
        case .emailVerification:
            currentStep = .email
            updateView(for: .email, animated: true, reverseAnimation: true)
        case .setPassword:
            currentStep = .email // email 단계부터 다시 인증할 수 있도록
            updateView(for: .email, animated: true, reverseAnimation: true)
        case .setProfileName:
            currentStep = .email
            updateView(for: .email, animated: true, reverseAnimation: true)
            
        }
    }
    
}

// MARK: - SignUpViewDelegate
extension SignUpViewController: SignUpViewDelegate {
    func signUpViewDidTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func signUpViewDidTapNext(email: String) {
        print("signupView next button tap!")
        
        guard ValidationUtility.isValidEmail(email) else {
            return
        }
        
        viewModel.setEmail(email)
        
        // 로딩 상태 시작
        if let currentView = containerView.subviews.first as? SignUpView {
            currentView.setNextButtonLoading(true)
        }
        
        Task {
            do {
                // 회원가입 상태 확인
                let registrationStatus = await checkSignUpStatusWithoutUI(email: email)
                
                switch registrationStatus {
                case .unknownUser:
                    // 새 사용자인 경우, 이메일 인증 코드 요청 먼저 수행
                    let response = try await viewModel.requestEmailVerification(email: email)
                    
                    // 인증 코드 요청이 성공한 후에만 화면 전환
                    await MainActor.run {
                        print("[VC] 인증 코드 요청 성공 - expiredAt: \(response.expiredAt)")
                        // 로딩 버튼 상태 해제
                        if let currentView = containerView.subviews.first as? SignUpView {
                            currentView.setNextButtonLoading(false)
                        }
                        
                        // 이메일 인증 화면으로 전환
                        currentStep = .emailVerification
                        updateView(for: .emailVerification, animated: true)
                        
                        // 타이머 시작
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { // 애니메이션 시간(0.5초)보다 약간 더 길게
                            if let verificationView = self.containerView.subviews.first as? EmailVerificationView {
                                print("[VC] EmailVerificationView 찾음, 타이머 시작 시도")
                                verificationView.startTimer(expirationDate: response.expiredAt)
                                print("[VC] 타이머 시작 메서드 호출 완료")
                            } else {
                                print("[VC] EmailVerificationView를 찾을 수 없음 (지연 후)")
                            }
                        }
                    }
                    
                case .alreadyRegistered:
                    await MainActor.run {
                        if let currentView = containerView.subviews.first as? SignUpView {
                            currentView.setNextButtonLoading(false)
                        }
                        showAlert(message: "이미 가입 완료된 계정입니다.")
                    }
                    
                case .passwordNotSet:
                    await MainActor.run {
                        if let currentView = containerView.subviews.first as? SignUpView {
                            currentView.setNextButtonLoading(false)
                        }
                        currentStep = .setPassword
                        updateView(for: .setPassword, animated: true)
                    }
                    
                case .profileNameNotSet:
                    await MainActor.run {
                        if let currentView = containerView.subviews.first as? SignUpView {
                            currentView.setNextButtonLoading(false)
                        }
                        currentStep = .setProfileName
                        updateView(for: .setProfileName, animated: true)
                    }
                    
                case .unknown(let message):
                    await MainActor.run {
                        if let currentView = containerView.subviews.first as? SignUpView {
                            currentView.setNextButtonLoading(false)
                        }
                        showAlert(message: message)
                    }
                default:
                    showAlert(message: "예기치 못한 오류가 발생했습니다. 다시 시도해주세요.")
                }
            } catch let error as NetworkError {
                print(error)
                await MainActor.run {
                    if let currentView = containerView.subviews.first as? SignUpView {
                        currentView.setNextButtonLoading(false)
                    }
                    self.showAlert(message: error.errorMessage)
                }
            } catch {
                print(error)
                await MainActor.run {
                    if let currentView = containerView.subviews.first as? SignUpView {
                        currentView.setNextButtonLoading(false)
                    }
                    self.showAlert(message: "예기치 못한 오류가 발생했습니다.\n다시 시도해주세요.")
                }
            }
        }
    }
}

extension SignUpViewController: EmailVerificationViewDelegate {
    func emailVerificationViewDidTapBack() {
        moveToPreviousStep()
    }
    
    func emailVerificationViewDidTapResend(email: String) {
        Task {
            do {
                let response = try await viewModel.requestEmailVerification(email: email)
                // 타이머 로직은 여기에 새로 구현될 예정
                if let currentView = containerView.subviews.first as? EmailVerificationView {
                    currentView.startTimer(expirationDate: response.expiredAt)
                }
            }
            catch let error as NetworkError {
                await MainActor.run {
                    self.showAlert(message: error.errorMessage)
                }
            }
            catch {
                await MainActor.run {
                    self.showAlert(message: "예기치 못한 오류가 발생했습니다.\n다시 시도해주세요.")
                }
            }
        }
    }
    
    func emailVerificationViewDidTapNext(code: String) {
        guard let currentView = containerView.subviews.first as? EmailVerificationView else { return }
        
        guard ValidationUtility.isValidVerificationCode(code) else {
            currentView.showVerificationError(error: "인증코드가 올바르지 않습니다.")
            return
        }
        
        Task {
            do {
                try await viewModel.verifyEmailCode(code: code)
                await MainActor.run {
                    moveToNextStep()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    currentView.showVerificationError(error: error.errorMessage)
                }
            } catch {
                await MainActor.run {
                    showAlert(message: "예기치 못한 오류가 발생했습니다.\n다시 시도해주세요.")
                }
            }
        }
    }
}

extension SignUpViewController: SetPasswordViewDelegate {
    func setPasswordViewDidTapBack() {
        moveToPreviousStep()
    }
    
    func setPasswordViewDidTapNext(password: String) {
        
        guard ValidationUtility.isValidPassword(password) else { return }
        
        Task {
            do {
                try await viewModel.setPassword(password: password)
                await MainActor.run {
                    moveToNextStep()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    showAlert(message: error.errorMessage)
                }
            } catch {
                await MainActor.run {
                    showAlert(message: "예기치 못한 오류가 발생했습니다.\n다시 시도해주세요.")
                }
            }
        }
    }
}

extension SignUpViewController: SetProfileNameViewDelegate {
    func setProfileNameViewDidTapBack() {
        moveToPreviousStep()
    }
    
    func setProfileNameViewDidTapNext(nickname: String) {
        
        Task {
            do {
                try await viewModel.setNickname(nickname: nickname)
                await MainActor.run {
                    moveToNextStep()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    showAlert(message: error.errorMessage)
                }
            } catch {
                await MainActor.run {
                    showAlert(message: "예기치 못한 오류가 발생했습니다.\n다시 시도해주세요.")
                }
            }
        }
    }
}

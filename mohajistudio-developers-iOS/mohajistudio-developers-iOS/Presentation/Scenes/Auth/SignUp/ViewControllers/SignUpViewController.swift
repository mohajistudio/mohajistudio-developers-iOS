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
        
        func view(delegate: Any, email: String? = nil) -> UIView {
            switch self {
            case .email:
                let view = SignUpView()
                view.delegate = delegate as? SignUpViewDelegate
                return view
            case .emailVerification:
                print("Creating EmailVerificationView with email:", email ?? "nil")
                let view = EmailVerificationView()
                view.delegate = delegate as? EmailVerificationViewDelegate
                view.configure(with: email)
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
        let newView = step.view(delegate: self, email: viewModel.getCurrentEmail())
        
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
                currentStep = .emailVerification
                viewModel.setEmail(email)
                updateView(for: .emailVerification, animated: true)
                
            case .passwordNotSet:
                currentStep = .setPassword
                viewModel.setEmail(email)
                updateView(for: .setPassword, animated: true)
                
            case .profileNameNotSet:
                currentStep = .setProfileName
                viewModel.setEmail(email)
                updateView(for: .setProfileName, animated: true)
                
            default:
                //                    currentStep = .emailVerification
                //                    viewModel.setEmail(email)
                //                    updateView(for: .emailVerification, animated: true)
                showAlert(message: "예기치 못한 오류가 발생했습니다.")
            }
        } catch {
            await MainActor.run {
                showAlert(message: "예기치 못한 오류가 발생했습니다.\n다시 시도해주세요.")
            }
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
        
        Task {
            
            
            do {
                await moveToRegistrationStep(email: email)
                
                if currentStep == .emailVerification {
                    try await viewModel.requestEmailVerification(email: email)
                }
            } catch let error as NetworkError {
                print(error)
                try? await Task.sleep(for: .seconds(1.5)) // UX적 요소를 고려해 응답이 바로 오면 바로 뒤로가기하지 않도록
                await MainActor.run {
                    moveToPreviousStep()
                    viewModel.setEmail("")
                    self.showAlert(message: error.errorMessage)
                }
            } catch {
                print(error)
                try? await Task.sleep(for: .seconds(1.5))
                await MainActor.run {
                    moveToPreviousStep()
                    viewModel.setEmail("")
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
                try await viewModel.requestEmailVerification(email: email)
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
        
        guard ValidationUtility.isValidVerificationCode(code) else { currentView.showVerificationError(error: "인증코드가 올바르지 않습니다."); return }
        
        //         인증 코드 검증하는 메서드
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
        //        moveToNextStep()
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

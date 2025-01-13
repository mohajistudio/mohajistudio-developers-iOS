//
//  BaseAuthView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/3/25.
//

import UIKit

class BaseStepView: UIView {
    let backButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular)
        let image = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = UIColor(named: "Primary")
    }
    
    let surfaceView = SurfaceView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBaseUI() {
        backgroundColor = UIColor(named: "Bg 1")
        addSubview(surfaceView)
        surfaceView.addSubview(backButton)
        
        setupBaseConstraints()
        setupKeyboardNotifications()
        hideKeyboardWhenTappedBackground()
    }
    
    private func setupBaseConstraints() {
        surfaceView.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(20)
            $0.bottom.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
    }
    
    func hideKeyboardWhenTappedBackground() {
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapEvent.cancelsTouchesInView = false
        surfaceView.addGestureRecognizer(tapEvent)
    }
    
    @objc func dismissKeyboard() {
        surfaceView.endEditing(true)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        print("keyboardWillShow!!")
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        let textFields = surfaceView.subviews.compactMap { view -> UITextField? in
            if let inputForm = view as? InputFormView {
                return inputForm.getTextField()
            }
            return view as? UITextField
        }
        
        if let activeField = textFields.first(where: { $0.isFirstResponder }) {
            let activeFieldFrame = activeField.convert(activeField.bounds, to: nil)
            let overlap = activeFieldFrame.maxY - (frame.height - keyboardFrame.height)
            
            print("overlap: \(overlap)")
            
            if overlap > 0 {
                UIView.animate(withDuration: keyboardAnimationDuration) {
                    self.transform = CGAffineTransform(translationX: 0, y: -overlap - 20)
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        UIView.animate(withDuration: animationDuration) {
            self.transform = .identity
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

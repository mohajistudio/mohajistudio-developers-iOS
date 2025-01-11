//
//  inputFormView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/16/24.
//

import UIKit

class InputFormView: UIView {
    
    var contentTitle: String
    var fieldPlaceholder: String
    var type: UITextContentType

    private let contentTitleLabel = UILabel().then {
        $0.text = "email"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let contentField = UITextField().then {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftView = paddingView
        $0.leftViewMode = .always
        
        $0.backgroundColor = UIColor(named: "BackgroundColor")
        $0.attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [.foregroundColor: UIColor(hexCode: "999999")]
        )
        $0.textAlignment = .left
        $0.layer.cornerRadius = 8.0
        $0.layer.cornerCurve = .continuous
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let errorLabel = UILabel().then {
        $0.textColor = UIColor(named: "ErrorColor")
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    
    private let secureButton = UIButton().then {
        $0.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        $0.tintColor = UIColor(hexCode: "999999")
    }
    
    init(contentTitle: String, fieldPlaceholder: String, type: UITextContentType) {
        self.contentTitle = contentTitle
        self.fieldPlaceholder = fieldPlaceholder
        self.type = type
        super.init(frame: .zero)
        setupUI()
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: - UI 설정
    
    private func setupUI() {
        setupHierarchy()
        setupConstraints()
        setTextFieldStyle()
    }
    
    private func setupHierarchy() {
        [contentTitleLabel, contentField, errorLabel].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        contentTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        contentField.snp.makeConstraints {
            $0.leading.equalTo(contentTitleLabel).offset(-2)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(40)
            $0.top.equalTo(contentTitleLabel.snp.bottom).offset(12)
        }
        
        errorLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentField)
            $0.top.equalTo(contentField.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
        }
    }

    private func configureContent() {
        contentTitleLabel.text = contentTitle
        contentField.placeholder = fieldPlaceholder
    }
    
    private func setTextFieldStyle() {
        
        switch type {
        case .emailAddress:
            self.contentField.autocapitalizationType = .none
            self.contentField.autocorrectionType = .no
            self.contentField.keyboardType = .emailAddress
            self.contentField.textContentType = .emailAddress
            self.contentField.spellCheckingType = .no
        case .password:
            self.contentField.autocapitalizationType = .none
            self.contentField.autocorrectionType = .no
            self.contentField.keyboardType = .default
            self.contentField.textContentType = .oneTimeCode
            self.contentField.spellCheckingType = .no
            self.contentField.clearsOnBeginEditing = false
            self.contentField.isSecureTextEntry = true
            
            secureButton.addTarget(self, action: #selector(toggleSecureEntry), for: .touchUpInside)
            
            let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 40))
            rightViewContainer.addSubview(secureButton)
            secureButton.frame = CGRect(x: 0, y: 0, width: 44, height: 40)
            
            self.contentField.rightView = rightViewContainer
            self.contentField.rightViewMode = .always
        default:
            return
        }
        
    }
    
    func representError(isHidden: Bool, errorMessage: String?) {
        if isHidden {
            self.contentField.layer.borderWidth = 0
            self.contentField.layer.borderColor = .none
            self.errorLabel.isHidden = true
            self.errorLabel.text = nil
            
            self.layoutIfNeeded()
        } else {
            self.contentField.layer.borderColor = UIColor(named: "ErrorColor")?.cgColor
            self.contentField.layer.borderWidth = 1.0
            self.errorLabel.text = errorMessage
            self.errorLabel.isHidden = false
            
            self.layoutIfNeeded()
        }
    }
    
    @objc private func toggleSecureEntry() {
        contentField.isSecureTextEntry.toggle()
        let imageName = contentField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        secureButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // MARK: - 컴포넌트 관련 메서드
    
    func getValue() -> String? {
        return contentField.text
    }
    
    func getTextField() -> UITextField {
        return self.contentField
    }
    
    func getTitleLabel() -> UILabel {
        return contentTitleLabel
    }
}

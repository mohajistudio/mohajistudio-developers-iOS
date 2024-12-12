//
//  ViewController.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/8/24.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    
    private let backButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: LayoutConverter.convert(23), weight: .regular)
        let image = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        
        $0.setImage(image, for: .normal)
        $0.tintColor = UIColor(hexCode: "0A0A0A")
    }
    
    private let surfaceView = UIView().then {
        $0.backgroundColor = UIColor(named: "SurfaceColor")
        $0.layer.cornerRadius = 16.0
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "계정 생성을 위해 이메일을 입력해주세요"
        $0.textColor = UIColor.init(hexCode: "666666")
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let emailLabel = UILabel().then {
        $0.text = "email"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let emailFieldView = UITextField().then {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftView = paddingView
        $0.leftViewMode = .always
        
        $0.backgroundColor = UIColor(named: "BackgroundColor")
        $0.attributedPlaceholder = NSAttributedString(string: "Mohaji@naver.com", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexCode: "999999")])
        $0.textAlignment = .left
        $0.layer.cornerRadius = 8.0
        $0.layer.cornerCurve = .continuous
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private let nextButton = UIButton().then {
        $0.backgroundColor = UIColor(hexCode: "0A0A0A")
        $0.layer.cornerRadius = 8.0
        $0.layer.cornerCurve = .continuous
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "BackgroundColor")
        setupViews()
    }
    
}

private extension ViewController {
    
    func setupViews() {
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        view.addSubview(surfaceView)
        [backButton, titleLabel,subTitleLabel, emailLabel, emailFieldView, nextButton].forEach { surfaceView.addSubview($0) }
    }
    
    func setupConstraints() {
        surfaceView.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(LayoutConverter.convert(16))
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(LayoutConverter.convert(-16))
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(LayoutConverter.convert(27))
            $0.top.equalToSuperview().offset(LayoutConverter.convert(21))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(LayoutConverter.convert(186))
            $0.leading.equalToSuperview().offset(LayoutConverter.convert(18))
            $0.trailing.equalToSuperview().offset(LayoutConverter.convert(-16))
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutConverter.convert(12))
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        emailLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(LayoutConverter.convert(60))
        }
        
        emailFieldView.snp.makeConstraints {
            $0.trailing.equalTo(titleLabel)
            $0.leading.equalTo(emailLabel.snp.leading).offset(LayoutConverter.convert(-2))
            $0.height.equalTo(LayoutConverter.convert(39))
            $0.top.equalTo(emailLabel.snp.bottom).offset(LayoutConverter.convert(12))
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(43)
            $0.top.equalTo(emailFieldView.snp.bottom).offset(LayoutConverter.convert(12))
        }
    }
    
}

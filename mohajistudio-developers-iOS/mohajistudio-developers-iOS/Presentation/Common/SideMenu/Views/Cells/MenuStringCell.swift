//
//  MenuStringCell.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/13/25.
//

import UIKit

class MenuStringCell: UITableViewCell {
    
    static let identifier = "MenuStringCell"
    
    private let menuTitleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = UIColor(named: "Gray 1")
    }

    // 초기화 메서드. 스타일과 재사용 식별자를 매개변수로 받아 초기화를 수행합니다.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "Bg 1")
        self.setupUI()  // 공통 초기화 작업을 수행하는 메서드 호출
    }
    
    // 초기화 메서드 (NSCoder를 사용한 초기화). 스토리보드나 xib 파일을 통해 생성된 경우 사용됩니다.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        menuTitleLabel.textColor = selected ? UIColor(named: "Info") : UIColor(named: "Gray 1")
    }

    private func setupUI() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(menuTitleLabel)
    }
    
    private func setupConstraints() {
        menuTitleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(title: String) {
        menuTitleLabel.text = title
    }
    
}

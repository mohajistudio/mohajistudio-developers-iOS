//
//  PostCell.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/27/25.
//

import UIKit

class PostCell: UITableViewCell {
    
    private var tags: [String] = []
    static let identifier = "PostCell"
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let thumbnailImage = UIImageView().then {
        $0.image = UIImage(named: "PostImage1")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.textColor = UIColor(named: "Black")
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private let dateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "Gray 3")
        $0.textAlignment = .left
    }
    
    private let tagCollectionView: UICollectionView = {
        let layout = TagFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.isUserInteractionEnabled = false
        
        return cv
    }()
    
    // 초기화 메서드. 스타일과 재사용 식별자를 매개변수로 받아 초기화를 수행합니다.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()  // 공통 초기화 작업을 수행하는 메서드 호출
        setupCollectionView()
    }
    
    // 초기화 메서드 (NSCoder를 사용한 초기화). 스토리보드나 xib 파일을 통해 생성된 경우 사용됩니다.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(named: "Bg 1")
        
        containerView.layer.cornerRadius = 24
        thumbnailImage.layer.cornerRadius = 24
        thumbnailImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(thumbnailImage)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(tagCollectionView)
    }
    
    private func setupConstraints() {
        
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        thumbnailImage.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(thumbnailImage.snp.width).multipliedBy(2.0/3.0)
            $0.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImage.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        tagCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(titleLabel)
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
            $0.height.equalTo(64)
            $0.bottom.equalToSuperview().offset(-24)
        }
    
    }
    
    private func setupCollectionView() {
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
    }
    
    func configure(title: String, date: String, tag: [String]) {
        titleLabel.text = title
        dateLabel.text = date
        self.tags = tag
        
        tagCollectionView.reloadData()
        setNeedsLayout()
    }
    
}

extension PostCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count  // tags 배열 필요
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        
        let tag = tags[indexPath.item]
        cell.configure(with: tag)
        return cell
    }
}

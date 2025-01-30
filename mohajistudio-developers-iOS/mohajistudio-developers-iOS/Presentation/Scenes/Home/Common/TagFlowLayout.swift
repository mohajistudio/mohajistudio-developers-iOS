//
//  TagFlowLayout.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/27/25.
//

import UIKit

class TagFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        
        // CollectionView의 좌측 여백을 고려
        let leftPadding: CGFloat = 0
        
        // CollectionView의 width에서 좌우 여백을 뺀 실제 사용 가능한 width
        let contentWidth = collectionView?.bounds.width ?? 0
        
        attributes.forEach { attribute in
            // 새로운 줄의 시작
            if currentX == 0 {
                currentX = leftPadding
            }
            
            // 현재 줄에 아이템을 추가했을 때 width를 초과하는지 체크
            if currentX + attribute.frame.width > contentWidth - leftPadding {
                // 새로운 줄로 이동
                currentX = leftPadding
                currentY += attribute.frame.height + minimumLineSpacing
            }
            
            // 아이템 위치 설정
            attribute.frame.origin.x = currentX
            attribute.frame.origin.y = currentY
            
            // 다음 아이템의 x 위치 업데이트
            currentX += attribute.frame.width + minimumInteritemSpacing
        }
        
        return attributes
    }
}

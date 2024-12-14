//
//  LayoutConverter.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/12/24.
//

import Foundation
import UIKit

struct LayoutConverter {
    // 생성자 호출 방지
    private init() {}
    
    // 기준이 되는 디바이스 설정 (iPhone 13 기준)
    private static let baseWidth: CGFloat = 360
    private static let baseHeight: CGFloat = 640
    
    // 현재 디바이스의 스크린 사이즈
    private static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    // 가로/세로 비율
    private static var widthRatio: CGFloat {
        return screenSize.width / baseWidth
    }
    
    private static var heightRatio: CGFloat {
        return screenSize.height / baseHeight
    }
    
    static func convert(_ figmaValue: CGFloat) -> CGFloat {
        return round(figmaValue * widthRatio)
    }
    
    static func convertHeight(_ figmaValue: CGFloat) -> CGFloat {
        return round(figmaValue * heightRatio)
    }
    
    static func convert(_ figmaValues: CGFloat...) -> [CGFloat] {
        return figmaValues.map { convert($0) }
    }
    
    static func convertInsets(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: convert(top),
            left: convert(left),
            bottom: convert(bottom),
            right: convert(right)
        )
    }
}

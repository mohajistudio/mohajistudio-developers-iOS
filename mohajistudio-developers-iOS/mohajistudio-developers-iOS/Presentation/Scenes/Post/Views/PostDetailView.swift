//
//  PostDetailView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/3/25.
//

import UIKit

class PostDetailView: UIView {

    private let backButton = UIButton().then {
        $0.tintColor = UIColor(named: "Primary")
        $0.setTitle("Back", for: .normal)
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    

}

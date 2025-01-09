//
//  MultipartFormData.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/26/24.
//

import Foundation

struct MultipartFormData {
    let name: String
    let fileName: String?
    let mimeType: String?
    let data: Data
    
    init(name: String, fileName: String?, mimeType: String? = nil, data: Data) {
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
}

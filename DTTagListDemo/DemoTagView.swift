//
//  TagView.swift
//  TagListDemo
//
//  Created by Eden on 2020/5/5.
//  Copyright © 2020 Darktt Pensinal Compenly. All rights reserved.
//

import UIKit

class DemoTagView: DTTagView
{
    // MARK: - Properties -
    
    override var contentRect: CGRect {
        
        var contentRect: CGRect = self.tagLabel.bounds
        contentRect.size.width += 16.0
        contentRect.size.height += 4.0
        
        return contentRect
    }
    
    private var tagLabel: UILabel!
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    convenience init(text: String)
    {
        self.init(frame: .zero)
        
        let frame = CGRect(x: 8.0, y: 2.0, width: 0.0, height: 0.0)
        let tagLabel = UILabel(frame: frame)
        tagLabel.text =  text
        tagLabel.sizeToFit()
        
        self.addSubview(tagLabel)
        self.tagLabel = tagLabel
        
        let layer: CALayer = self.layer
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
    
    deinit
    {
        
    }
}

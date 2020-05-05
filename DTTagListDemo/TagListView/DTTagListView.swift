//
//  TagListView.swift
//
//  Created by Darktt on 2020/5/5.
//  Copyright © 2020 Darktt Pensinal Compenly. All rights reserved.
//

import UIKit

public class DTTagListView: UIView
{
    // MARK: - Properties -
    
    @IBInspectable
    public var columnMargin: CGFloat = 0.0 {
        
        didSet {
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable
    public var rowMargin: CGFloat = 0.0 {
        
        didSet {
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero {
        
        didSet {
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        
        var intrinsicContentSize: CGSize = self.bounds.size
        intrinsicContentSize.height = self.contentHeight
        
        return intrinsicContentSize
    }
    
    private var contentHeight: CGFloat = 0.0
    private var tagViews: [DTTagView] = []
    
    private var nextPosition: CGPoint = CGPoint.zero
    private var previousTagViewHeight: CGFloat = 0.0
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        guard !self.tagViews.isEmpty else {
            
            self.contentHeight = 0.0
            return
        }
        
        let x: CGFloat = self.edgeInsets.left
        let y: CGFloat = self.edgeInsets.top
        self.nextPosition = CGPoint(x: x, y: y)
        self.previousTagViewHeight = 0.0
        
        self.tagViews.forEach {
            
            self.setupTagView($0)
            self.addSubview($0)
        }
        
        let contentHeight: CGFloat = self.nextPosition.y + self.previousTagViewHeight + self.edgeInsets.bottom
        
        self.contentHeight = contentHeight
        self.invalidateIntrinsicContentSize()
    }
    
    deinit
    {
        self.tagViews.removeAll()
    }
    
    public func addTagView<TagView>(_ view: TagView) where TagView: DTTagView
    {
        self.tagViews.append(view)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    public func addTagViews<TagView>(_ view: TagView...) where TagView: DTTagView
    {
        self.tagViews += view
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    public func removeTagView<TagView>(_ view: TagView) where TagView: DTTagView
    {
        self.tagViews.removeAll(where: { $0 == view })
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    public func removeAllTagViews()
    {
        self.tagViews.removeAll()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

// MARK: - Private Methods -

private extension DTTagListView
{
    func setupTagView(_ tagView: DTTagView)
    {
        let remainWidth: CGFloat = self.bounds.width - self.edgeInsets.left - self.nextPosition.x - self.edgeInsets.right
        var tagFrame: CGRect = tagView.contentRect
        
        if remainWidth >= tagFrame.width {
            
            // ** Insert to remain space **
            
            tagFrame.origin = self.nextPosition
            
            self.nextPosition.x = tagFrame.maxX + self.columnMargin
            
            if self.previousTagViewHeight < tagFrame.height {
                
                self.previousTagViewHeight = tagFrame.height
            }
        } else {
            
            // ** Insert to new row **
            
            var origin = CGPoint.zero
            origin.x = self.edgeInsets.left
            origin.y = self.nextPosition.y + self.previousTagViewHeight + self.rowMargin
            
            tagFrame.origin = origin
            
            self.nextPosition.x = tagFrame.maxX + self.rowMargin
            self.nextPosition.y = origin.y
            
            self.previousTagViewHeight = tagFrame.height
        }
        
        tagView.frame = tagFrame
    }
}

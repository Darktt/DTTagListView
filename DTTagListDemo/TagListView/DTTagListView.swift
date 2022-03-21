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
    
    @IBInspectable
    public var alignment: Alignment = .left {
        
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
    private var tagViews: Array<DTTagView> = []
    
    private weak var currentRowView: UIView? = nil
    private var rowViews: Array<UIView> = []
    
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
        self.rowViews.removeAll()
        
        guard !self.tagViews.isEmpty else {
            
            self.contentHeight = 0.0
            return
        }
        
        self.nextPosition = CGPoint.zero
        self.previousTagViewHeight = 0.0
        
        self.rearrangeViews()
        
        let contentHeight: CGFloat = self.nextPosition.y + self.previousTagViewHeight + self.edgeInsets.bottom
        
        self.contentHeight = contentHeight
        self.invalidateIntrinsicContentSize()
    }
    
    deinit
    {
        self.tagViews.removeAll()
    }
    
    @objc
    public func addTagView(_ view: DTTagView)
    {
        self.addTagViews(view)
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
    func generatorRowView(y: CGFloat) -> UIView
    {
        var frame = CGRect.zero
        frame.origin.x = self.edgeInsets.left
        frame.origin.y = y
        
        let rowView = UIView(frame: frame);
        
        self.addSubview(rowView)
        self.rowViews.append(rowView);
        
        return rowView
    }
    
    func rearrangeViews()
    {
        let rowView: UIView = self.generatorRowView(y: self.edgeInsets.top)
        
        self.currentRowView = rowView
        
        let currentWidth = self.bounds.width - self.edgeInsets.left - self.edgeInsets.right
        var currentRowWidth = CGFloat.zero
        var nextPosition: CGPoint = self.nextPosition
        
        self.tagViews.forEach {
            
            var contentRect: CGRect = $0.contentRect
            
            if (currentRowWidth + contentRect.width) > currentWidth {
                
                // ** Insert to new row **
                currentRowWidth = 0.0
                self.nextPosition.x = 0.0
                
                let rowViewY: CGFloat = self.edgeInsets.top + self.previousTagViewHeight + self.rowMargin
                let rowView: UIView = self.generatorRowView(y: rowViewY)
                
                self.currentRowView = rowView
            }
            
            contentRect.origin = self.nextPosition
            
            $0.frame = contentRect
            
            nextPosition.x = $0.frame.maxX + self.columnMargin
            currentRowWidth = nextPosition.x
            
            self.currentRowView?.frame.size.width = currentRowWidth
            self.currentRowView?.frame.size.height = contentRect.height
            self.currentRowView?.addSubview($0)
            
            self.nextPosition = nextPosition
            self.previousTagViewHeight = max(self.previousTagViewHeight, self.currentRowView?.frame.maxY ?? 0.0)
            self.adjustRowView()
        }
    }
    
    func adjustRowView()
    {
        guard let currentRowView: UIView = self.currentRowView else {
            
            return
        }
        
        let currentRowWidth: CGFloat = currentRowView.bounds.width
        var rowViewX: CGFloat = self.edgeInsets.left
        
        if self.alignment == .center {
            
            rowViewX = (self.bounds.width - currentRowWidth + self.columnMargin) / 2.0
        }
        
        if self.alignment == .right {
            
            rowViewX = (self.bounds.width - currentRowWidth - self.edgeInsets.right + self.columnMargin)
        }
        
        currentRowView.frame.origin.x = rowViewX
    }
}

// MARK: DTTagListView.Alignment

public extension DTTagListView
{
    @objc(DTTagListViewAlignment)
    enum Alignment: Int {
        
        case left
        
        case center
        
        case right
    }
}

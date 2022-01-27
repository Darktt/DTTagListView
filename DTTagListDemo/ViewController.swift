//
//  ViewController.swift
//  TagListDemo
//
//  Created by Eden on 2020/5/5.
//  Copyright © 2020 Darktt Pensinal Compenly. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet fileprivate var inputAccessoryBar: UIToolbar!
    @IBOutlet fileprivate weak var textField: UITextField!
    @IBOutlet fileprivate weak var columnMarginLabel: UILabel!
    @IBOutlet fileprivate weak var rowMarginLabel: UILabel!
    @IBOutlet fileprivate weak var tagListView: DTTagListView!
    
    private let tagColors: Array<UIColor> = [UIColor.red, UIColor.cyan, UIColor.green, UIColor.orange, UIColor.yellow, UIColor.brown]
    
    override var inputAccessoryView: UIView?
    {
        
        return self.inputAccessoryBar
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.textField.clearButtonMode = .unlessEditing
        
        let edgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        
        self.tagListView.edgeInsets = edgeInsets
        self.tagListView.columnMargin = 10.0
        self.tagListView.rowMargin = 5.0
    }
}

extension ViewController
{
    @IBAction func addTagAction(_ sender: UIButton)
    {
        guard let tagText: String = self.textField.text else {
            
            return
        }
        
        let tagView = DemoTagView(text: tagText)
        tagView.backgroundColor = self.tagColors.randomElement()
        
        self.tagListView.addTagView(tagView)
    }
    
    @IBAction func columnMarginUpdateAction(_ sender: UIStepper)
    {
        self.columnMarginLabel.text = "\(Int(sender.value))"
        self.tagListView.columnMargin = CGFloat(sender.value)
    }
    
    @IBAction func rowMarginUpdateAction(_ sender: UIStepper)
    {
        self.rowMarginLabel.text = "\(Int(sender.value))"
        self.tagListView.rowMargin = CGFloat(sender.value)
    }
    
    @IBAction func editingDoneAction(_ sender: UIBarButtonItem)
    {
        self.view.endEditing(true)
    }
}

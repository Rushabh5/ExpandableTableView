//
//  BaseTableViewCell.swift
//  ExpandableTableView
//
//  Created by Rushabh Shah on 27/06/19.
//  Copyright © 2019 Rushabh. All rights reserved.
//

import UIKit

open class BaseTableViewCell : UITableViewCell {
    var menuItem: MenuItem? {
        didSet {
            if let menuItem = menuItem {
                itemLabel.text = menuItem.value.uppercased()
                itemLabel.numberOfLines = 2
                itemLabelLeftConstant.constant = (15.0 * CGFloat(menuItem.depth)) + 5
                itemSelectionIndicatorPoleVieW.isHidden = !menuItem.isSelected
                
                if menuItem.depth == 0{
                    if #available(iOS 8.2, *) {
                        itemLabel.font = UIFont.systemFont(ofSize:  15, weight: UIFont.Weight.medium)
                    } else {
                        itemLabel.font = UIFont.systemFont(ofSize: 15)
                    }
                    itemLabel.textColor = UIColor(red: 91.0/255.0, green: 91.0/255.0, blue: 91.0/255.0, alpha: 1.0)
                    topSepratorView.isHidden = false
                    
                }else{
                    itemLabel.font = UIFont.systemFont(ofSize: 13)
                    itemLabel.textColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1)
                    topSepratorView.isHidden = true
                }
                if menuItem.isSelected{
                    itemLabel.textColor = UIColor.orange
                }
                if menuItem.canExpand {
                    expandCollapseIndicatorImageView.isHidden = false
                    
                    if menuItem.expandStatus == .collapsed {
                        expandCollapseIndicatorImageView.image = "ic_action_next_item".toImage(isRenderingModeTemplate: true, doFlipImage: true)
                    } else {
                        expandCollapseIndicatorImageView.image = "ic_action_expand".toImage(isRenderingModeTemplate: true, doFlipImage: true)
                        
                    }
                    
                } else {
                    expandCollapseIndicatorImageView.isHidden = true
                }
            }
        }
    }
    
    
    let topSepratorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        return view
    }()
    
    let itemSelectionIndicatorPoleVieW: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.text = "".uppercased()
        return label
    }()
    
    let expandCollapseIndicatorImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "ic_action_expand")
        return iv
    }()
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    var itemLabelLeftConstant: NSLayoutConstraint!
    
    func commonInit() {
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        addSubview(itemSelectionIndicatorPoleVieW)
        addSubview(itemLabel)
        addSubview(expandCollapseIndicatorImageView)
        addSubview(topSepratorView)
        
        addConstraintsWithFormat("H:|[v0(2)]", views: itemSelectionIndicatorPoleVieW)
        itemLabelLeftConstant = NSLayoutConstraint(item: itemLabel, attribute: .leading, relatedBy: .equal, toItem: itemSelectionIndicatorPoleVieW, attribute: .trailing, multiplier: 1, constant: 0)
        addConstraint(itemLabelLeftConstant)
        addConstraintsWithFormat("H:[v0]-34-|", views: itemLabel)
        addConstraintsWithFormat("V:|-2-[v0]-2-|", views: itemSelectionIndicatorPoleVieW)
        addConstraintsWithFormat("V:|[v0]|", views: itemLabel)
        
        addConstraintsWithFormat("H:[v0(20)]-12-|", views: expandCollapseIndicatorImageView)
        addConstraint(NSLayoutConstraint(item: expandCollapseIndicatorImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintsWithFormat("V:[v0(20)]", views: expandCollapseIndicatorImageView)
        
        addConstraintsWithFormat("H:|[v0]|", views: topSepratorView)
        addConstraintsWithFormat("V:|[v0(1)]", views: topSepratorView)
        
    }
    
    
}
extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) -> Void {
        var viewsDirectory = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDirectory[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDirectory))
    }
}

extension String {
    func toImage(isRenderingModeTemplate mode: Bool = false, doFlipImage flipImage: Bool = false) -> UIImage {
        return  UIImage(named: self)!.withRenderingMode(mode ? .alwaysTemplate : .alwaysOriginal)
    }
}

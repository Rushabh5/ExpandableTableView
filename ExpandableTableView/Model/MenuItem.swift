//
//  MenuItem.swift
//  ExpandableTableView
//
//  Created by Rushabh Shah on 27/06/19.
//  Copyright © 2019 Rushabh. All rights reserved.
//

import UIKit

public enum MenuItemExpandStatus: Int {
    case collapsed = 0
    case expanded
}

class MenuItem: NSObject {
    var categoryId: String = ""
    var value: String = ""
    var depth: Int = 0
    var parentCategoryId: String = ""
    var childCategoryId: String = ""
    var isSelected: Bool = false
    var visibleStatus: Bool = false
    var canExpand: Bool = false
    var expandStatus: MenuItemExpandStatus = .collapsed
}

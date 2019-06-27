//
//  ViewController.swift
//  ExpandableTableView
//
//  Created by Rushabh Shah on 27/06/19.
//  Copyright © 2019 Rushabh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dict: [String: Any]?
    var menuItems = [MenuItem]()
    var lastSelectedIndexPath: IndexPath?
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:
    //MARK: UIViewController Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getJsonData()
    }
    
    func getJsonData () {
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String: Any] {
                    dict = jsonResult
                    loadJSonData()
                    tableView.reloadData()
                }
            } catch {
            }
        }
    }
    var responseJSON: [String: Any]?
    func loadJSonData() {
        responseJSON = dict
        self.menuItems.removeAll()
        self.loadNewItems(responseJSON!, parentKey: "", visibleStatus: true, depth: 0)
    }
    func loadNewItems(_ category: [String: Any], parentKey: String, visibleStatus: Bool,depth: Int) {
        var rootItemModel = MenuItem()
        let filteredKeysOnly = category.keys.filter({return !$0.contains("subcats_")})
        let sortedKeys = filteredKeysOnly.sorted(by: { return $0 < $1})

        for orderKey in sortedKeys {
            if orderKey.contains("subcats_") {
                continue
            }
            var rootKey = ""
            var rootLabel = ""
            
            if !parentKey.isEmpty {
                rootKey = orderKey
                rootLabel = category[orderKey] as? String ?? ""
            } else {
                if let rootKeyValues = category[orderKey] as? [String: Any], let firstKeyValue = rootKeyValues.first {
                    rootKey = firstKeyValue.key
                    rootLabel = firstKeyValue.value as? String ?? ""
                }
            }
            rootItemModel = MenuItem()
            rootItemModel.categoryId = rootKey
            rootItemModel.value = rootLabel
            rootItemModel.depth = depth
            rootItemModel.visibleStatus = visibleStatus
            rootItemModel.isSelected = false
            rootItemModel.parentCategoryId = parentKey
            rootItemModel.expandStatus = .collapsed
            if let categoryList = category["subcats_\(rootKey)"] as? [String: Any] {
                rootItemModel.canExpand = true
                rootItemModel.childCategoryId = "subcats_\(rootKey)"
                self.menuItems.append(rootItemModel)
                self.loadNewItems(categoryList, parentKey: rootKey, visibleStatus: false, depth: depth + 1)
            } else {
                rootItemModel.canExpand = false
                self.menuItems.append(rootItemModel)
            }
        }
    }
    
    func setupTableView() {
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: "expandableItemCell")
    }
    
    
    func getVisibleItems() -> [MenuItem] {
        return self.menuItems.filter({ $0.visibleStatus == true })
    }
    
    //MARK:
    //MARK: UITableView Datasource and Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 45
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getVisibleItems().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let menuItem = getVisibleItems()[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "expandableItemCell", for: indexPath) as! BaseTableViewCell
            cell.menuItem = menuItem
            if getVisibleItems()[indexPath.row].isSelected == false{
                cell.backgroundColor = UIColor.clear
            }
            else{
                cell.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 236.0/255.0, alpha: 1.0)
            }
            return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if lastSelectedIndexPath != nil {
            getVisibleItems()[lastSelectedIndexPath!.row].isSelected = false
        }
        getVisibleItems()[indexPath.row].isSelected = true
        lastSelectedIndexPath = indexPath
        menuDidTapped(atIndexPath: indexPath)
    }
    
    
    func menuDidTapped(atIndexPath indexPath: IndexPath) {
        let selectedMenuItem = getVisibleItems()[indexPath.row]
        
        if !selectedMenuItem.canExpand {
            let selectedMenuIndex = getVisibleItems().index(where: { $0.categoryId == selectedMenuItem.categoryId })!
            for item in getVisibleItems() {
                item.isSelected = false
            }
            
            
            getVisibleItems()[selectedMenuIndex].isSelected = true
            
            
            
            if selectedMenuItem.categoryId == "9999" {
                print(selectedMenuItem.parentCategoryId)
            } else {
                print(selectedMenuItem.categoryId)
            }
        } else {
            if selectedMenuItem.expandStatus == .collapsed {
                setDefaultState()
                updateHirarchy(tillItem: selectedMenuItem)
            } else {
                setDefaultState()
                if let parentMenuItem = self.menuItems.filter({ $0.categoryId == selectedMenuItem.parentCategoryId }).first {
                    updateHirarchy(tillItem: parentMenuItem)
                } else {
                    tableView.reloadData()
                }
            }
        }
    }
    func setDefaultState() {
        for item in self.menuItems {
            item.expandStatus = .collapsed
            item.isSelected = false
            item.visibleStatus = (item.depth == 0)
        }
        lastSelectedIndexPath = nil
    }
    func updateHirarchy(tillItem endItem: MenuItem) {
        var parentsIds = [String]()
        var tempItem = endItem
        parentsIds.append(endItem.categoryId)
        while tempItem.parentCategoryId != "" {
            tempItem = self.menuItems.filter({ $0.categoryId ==  tempItem.parentCategoryId}).first!
            parentsIds.append(tempItem.categoryId)
        }
        for item in self.menuItems {
            if parentsIds.contains(item.categoryId) {
                item.expandStatus = .expanded
                item.visibleStatus = true
                for childItem in getChildren(ofParent: item) {
                    childItem.visibleStatus = true
                    childItem.isSelected = false
                }
            }
        }
        tableView.reloadData()
    }
    
    func getChildren(ofParent parentItem: MenuItem) -> [MenuItem] {
        if parentItem.canExpand {
            return self.menuItems.filter({ $0.parentCategoryId == parentItem.categoryId })
        }
        return []
    }
}


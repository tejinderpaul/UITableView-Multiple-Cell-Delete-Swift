//
//  ViewController.swift
//  TableViewMultipleCellSelection
//
//  Created by Tejinder Paul Singh on 9/16/16.
//  Copyright © 2016 Tejinder Paul Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
  @IBOutlet weak var deleteButton: UIBarButtonItem!
  
  @IBOutlet weak var editButton: UIBarButtonItem!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  var dataArray:[String] = []
  
  @IBOutlet weak var tableViewTest: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.tableViewTest.allowsMultipleSelectionDuringEditing = true
    
    self.dataArray = []

    for i in 0..<10{
      dataArray.append("item" + String(i))
    }
    
    print(dataArray)
    
    
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func editAction(_: AnyObject) {
    tableViewTest.setEditing(true, animated: true)
    self.updateButtonsToMatchTableState()
  }
  
  
  @IBAction func cancelAction(_: AnyObject) {
    tableViewTest.setEditing(false, animated: true)
    self.updateButtonsToMatchTableState()
  }
  
  fileprivate func updateButtonsToMatchTableState() {
    
    if self.tableViewTest.isEditing {
     
      
      self.updateDeleteButtonTitle()

    
    } else {

 
     // self.editButton.isEnabled = dataArray.isempty
  
    }
  }
  
 
  
  func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
    actionSheetClickedButtonAtIndex(buttonIndex)
  }
  func actionSheetClickedButtonAtIndex(_ buttonIndex: Int) {
    
    if buttonIndex == 0 {
      let selectedRows = self.tableViewTest.indexPathsForSelectedRows!
      let deleteSpecificRows = selectedRows.count > 0
      if deleteSpecificRows {
        let indicesOfItemsToDelete = NSMutableIndexSet()
        for selectionIndex in selectedRows {
          indicesOfItemsToDelete.add((selectionIndex as NSIndexPath).row)
        }
        
        
//        self.dataArray = self.dataArray.enumerated().lazy.filter {(index,_) in
//          !indicesOfItemsToDelete.contains(index)
//          }.map{(_,element) in element}
        
    
        //dataArray.remove(at: 0)
        
        let indexArray = NSMutableArray()
        for (_, element) in selectedRows.enumerated(){
        indexArray.add(element[1])
          
        }
        
        dataArray =   dataArray.enumerated()
          .filter { !indexArray.contains($0.offset) }
          .map { $0.element }
        
        self.tableViewTest.deleteRows(at: selectedRows, with: .automatic)

      } else {
        self.dataArray.removeAll()
        self.tableViewTest.reloadSections(IndexSet(integer: 0), with: .automatic)
      }
      self.tableViewTest.setEditing(false, animated: true)
      self.updateButtonsToMatchTableState()
    }
  }

  
  
  @IBAction func deleteAction(_: AnyObject) {
    
    let actionTitle: String
    if tableViewTest.indexPathsForSelectedRows?.count ?? 0 == 1 {
      actionTitle = "Are you sure you want to remove this item?"
    } else {
      actionTitle = "Are you sure you want to remove these items?"
    }
    if #available(iOS 8.0, *) {
      let actionAlert = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
        self.actionSheetClickedButtonAtIndex(1)
      }
      let okAction = UIAlertAction(title: "OK", style: .destructive) {_ in
        self.actionSheetClickedButtonAtIndex(0)
      }
      actionAlert.addAction(cancelAction)
      actionAlert.addAction(okAction)
      self.present(actionAlert, animated: true, completion: nil)
    } else {
      let actionSheet = UIActionSheet(title: actionTitle,
                                      delegate: self,
                                      cancelButtonTitle: "Cancel",
                                      destructiveButtonTitle: "OK")
      
      actionSheet.actionSheetStyle = UIActionSheetStyle.default
      
      actionSheet.show(in: self.view)
    }
  }
  
  @IBAction func addAction(_: AnyObject) {
    
    tableViewTest.beginUpdates()
    self.dataArray.append("New Item")
    let indexPathOfNewItem = IndexPath(row: ((self.dataArray.count) - 1), section: 0)
    self.tableViewTest.insertRows(at: [indexPathOfNewItem], with: .automatic)
    tableViewTest.endUpdates()
    self.tableViewTest.scrollToRow(at: indexPathOfNewItem, at: .bottom, animated: true)
    self.updateButtonsToMatchTableState()
  }
  
  fileprivate func updateDeleteButtonTitle() {
    
    let selectedRows = self.tableViewTest.indexPathsForSelectedRows ?? []
       let allItemsAreSelected = selectedRows.count == self.dataArray.count
    let noItemsAreSelected = selectedRows.isEmpty
    
    if allItemsAreSelected || noItemsAreSelected {
      self.deleteButton.title = "Delete All"
     
    } else {
      let titleFormatString = "Delete (%d)"
      self.deleteButton.title = String(format: titleFormatString, Int32(selectedRows.count))
    }
  }
  
  
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    self.updateDeleteButtonTitle()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    self.updateButtonsToMatchTableState()
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let kCellID = "cell"
    
    let cell = tableView.dequeueReusableCell(withIdentifier: kCellID)
    
    cell?.textLabel?.text = dataArray[indexPath.row]
    return cell!
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray.count
  }
  
}


//
//  ViewController.swift
//  CustomPC
//
//  Created by Kai on 2022/02/11.
//

import UIKit

class CustomListViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var customTable: UITableView!
    var addBarButtonItem: UIBarButtonItem!
    
    var customs:[Custom]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Customs"
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.navigationItem.leftBarButtonItems = [editButtonItem]
        customs = AccessData.getCustoms()
        
        let nib = UINib(nibName: SearchPartsTableViewCell.cellIdentifier, bundle: nil)
        customTable.register(nib, forCellReuseIdentifier: SearchPartsTableViewCell.cellIdentifier)
        customTable.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        customs = AccessData.getCustoms()
        DispatchQueue.main.async {
            self.customTable.reloadData()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        customTable.isEditing = editing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPartsTableViewCell.cellIdentifier, for: indexPath) as! SearchPartsTableViewCell
        cell.setupCustomListCell(custom: customs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let custom = self.customs[indexPath.row]
        let savedPartsObject = custom.parts?.allObjects as! [Parts]
        let pcparts = PcParts.toPcPartsFromPartsObject(partsObjects: savedPartsObject)
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "StoredCustomViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "StoredCustomViewController")as! StoredCustomViewController
            nextVC.storedParts = pcparts
            nextVC.custom = custom
            nextVC.customTitle = custom.title!
            nextVC.customPrice = custom.price!
            nextVC.title = custom.title!
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cus = self.customs[indexPath.row]
        customs.remove(at: indexPath.row)
        AccessData.deleteCustom(custom: cus)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return UITableViewCell.EditingStyle.delete
            } else {
                return UITableViewCell.EditingStyle.none
            }
    }
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "NewCustomViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "NewCustomViewController")as! NewCustomViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}


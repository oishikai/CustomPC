//
//  SavedCustomViewController.swift
//  CustomPC
//
//  Created by Kai on 2022/07/10.
//

import UIKit

class StoredCustomViewController: UIViewController {
    
    @IBOutlet weak var partsTable: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    var custom :Custom? = nil
    var customTitle = ""
    var customPrice = ""
    var storedParts:[PcParts] = []
    private var sortedParts:[PcParts] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // 保存済みのパーツを NewCustomViewController と同じ順で表示
        self.sortedParts = PcParts.sortParts(partsList: storedParts)
        let nib = UINib(nibName: SearchPartsTableViewCell.cellIdentifier, bundle: nil)
        partsTable.register(nib, forCellReuseIdentifier: SearchPartsTableViewCell.cellIdentifier)
        partsTable.rowHeight = UITableView.automaticDimension
        if self.storedParts.count <= 4 {
            self.partsTable.isScrollEnabled = false
        }
        
        self.priceLabel.text = self.customPrice
        updateButton.backgroundColor = UIColor.darkGray
        updateButton.layer.cornerRadius = 10
        
        UpdateLatestPartsInfo.fetchPartsSpec(pcParts: sortedParts, index: 0) { pcParts in
            self.sortedParts = pcParts
        }
    }
    
    @IBAction func tappedUpdateButton(_ sender: Any) {
        DispatchQueue.main.async { [self] in
            let storyboard = UIStoryboard(name: "NewCustomViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "NewCustomViewController")as! NewCustomViewController
            nextVC.selectedParts = self.sortedParts
            if let custom = self.custom {
                nextVC.storedCustom = custom
                nextVC.compatibilityMsg = custom.message!
            }
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension StoredCustomViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storedParts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPartsTableViewCell.cellIdentifier, for: indexPath) as! SearchPartsTableViewCell
        cell.setup(parts: self.sortedParts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "PartsDetailViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "PartsDetailViewController")as! PartsDetailViewController
            nextVC.pcparts = self.sortedParts[indexPath.row]
            nextVC.visitForSelect = false
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}


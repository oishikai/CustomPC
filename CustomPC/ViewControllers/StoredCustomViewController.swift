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
    var customTitle = ""
    var customPrice = ""
    
    var storedParts:[PcParts] = []
    private var sortedParts:[PcParts] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sortedParts = sortParts(partsList: storedParts)
        
        let nib = UINib(nibName: SearchPartsTableViewCell.cellIdentifier, bundle: nil)
        partsTable.register(nib, forCellReuseIdentifier: SearchPartsTableViewCell.cellIdentifier)
        partsTable.rowHeight = UITableView.automaticDimension
        if self.storedParts.count <= 4 {
            self.partsTable.isScrollEnabled = false
        }
        updateButton.titleLabel?.text = "更新"
        updateButton.titleLabel?.textColor = .white
        updateButton.titleLabel?.font = .systemFont(ofSize: 20)
        updateButton.backgroundColor = UIColor.systemBlue
        updateButton.layer.cornerRadius = 10
    }
    
    @IBAction func tappedUpdateButton(_ sender: Any) {
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
    
    private func sortParts(partsList: [PcParts]) -> [PcParts]{
        var cpu :PcParts? = nil
        var cpuCooler :PcParts? = nil
        var memory :PcParts? = nil
        var motherboard :PcParts? = nil
        var graphicsCard :PcParts? = nil
        var ssd :PcParts? = nil
        var hdd :PcParts? = nil
        var pcCase :PcParts? = nil
        var powerUnit :PcParts? = nil
        var caseFan :PcParts? = nil
        var monitor :PcParts? = nil
        for parts in partsList {
            switch (parts.category) {
            case .cpu:
                cpu = parts
            case .cpuCooler:
                cpuCooler = parts
            case .memory:
                memory = parts
            case .motherBoard:
                motherboard = parts
            case .graphicsCard:
                graphicsCard = parts
            case .ssd:
                ssd = parts
            case .hdd:
                hdd = parts
            case .pcCase:
                pcCase = parts
            case .powerUnit:
                powerUnit = parts
            case .caseFan:
                caseFan = parts
            case .monitor:
                monitor = parts
            }
        }
        
        let optionalPartsList:[PcParts?] = [cpu, cpuCooler, memory, motherboard, graphicsCard, ssd, hdd, pcCase, powerUnit, caseFan, monitor]
        // nillを除く
        let sortedPartsList = optionalPartsList.compactMap{$0}
        
        
        print(sortedPartsList[0].detailUrl)
        return sortedPartsList
    }
}


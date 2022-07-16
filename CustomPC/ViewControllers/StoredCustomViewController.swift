//
//  SavedCustomViewController.swift
//  CustomPC
//
//  Created by Kai on 2022/07/10.
//

import UIKit

class StoredCustomViewController: UIViewController {
    
    @IBOutlet weak var partsTable: UITableView!
    var customTitle = ""
    var customPrice = ""
    
    var storedParts:[PcParts] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.partsTable.allowsSelection = false
        let nib = UINib(nibName: SearchPartsTableViewCell.cellIdentifier, bundle: nil)
        partsTable.register(nib, forCellReuseIdentifier: SearchPartsTableViewCell.cellIdentifier)
        partsTable.rowHeight = UITableView.automaticDimension
        
        if self.storedParts.count <= 4 {
            self.partsTable.isScrollEnabled = false
        }
    }
    
}

extension StoredCustomViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storedParts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPartsTableViewCell.cellIdentifier, for: indexPath) as! SearchPartsTableViewCell
        let sortedPartsList = StoredCustomViewController.sortParts(partsList: storedParts)
        cell.setup(parts: sortedPartsList[indexPath.row])
        return cell
    }
    
    static func sortParts(partsList: [PcParts]) -> [PcParts]{
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
        
        var sortedPartsList :[PcParts] = []
        for p in optionalPartsList {
            guard let p = p else { continue }
            sortedPartsList.append(p)
        }
        
        return sortedPartsList
    }
}


import UIKit

class NewCustomViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var selectedParts:[PcParts] = []
    @IBOutlet weak var selectTable: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var parts = [category.cpu, category.cpuCooler, category.memory, category.motherBoard, category.graphicsCard, category.ssd, category.hdd, category.pcCase, category.powerUnit, category.caseFan, category.monitor, category.testParts]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectTable.layer.borderColor = UIColor.darkGray.cgColor
        selectTable.layer.borderWidth = 0.5
        let nib = UINib(nibName: SearchPartsTableViewCell.cellIdentifier, bundle: nil)
        selectTable.register(nib, forCellReuseIdentifier: SearchPartsTableViewCell.cellIdentifier)
        selectTable.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var totalPrice = 0
        
        for parts in self.selectedParts{
            totalPrice += parts.getPriceInt()
        }
        
        let yen = "¥" + String.localizedStringWithFormat("%d", totalPrice)
        DispatchQueue.main.async {
            self.priceLabel.text = yen
            self.selectTable.reloadData()
        }
        
        // パーツ互換性チェック
        if let cpuAndMother = CheckCompatibility.isSelectedCpuMotherBoard(selected: self.selectedParts) {
            if (CheckCompatibility.compatibilityCpuMotherboard(cpu: cpuAndMother[0], motherboard: cpuAndMother[1])){
            
            }
        }
        
        if let cpuCoolerAndMother = CheckCompatibility.isSelectedCpuCoolerMotherBoard(selected: self.selectedParts) {
            print("selected")
            if (CheckCompatibility.compatibilityCpucoolerMotherboard(cpuCooler: cpuCoolerAndMother[0], motherBoard: cpuCoolerAndMother[1])) {
                print("point")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let partsCategory = parts[indexPath.row].rawValue
        var isSelected = false
        var selectedParts:PcParts?
        
        for parts in self.selectedParts {
            if parts.category.rawValue == partsCategory {
                isSelected = true
                selectedParts = parts
            }
        }
        
        if isSelected {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchPartsTableViewCell.cellIdentifier, for: indexPath) as! SearchPartsTableViewCell
            cell.setup(parts: selectedParts!)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "partsCell", for: indexPath)
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.textLabel?.text = parts[indexPath.row].rawValue
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = parts[indexPath.row]
        SearchParts.searchParts(selectedCategory: selected, searchURL: selected.startPageUrl()) { parts in
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "SearchPartsViewController", bundle: nil)
                let nextVC = storyboard.instantiateViewController(identifier: "SearchPartsViewController")as! SearchPartsViewController
                nextVC.pcPartsSeq = parts
                nextVC.selectedCategory = selected
                nextVC.selectedParts = self.selectedParts
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}


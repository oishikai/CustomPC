import UIKit

class NewCustomViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var selectedParts:[PcParts] = []
    @IBOutlet weak var selectTable: UITableView!
    
    private var parts = [category.cpu, category.cpuCooler, category.memory, category.motherBoard, category.graphicsCard, category.ssd, category.hdd, category.pcCase, category.powerUnit, category.caseFan, category.monitor, category.testParts]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.selectTable.reloadData()
        }
        
        // CPUとマザーボードが選択されているか判定
        var count = 0
        for parts in selectedParts {
            if (parts.category.rawValue == "CPU" || parts.category.rawValue == "マザーボード") {
                count += 1
            }
        }
        
        if (count == 2){
            print("check")
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


import UIKit

class NewCustomViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var selectTable: UITableView!
    
    private let parts = [category.cpu, category.cpuCooler, category.memory, category.graphicsCard, category.ssd, category.hdd, category.pcCase, category.powerUnit, category.caseFan, category.monitor, category.testParts]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "partsCell", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel?.text = parts[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SearchParts.getPartsTitleFirst(selectedCategory: parts[indexPath.row]) { titles in
            DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "SearchPartsViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "SearchPartsViewController")as! SearchPartsViewController
                nextVC.PcPartsSeq = titles
            self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}


import UIKit

class NewCustomViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var selectTable: UITableView!
    
    private let parts = [PcParts.cpu, PcParts.cpuCooler, PcParts.memory, PcParts.graphicsCard, PcParts.ssd, PcParts.hdd, PcParts.pcCase, PcParts.powerUnit, PcParts.caseFan]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "partsCell", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel?.text = parts[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SearchParts.getPartsTitleFirst(parts: parts[indexPath.row]) { titles in
            DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "SearchPartsViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "SearchPartsViewController")as! SearchPartsViewController
                nextVC.titles = titles
            self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}


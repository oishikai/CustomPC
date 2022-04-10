import UIKit

class NewCustomViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var selectTable: UITableView!
    
    private let parts = ["CPU", "CPUクーラー", "メモリ", "グラボ/ビデオカード", "SSD", "HDD", "ケース", "電源", "ケースファン"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "partsCell", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel?.text = parts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "SearchPartsViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "SearchPartsViewController")as! SearchPartsViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}


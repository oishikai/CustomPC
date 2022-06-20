import UIKit

class NewCustomViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    var selectedParts:[PcParts] = []
    @IBOutlet weak var selectTable: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var compatibilityLabel: UILabel!
    @IBOutlet weak var keepButton: UIButton!
    
    var cancelButton: UIBarButtonItem!
    var compatibilityMsg:String = ""
    
    private var parts = [category.cpu, category.cpuCooler, category.memory, category.motherBoard, category.graphicsCard, category.ssd, category.hdd, category.pcCase, category.powerUnit, category.caseFan, category.monitor]
    
    override func viewDidLoad() {
        self.title = "Combination"
        super.viewDidLoad()
        selectTable.layer.borderColor = UIColor.darkGray.cgColor
        selectTable.layer.borderWidth = 0.5
        
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel(_:)))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        compatibilityLabel.text = compatibilityMsg
        compatibilityLabel.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        compatibilityLabel.layer.borderColor = UIColor.gray.cgColor
        keepButton.backgroundColor = UIColor.red
        keepButton.layer.cornerRadius = 10
        
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
        //        var compCpuMother :Bool? = nil
        //        if let cpuAndMother = CheckCompatibility.isSelectedCpuMotherBoard(selected: self.selectedParts) {
        //            if CheckCompatibility.compatibilityCpuMotherboard(cpu: cpuAndMother[0], motherboard: cpuAndMother[1]){
        //                compCpuMother = true
        //            }else {
        //                compCpuMother = false
        //            }
        //        }
        //
        //        var compCpuCoolerMother :Bool? = nil
        //        if let cpuCoolerAndMother = CheckCompatibility.isSelectedCpuCoolerMotherBoard(selected: self.selectedParts) {
        //            if CheckCompatibility.compatibilityCpucoolerMotherboard(cpuCooler: cpuCoolerAndMother[0], motherBoard: cpuCoolerAndMother[1]) {
        //                compCpuCoolerMother = true
        //            }else {
        //                compCpuCoolerMother = false
        //            }
        //        }
        //
        //        self.compatibilityLabel.text = CheckCompatibility.compatibilityMessage(cpuMother: compCpuMother, cpuCoolerMother: compCpuCoolerMother)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        let alert = UIAlertController(title: "見積もりキャンセル", message: "選択したパーツは保存されません", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (acrion) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapKeepButton(_ sender: Any) {
        
        if (selectedParts.count == 0) {
            let alert = UIAlertController(title: "パーツを選択してください", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel) { (acrion) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        var alertTextField:UITextField!
        alert.title = "見積もりタイトル"
        //alert.message = "例"
        alert.addTextField(configurationHandler: {(textField) -> Void in
            textField.delegate = self
            alertTextField = textField
        })
        
        alert.addAction(
            UIAlertAction(
                title: "追加",
                style: .default,
                handler: {(action) -> Void in
                    print(alertTextField.text!)
                    if (alertTextField.text! == ""){
                        print("hi")
                    }
                    print(self.priceLabel.text)
                    AccessData.storeCustom(title: alertTextField.text!, price: self.priceLabel.text!, message: self.compatibilityMsg, parts: self.selectedParts)
                })
        )
        
        //キャンセルボタン
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel
//                ,handler: {(action) -> Void in
//                }
            )
        )
        
        //アラートが表示されるごとにprint
        self.present(
            alert,
            animated: true
//            ,completion: {
//                print("アラートが表示された")
//            }
            )
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




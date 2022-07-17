import UIKit
import Nuke

class PartsDetailViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var makerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var specTableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
    var selectedParts:[PcParts] = []
    var pcparts: PcParts?
    private var urls = [URL]()
    private var currentIndex = 0
    private var specData = [String]()
    private var priceData = [String]()
    var searchButtonItem: UIBarButtonItem!
    var visitForSelect = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        contentsView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        pageControl.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.green
        makerLabel.backgroundColor = UIColor.white
        titleLabel.backgroundColor = UIColor.white
        priceLabel.backgroundColor = UIColor.white
        specTableView.layer.borderColor = UIColor.darkGray.cgColor
        specTableView.layer.borderWidth = 1.0
        searchButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapSearch(_:)))
        self.navigationItem.rightBarButtonItem = searchButtonItem
        
        if !visitForSelect {
            self.selectButton.isEnabled = false
        }
        if let parts = pcparts {
            self.makerLabel.text = "   " + parts.maker
            self.titleLabel.text = parts.title
            self.priceLabel.text = parts.price
            let imageUrl = parts.detailUrl.replacingOccurrences(of: "?lid=pc_ksearch_kakakuitem", with: "") + "images/"
            ParseDetails.getFullscaleImages(detailUrl: imageUrl, urls: urls) { urls in
                self.urls = urls
                DispatchQueue.main.async {
                    self.pageControl.numberOfPages = urls.count
                    self.pageControl.reloadInputViews()
                    self.collectionView.reloadData()
                }
            }
            
            ParseDetails.getSpec(detailUrl: parts.detailUrl) { specs in
                self.specData = specs
                DispatchQueue.main.async {
                    self.specTableView.reloadData()
                }
                
                if parts.category.rawValue == "CPU"{
                    for spec in specs {
                        if (spec.contains("世代第")){
                            parts.specs.append(spec)
                        }
                        
                        if (spec.contains("ソケット形状")){
                            parts.specs.append(spec)
                        }
                    }
                }
                
                if parts.category.rawValue == "マザーボード" {
                    for spec in specs {
                        if (spec.contains("チップセット")){
                            parts.specs.append(spec)
                        }
                        
                        if (spec.contains("CPUソケット")){
                            parts.specs.append(spec)
                        }
                    }
                }
                
                if parts.category.rawValue == "CPUクーラー" {
                    for spec in specs {
                        if (spec.contains("Intel対応ソケット")){
                            parts.specs.append(spec)
                        }
                        
                        if (spec.contains("AMD対応ソケット")){
                            parts.specs.append(spec)
                        }
                    }
                }
            }
            
            if (parts.price == "価格情報無し"){
                self.selectButton.isEnabled = false
                self.selectButton.setTitle("価格情報が無いため選択できません", for: .normal)
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func selectButton(_ sender: Any) {
        guard let pcparts = self.pcparts else { return }
        var selectedSameCategory = false
        for (index, p) in selectedParts.enumerated() {
            if (p.category == pcparts.category){
                selectedSameCategory = true
                selectedParts[index] = pcparts
            }
        }
        
        if (!selectedSameCategory){
            selectedParts.append(pcparts)
        }
        
        var compCpuMother :Bool? = nil
        if let cpuAndMother = CheckCompatibility.isSelectedCpuMotherBoard(selected: self.selectedParts) {
            if CheckCompatibility.compatibilityCpuMotherboard(cpu: cpuAndMother[0], motherboard: cpuAndMother[1]){
                compCpuMother = true
            }else {
                compCpuMother = false
            }
        }
        
        var compCpuCoolerMother :Bool? = nil
        if let cpuCoolerAndMother = CheckCompatibility.isSelectedCpuCoolerMotherBoard(selected: self.selectedParts) {
            if CheckCompatibility.compatibilityCpucoolerMotherboard(cpuCooler: cpuCoolerAndMother[0], motherBoard: cpuCoolerAndMother[1]) {
                compCpuCoolerMother = true
            }else {
                compCpuCoolerMother = false
            }
        }
        
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "NewCustomViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "NewCustomViewController")as! NewCustomViewController
            nextVC.selectedParts = self.selectedParts
            nextVC.compatibilityMsg = CheckCompatibility.compatibilityMessage(cpuMother: compCpuMother, cpuCoolerMother: compCpuCoolerMother)
            let transition = CATransition()
            
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            self.navigationController!.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func didTapSearch(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "PartsWebViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "PartsWebViewController")as! PartsWebViewController
            nextVC.targetUrl = self.pcparts!.detailUrl
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension PartsDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartsImageCollectionViewCell", for: indexPath) as! PartsImageCollectionViewCell
        cell.setup(imageUrl: self.urls[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screen_width = UIScreen.main.bounds.size.width
        return CGSize(width: screen_width, height: screen_width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = currentIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension PartsDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "specCell")
        let specItems = self.pcparts?.category.specItems()
        
        if let specItems = specItems {
            let data = self.specData[indexPath.row]
            for specItem in specItems {
                if (specItem == data){
                    cell.textLabel?.text = data
                    cell.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
                    return cell
                }
                
                if (data.contains(specItem)){
                    let splitItemData = data.replacingOccurrences(of: specItem, with: specItem + " : ")
                    cell.textLabel?.text = splitItemData
                    cell.textLabel?.numberOfLines = 0
                    return cell
                }
            }
        }
        
        return cell
    }
}


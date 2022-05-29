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
    @IBOutlet weak var priceTableView: UITableView!
    
    var pcparts: PcParts?
    private var urls = [URL]()
    private var currentIndex = 0
    private var specData = [String]()
    private var priceData = [String]()
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
        priceTableView.layer.borderColor = UIColor.darkGray.cgColor
        priceTableView.layer.borderWidth = 1.0
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
                print(specs)
                DispatchQueue.main.async {
                    self.specTableView.reloadData()
                }
            }
            
            ParseDetails.getPrices(detailUrl: parts.detailUrl) { prices in
                self.priceData = prices
                print(prices)
                DispatchQueue.main.async {
                    self.priceTableView.reloadData()
                }
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        collectionView.collectionViewLayout = layout
    }
    
    func getImageByUrl(imageUrl: URL) -> UIImage{
        do {
            let data = try Data(contentsOf: imageUrl)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
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
        if (tableView.tag == 0){
            return specData.count
        }else{
            return priceData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: .default, reuseIdentifier: "specCell")
        if tableView.tag == 0 {
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
                        var splitItemData = data.replacingOccurrences(of: specItem, with: specItem + " : ")
                        cell.textLabel?.text = splitItemData
                        cell.textLabel?.numberOfLines = 0
                        return cell
                    }
                }
            }
        }else if tableView.tag == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "priceCell")
            cell.textLabel?.text = self.priceData[indexPath.row * 3] + " : " + self.priceData[indexPath.row * 3 + 1] + " : " + self.priceData[indexPath.row * 3 + 2]
            return cell
        }
        return a
    }
    
    
}


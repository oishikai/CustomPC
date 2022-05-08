import UIKit
import Nuke

class PartsDetailViewController: UIViewController{
    
    // @IBOutlet weak var partsImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var contentsView: UIView!
    
    var pcparts: PcParts?
    private var urls = [URL]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        contentsView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        //        partsImageView.backgroundColor = UIColor.white
        //        makerLabel.backgroundColor = UIColor.white
        //R:220 G:220 B:220
        pageControl.backgroundColor = UIColor.gray
        if let parts = pcparts {
            let imageUrl = parts.detailUrl.replacingOccurrences(of: "?lid=pc_ksearch_kakakuitem", with: "") + "images/"
            
            ParseDetails.getFullscaleImages(detailUrl: imageUrl, urls: urls) { urls in
                print(urls.count)
                self.urls = urls
                DispatchQueue.main.async {
                    self.pageControl.numberOfPages = urls.count
                    self.pageControl.reloadInputViews()
                    self.collectionView.reloadData()
                }
            }
            //            makerLabel.text = "    " + parts.maker
        }
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
        let image = self.getImageByUrl(imageUrl: self.urls[indexPath.row])
        print(image.size.width,image.size.height)
        return CGSize(width: image.size.width, height: image.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = currentIndex
    }
}


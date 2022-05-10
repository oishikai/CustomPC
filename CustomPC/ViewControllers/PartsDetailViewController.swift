import UIKit
import Nuke

class PartsDetailViewController: UIViewController{
    
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
        pageControl.backgroundColor = UIColor.gray
        if let parts = pcparts {
            let imageUrl = parts.detailUrl.replacingOccurrences(of: "?lid=pc_ksearch_kakakuitem", with: "") + "images/"
            
            ParseDetails.getFullscaleImages(detailUrl: imageUrl, urls: urls) { urls in
                print(urls.count)
                self.urls = urls
                print("viewFrame=",self.collectionView.frame.size.width)
                DispatchQueue.main.async {
                    self.pageControl.numberOfPages = urls.count
                    self.pageControl.reloadInputViews()
                    self.collectionView.reloadData()
                    print("viewFrame=",self.collectionView.frame.size.width)
                }
            }
        }
        
        let layout = UICollectionViewFlowLayout()
          layout.scrollDirection = .horizontal
//          layout.minimumInteritemSpacing = 0.0
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


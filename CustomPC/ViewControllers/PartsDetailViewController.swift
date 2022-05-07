import UIKit
import Nuke

class PartsDetailViewController: UIViewController{
    
    @IBOutlet weak var partsImageView: UIImageView!
    @IBOutlet weak var makerLabel: UILabel!
    var pcparts: PcParts?
    var fullScaleImage = [URL]()
    @IBOutlet weak var contentsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentsView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        partsImageView.backgroundColor = UIColor.white
        makerLabel.backgroundColor = UIColor.white
        //R:220 G:220 B:220
        if let parts = pcparts {
            
            var urls = [URL]()
            
            let imageUrl = parts.detailUrl.replacingOccurrences(of: "?lid=pc_ksearch_kakakuitem", with: "") + "images/"
            getFullscaleImages(detailUrl: imageUrl, urls: urls) { urls in
                print(urls.count)
            }
            
            makerLabel.text = "    " + parts.maker
        }
    }
    
    private func getFullscaleImages(detailUrl :String, urls: [URL], completionHandler: @escaping ([URL]) -> Void) -> Void{
        ParseDetails.getFullscaleImages(detailUrl: detailUrl) { imageUrl in
            guard let url = imageUrl else{
                completionHandler(urls)
                return
            }
            
            var urlss = urls
            urlss.append(url)
            
            var nextUrl: String
            if detailUrl.contains("page=ka_") { // -> true
                nextUrl = detailUrl.replacingOccurrences(of: "page=ka_\(urlss.count - 1)/", with: "page=ka_\(urlss.count)/")
            }else{
                nextUrl = detailUrl + "page=ka_\(urlss.count)/"
            }
//            var nextUrl = detailUrl.replacingOccurrences(of: "?lid=pc_ksearch_kakakuitem", with: "") + "images/"
            self.getFullscaleImages(detailUrl: nextUrl, urls: urlss, completionHandler: completionHandler)
        }
    }
}


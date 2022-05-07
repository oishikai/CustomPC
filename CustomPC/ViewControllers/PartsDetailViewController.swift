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
            
            getFullscaleImages(url: "https://kakaku.com/item/K0001374433/images/", urls: urls) { urls in
                print(urls.count)
            }
            
            makerLabel.text = "    " + parts.maker
        }
    }
    
    private func getFullscaleImages(url :String, urls: [URL], completionHandler: @escaping ([URL]) -> Void) -> Void{
        ParseDetails.getFullscaleImages(detailUrl: url) { url in
            guard let url = url else{
                completionHandler(urls)
                return
            }
            
            var urlss = urls
            urlss.append(url)
            let next = "https://kakaku.com/item/K0001374433/images/page=ka_\(urlss.count)/"
            self.getFullscaleImages(url: next, urls: urlss, completionHandler: completionHandler)
        }
    }
}


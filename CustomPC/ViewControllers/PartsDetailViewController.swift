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

            ParseDetails.getFullscaleImages(detailUrl: parts.detailUrl) { url in
                Nuke.loadImage(with: url, into: self.partsImageView)
            }
            
            makerLabel.text = "    " + parts.maker
        }
    }
}


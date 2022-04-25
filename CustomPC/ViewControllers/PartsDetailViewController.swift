import UIKit
import Nuke

class PartsDetailViewController: UIViewController{
        
    @IBOutlet weak var partsImageView: UIImageView!
    @IBOutlet weak var makerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var pcparts: PcParts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parts = pcparts {
            Nuke.loadImage(with: parts.image, into: partsImageView)
            makerLabel.text = parts.maker
            titleLabel.text = parts.title
            priceLabel.text = parts.price
        }
    }
    
}


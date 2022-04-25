import UIKit
import Nuke

class PartsDetailViewController: UIViewController{
        
    @IBOutlet weak var partsImageView: UIImageView!
    var pcparts: PcParts?
    
    @IBOutlet weak var contentsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentsView.backgroundColor = UIColor.gray
    }
    
}


import UIKit

class SelectPartsViewController: UIViewController{
    
    @IBOutlet weak var cpuTitle: UILabel!
    @IBOutlet weak var cpuPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cpuTitle.isHidden = true
        cpuPrice.isHidden = true
    }

}

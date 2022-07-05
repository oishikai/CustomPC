//
//  CustomModalViewController.swift
//  CustomPC
//
//  Created by Kai on 2022/06/23.
//

import UIKit

class CustomModalViewController: UIViewController {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "hoge"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("aaa")
        // Do any additional setup after loading the view.
    }
    
//    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "CustomModalViewController", bundle: nil)) -> CustomModalViewController{
//        let controller = storyboard.instantiateViewController(withIdentifier: "CustomModalViewController") as! CustomModalViewController
//        return controller
//    }
}

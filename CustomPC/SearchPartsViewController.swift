//
//  SearchPartsViewController.swift
//  CustomPC
//
//  Created by Kai on 2022/04/10.
//

import UIKit

import Alamofire
import Kanna

class SearchPartsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var searchTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        DispatchQueue.main.async {
//            let storyboard = UIStoryboard(name: "NewCustomViewController", bundle: nil)
//            let nextVC = storyboard.instantiateViewController(identifier: "NewCustomViewController")as! NewCustomViewController
//            self.navigationController?.pushViewController(nextVC, animated: true)
//        }
    }
}

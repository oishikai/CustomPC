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
    @IBOutlet weak var searchBar: UISearchBar!
    var pcPartsSeq: [PcParts] = []
    var selectedCategory:category = category.testParts
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        let nib = UINib(nibName: SearchPartsTableViewCell.cellIdentifier, bundle: nil)
        searchTable.register(nib, forCellReuseIdentifier: SearchPartsTableViewCell.cellIdentifier)
        searchTable.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pcPartsSeq.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPartsTableViewCell.cellIdentifier, for: indexPath) as! SearchPartsTableViewCell
//        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.setup(parts: pcPartsSeq[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "PartsDetailViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "PartsDetailViewController")as! PartsDetailViewController
            nextVC.pcparts = self.pcPartsSeq[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension SearchPartsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty ?? true) else { return }
        searchBar.resignFirstResponder()
        let word = searchBar.text!
        SearchParts.searchPartsWithSearchBar(selectedCategory: selectedCategory, word: word) { parts in
            self.pcPartsSeq = parts
            DispatchQueue.main.async {
                self.searchTable.reloadData()
            }
        }
    }
}

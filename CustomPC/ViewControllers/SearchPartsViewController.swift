//
//  SearchPartsViewController.swift
//  CustomPC
//
//  Created by Kai on 2022/04/10.
//

import UIKit

import Alamofire
import Kanna
import SVProgressHUD

class SearchPartsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var pcPartsSeq: [PcParts] = []
    var selectedCategory:category = category.cpu
    var selectedParts:[PcParts] = []
    var storedCustom:Custom? = nil

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
        cell.setup(parts: pcPartsSeq[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SVProgressHUD.show()
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "PartsDetailViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "PartsDetailViewController")as! PartsDetailViewController
            nextVC.pcparts = self.pcPartsSeq[indexPath.row]
            nextVC.selectedParts = self.selectedParts
            if let custom = self.storedCustom {
                nextVC.storedCustom = custom
            }
            tableView.deselectRow(at: indexPath, animated: true)
            SVProgressHUD.dismiss()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension SearchPartsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SVProgressHUD.show()
        guard !(searchBar.text?.isEmpty ?? true) else { return }
        searchBar.resignFirstResponder()
        let word = searchBar.text!
        SearchParts.searchPartsWithSearchBar(selectedCategory: selectedCategory, word: word) { parts in
            self.pcPartsSeq = parts
            DispatchQueue.main.async {
                self.searchTable.reloadData()
                SVProgressHUD.dismiss()
                
                if parts.count == 0 {
                    let alert = UIAlertController(title: "該当するパーツがありません", message: "検索ワードを確認してください", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .cancel) { (acrion) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
    }
}

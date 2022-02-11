//
//  ViewController.swift
//  CustomPC
//
//  Created by Kai on 2022/02/11.
//

import UIKit

class CustomListViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var customTable: UITableView!
    var addBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登録済み見積もり一覧"
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "あいうえお"
        return cell
    }
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
//        DispatchQueue.main.async {
//            let storyboard = UIStoryboard(name: "NewCompanyFormViewController", bundle: nil)
//            let nextVC = storyboard.instantiateViewController(identifier: "NewCompanyFormViewController")as! NewCompanyFormViewController
//            self.navigationController?.pushViewController(nextVC, animated: true)
//        }
    }
}


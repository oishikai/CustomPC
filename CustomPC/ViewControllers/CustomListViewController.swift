//
//  ViewController.swift
//  CustomPC
//
//  Created by Kai on 2022/02/11.
//

import UIKit
import FloatingPanel

class CustomListViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, FloatingPanelControllerDelegate{
    
    @IBOutlet weak var customTable: UITableView!
    var addBarButtonItem: UIBarButtonItem!
    
    var customs:[Custom]!
    var floatingPanelController: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Customs"
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        
        customs = AccessData.getCustoms()
        
        let nib = UINib(nibName: SearchPartsTableViewCell.cellIdentifier, bundle: nil)
        customTable.register(nib, forCellReuseIdentifier: SearchPartsTableViewCell.cellIdentifier)
        customTable.rowHeight = UITableView.automaticDimension
        
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        
        let cmvc = CustomModalViewController()
        floatingPanelController.set(contentViewController: cmvc)
        //floatingPanelController.track(scrollView: <#T##UIScrollView#>)
        //floatingPanelController.addPanel(toParent: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        customs = AccessData.getCustoms()
        DispatchQueue.main.async {
            self.customTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPartsTableViewCell.cellIdentifier, for: indexPath) as! SearchPartsTableViewCell
        cell.setupCustomListCell(custom: customs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cmvc = CustomModalViewController()
        let fpc = FloatingPanelController()

        fpc.set(contentViewController: cmvc)
        fpc.isRemovalInteractionEnabled = true
        self.present(fpc, animated: true, completion: nil)
    }
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "NewCustomViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "NewCustomViewController")as! NewCustomViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}


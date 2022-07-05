//
//  ViewController.swift
//  CustomPC
//
//  Created by Kai on 2022/02/11.
//

import UIKit
import FloatingPanel

class CustomListViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, FloatingPanelControllerDelegate {
    
    @IBOutlet weak var customTable: UITableView!
    var addBarButtonItem: UIBarButtonItem!
    
    var customs:[Custom]!
    var fpc: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Customs"
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        
        customs = AccessData.getCustoms()
        
        let nib = UINib(nibName: SearchPartsTableViewCell.cellIdentifier, bundle: nil)
        customTable.register(nib, forCellReuseIdentifier: SearchPartsTableViewCell.cellIdentifier)
        customTable.rowHeight = UITableView.automaticDimension
        
        fpc = FloatingPanelController()
        fpc.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        customs = AccessData.getCustoms()
        DispatchQueue.main.async {
            self.customTable.reloadData()
        }
    }
    
    func showModal(vc:CustomModalViewController){
        let fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.surfaceView.layer.cornerRadius = 9.0
        fpc.set(contentViewController: vc)
        fpc.addPanel(toParent: self)
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
        let contentVC = CustomModalViewController()
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
    }
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "NewCustomViewController", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "NewCustomViewController")as! NewCustomViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
//
//// MARK: - FloatingPanel Delegate
//extension CustomListViewController: FloatingPanelControllerDelegate {
//
//    // カスタマイズしたレイアウトに変更
//    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
//        return CustomFloatingPanelLayout()
//    }
//}
//
//// MARK: - FloatingPanel Layout
//class CustomFloatingPanelLayout: FloatingPanelLayout {
//
//    // 初期位置
//    var initialPosition: FloatingPanelPosition {
//        return .tip
//    }
//
//    // カスタマイズした高さ
//    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
//        switch position {
//        case .full: return 16.0
//        case .half: return 216.0
//        case .tip: return 44.0
//        default: return nil
//        }
//    }
//
//    // サポートする位置
//    var supportedPositions: Set<FloatingPanelPosition> {
//        return [.full, .half, .tip]
//    }
//}

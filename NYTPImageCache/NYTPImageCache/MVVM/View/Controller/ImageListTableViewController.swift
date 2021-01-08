//
//  ImageListTableViewController.swift
//  NYTPImageCache
//
//  Created by Besta, Balaji (623-Extern) on 08/01/21.
//

import Foundation
import UIKit
class ImageListTableViewController: UITableViewController {
    var imageInfoModelData : [ImageModelElement] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM"
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)

        fetchServerInfoData()
        //Pull to refresh UITableview data
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    //MARK:- Did Pull To Refresh
    @objc private func didPullToRefresh(){
        //Re-fetch data
        fetchServerInfoData()
        do {
            
            //self.do_table_refresh()
            DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
            
        }
    }
    //MARK:- GCD Implemented
    func fetchServerInfoData()  {
        imageInfoModelData.removeAll()
        DispatchQueue.global(qos: .utility).async {
         Service.fetchServerInfoData { (result) in
              switch result {
                case let .success(data):
                    self.title = "All Image Info"
//                    self.imageInfoModelData = data
                    let tempRowModelData: [ImageModelElement]? = data
                    //Struct empty variable validation
                    self.imageInfoModelData = tempRowModelData ?? []
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                 case let .failure(error):
                    print("error:: ",error)
                    self.displayMsg(title: "Alert!", msg:"Something went wrong!" )
                 }
         }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageInfoModelData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
        cell.selectionStyle = .none

        
        cell.rowViewModel = ImageRowViewModel(imageInfoModelData[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Create new Alert
        let title = imageInfoModelData[indexPath.row].author

        self.displayMsg(title: "Alert!", msg: title)

    }
}


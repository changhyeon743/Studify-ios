//
//  WideRankingVC.swift
//  Studify
//
//  Created by 이창현 on 11/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit

class WideRankingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var datas : [User] = []
    
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RankingCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        setRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "전체 랭킹"
    }
    
    func setRefresh() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresh)
    }
    @objc func refresh(_ control: UIRefreshControl) {
        
        API.shared.ranking.wide { (json, err) in
            self.datas = User.transform(fromRanks: json)
            print(self.datas.debugDescription)
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
        
        
    }
}

extension WideRankingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RankingCell
        let currentTime = Double( Date().timeIntervalSince1970 ) * 1000
        
        let cursor = datas[indexPath.row]
        guard let user = API.shared.currentUser else { return UITableViewCell() }
        
        if (cursor.token == user.token) {
            
            let date = currentTime.calculateDifference(time: user.start_time)
            cell.backgroundColor = .lightGray
            cell.setDatas(profileURL: user.profileURL,
                          name: user.name,
                          time: "\(date.0):\(date.1):\(date.2)")
            return cell
        }
        
        //"1562678033478"
        print(cursor.name, ": ",cursor.average_time.convertToDate());
        
        cell.setDatas(profileURL: cursor.profileURL,
                      name: cursor.name,
                      time: "\(cursor.max_time.convertToDate()) : \(cursor.average_time.convertToDate()) 초")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

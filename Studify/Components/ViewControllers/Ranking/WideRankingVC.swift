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
        //self.navigationItem.titleView = setTitle(title: "전체 랭킹", subtitle: "최대 공부시간을 기준으로 정렬됩니다.")
        setRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "전체 랭킹"
    }
    
    func setRefresh() {
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
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
        cell.timeLabelRightConstraint.constant = -8
        
        let cursor = datas[indexPath.row]
        guard let user = API.shared.currentUser else { return UITableViewCell() }
        
        if (cursor.token == user.token) { //유저데이터
            //cell.nameLabel.textColor = .mainColor
        }
        
        let date = cursor.max_time.convertToDate()
        let date2 = cursor.average_time.convertToDate()
        cell.setDatas(profileURL: cursor.profileURL,
                      name: "\(indexPath.row + 1). \(cursor.name)",
            time: "최대: \(date.0):\(date.1):\(date.2)\n평균: \(date2.0):\(date2.1):\(date2.2)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}


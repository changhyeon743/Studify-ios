//
//  FriendRankingVC.swift
//  Studify
//
//  Created by 이창현 on 09/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class FriendRankingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let refresh = UIRefreshControl()
    var timer = Timer()
    var autoRefresh = Timer()
    
    var chartView = ChartView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RankingCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        setRefresh()
        chartView = ChartView(uiView: self.view)
        chartView.hide()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timer(_:)), userInfo: nil, repeats: true)
        autoRefresh = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
            if (self.tabBarController?.selectedViewController == self) {
                self.refresh()
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "친구들"
        refresh()
    }
    
    func setRefresh() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresh)
    }
    @objc func refresh(_ control: UIRefreshControl? = nil) {
        
        API.shared.ranking.friends(ids: API.shared.currentFriendsIds, completion: { (json, err) in
            //print("friends: ",json.debugDescription)
            //print("refreshed")
            API.shared.currentFriends = User.transform(fromRanks: json)
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        })
        
       
    }
    
    @objc func timer(_ timer: Timer) {
        tableView.reloadData()
    }

    func setDataOnChart(withJSON json: JSON) {
        let studies = Study.transform(fromFB: json)
            .sorted(by: {$0.date < $1.date})
            .suffix(5)
        
        
        let dates = studies.map({ (study: Study) -> String in
            let date = study.date
            var result =  String(date[date.index(date.startIndex, offsetBy: 4)...])
            //.substring(from: date.index(date.startIndex, offsetBy: 4))
            result.insert("월", at: date.index(date.startIndex, offsetBy: 2))
            result.insert("일", at: date.index(before: date.endIndex))
            return result
        })
        let amounts = studies.map{round($0.amount/60 * 10)/10}
        self.chartView.setData(xVals: dates, dataPoints: amounts)
        self.chartView.show()
    }
}

extension FriendRankingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {return 1}
        return API.shared.currentFriends.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RankingCell
        let currentTime = Double( Date().timeIntervalSince1970 ) * 1000
        
        if (indexPath.section == 0) {
            guard let user = API.shared.currentUser else { return UITableViewCell() }
            let date = currentTime.calculateDifference(time: user.start_time)
            cell.setDatas(profileURL: user.profileURL,
                          name: user.name,
                          current: user.current,
                          time: "",
                        status: (user.start_time == -1) ? false : true)
            return cell
        }
        
        let cursor = API.shared.currentFriends[indexPath.row]
        //"1562678033478"
        
        var date = currentTime.calculateDifference(time: cursor.start_time)
        if (cursor.start_time == -1) {
            date = (0,0,0)
        }
        cell.setDatas(profileURL: cursor.profileURL,
                      name: cursor.name,
                      current: cursor.current,
                      time: "\(date.0):\(date.1):\(date.2)",
                      status: (cursor.start_time == -1) ? false : true)
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 1) {
            return "친구"
        } else {
            return "나"
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {return 0}
        return 48
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            //self
            
            guard let userToken = API.shared.currentUser?.token else {return}
            API.shared.study.record(token: userToken) { (json, err) in
                //print(json.debugDescription)
                if (err == nil) {
                    self.setDataOnChart(withJSON: json)
                    
                }
            }
            
        } else {
            API.shared.study.record(token: API.shared.currentFriends[indexPath.row].token) { (json, err) in
                //print(json.debugDescription)
                if (err == nil) {
                    self.setDataOnChart(withJSON: json)
                }
            }
        }
    }
}

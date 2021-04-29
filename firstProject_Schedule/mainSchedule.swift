//
//  mainSchedule.swift
//  firstProject_Schedule
//
//  Created by 이병훈 on 2021/01/31.
//

import UIKit
import UserNotifications

class mainSchedule: UITableViewController {
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let uv = UILabel()
    
    override func viewDidLoad() {
        UIfunc()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("\(appdelegate.scheduleList.count)")
        if self.appdelegate.scheduleList.count == 0 {
            uv.text = "스케줄을 적으세요"
            uv.textColor = .gray
        } else {
            uv.text = "all schedule = \(appdelegate.scheduleList.count)"
            uv.textColor = .red
        }
        tableView.reloadData()
    }
    
    func UIfunc() {
        uv.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        uv.font = UIFont.systemFont(ofSize: 14)
        uv.textAlignment = .center
        
        self.navigationItem.titleView = uv
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.appdelegate.scheduleList.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.appdelegate.scheduleList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "SCHEDULE") as! scheduleCell
        cell.doing?.text = row.doing
        cell.date?.text = row.date
        if row.alarm == true {
            let img = UIImage(named: "alramOn")
            cell.alarm?.image = img
        } else {
            let img2 = UIImage(named: "alramOff")
            cell.alarm?.image = img2
        }

       return cell
    }
    

}

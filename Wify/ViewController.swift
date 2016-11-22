//
//  ViewController.swift
//  Wify
//
//  Created by caiyangzhenyu on 16/11/22.
//  Copyright © 2016年 caiyangzhenyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var arr:NSArray = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let aa = UserDefaults.standard.object(forKey: "records") as! NSArray
        arr = aa.reversed() as NSArray
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return arr.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rs")
        if arr.count > 0 {
            let dic = arr[indexPath.row] as! NSDictionary
            cell?.textLabel?.text = indexPath.row.description +  "wify:" + (dic["name"] as! String)
            cell?.detailTextLabel?.text = "连接时间:" + (dic["time"] as! String)
        }
        return cell!
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


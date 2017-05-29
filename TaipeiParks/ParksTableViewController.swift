//
//  ParksTableViewController.swift
//  TaipeiParks
//
//  Created by steven.chou on 2017/5/29.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class ParksTableViewController: UITableViewController {

    let limitNum = 30
    var offsetNum = 0
    var parksList: [ParkModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        firstLoading()
    }

    func firstLoading() {

        let parkProvider = ParkProvider.shared

        parkProvider.getParkData(limitNum: limitNum, offsetNum: offsetNum) { (parks, error) in

            if let parks = parks {
                print("parksList: \(String(describing: self.parksList.count))")
                self.parksList.insert(contentsOf: parks, at: self.parksList.count)
                print("parksList: \(String(describing: self.parksList.count))")

                for park in parks {
                    print("name: " + park.name)
                }

            } else {
                print("Error: \(String(describing: error))")
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

}

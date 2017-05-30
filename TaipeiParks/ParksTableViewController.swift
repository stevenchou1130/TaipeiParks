//
//  ParksTableViewController.swift
//  TaipeiParks
//
//  Created by steven.chou on 2017/5/29.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class ParksTableViewController: UITableViewController {

    let imageCache = NSCache<AnyObject, AnyObject>()

    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    let limitNum = 30
    var offsetNum = 0

    var parksList: [ParkModel] = []

    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        loadParksData()
    }

    func setView() {

        self.navigationItem.title = "Taipei City Parks"

        let parkNib = UINib(nibName: ParkTableViewCell.identifier, bundle: nil)
        tableView.register(parkNib, forCellReuseIdentifier: ParkTableViewCell.identifier)

        // Set Indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .green
        view.addSubview(activityIndicator)
    }

    func loadParksData() {

        // todo: Fix bug - can't show activityIndicator when loading new data

        self.isLoading = true
        self.activityIndicator.startAnimating()

        let parkProvider = ParkProvider.shared

        parkProvider.getParkData(limitNum: limitNum, offsetNum: offsetNum) { (parks, error) in

            if let parks = parks {
                self.parksList.insert(contentsOf: parks, at: self.parksList.count)
            } else {
                print("=== Error: \(String(describing: error))")
            }

            DispatchQueue.main.async {

                self.isLoading = false
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }

    func setCellImage(_ park: ParkModel, _ parkImageView: UIImageView) {

        // todo: chech url is correct one

        parkImageView.image = nil

        if let imageFromCache = imageCache.object(forKey: park.image as AnyObject) as? UIImage {
            parkImageView.image = imageFromCache
            return
        }

        DispatchQueue.global().async {
            if let imageUrl = URL(string: (park.image)) {

                do {
                    let imageData = try Data(contentsOf: imageUrl)
                    if let image = UIImage(data: imageData) {

                        DispatchQueue.main.async {

                            let imageToCache = image.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch)

                            self.imageCache.setObject(imageToCache, forKey: park.image as AnyObject)

                            parkImageView.image = imageToCache
                            parkImageView.contentMode = .scaleAspectFit
                        }
                    }
                } catch {
                    print("=== Error: \(error)")
                }
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return parksList.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension

        return tableView.rowHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ParkTableViewCell.identifier,
                                                     for: indexPath) as? ParkTableViewCell
            else {
                return UITableViewCell()
            }

        let park = parksList[indexPath.row]

        cell.parkNameLabel.text = park.parkName
        cell.nameLabel.text = park.name
        cell.introductionLabel.text = park.introduction

        if let parkImageView = cell.parkImageView {
            self.setCellImage(park, parkImageView)
        } else {
            print("=== Can't set image to cell")
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let lastElement = parksList.count - 1

        if indexPath.row == lastElement &&
            self.isLoading == false {

            offsetNum += limitNum
            loadParksData()
        }
    }

}

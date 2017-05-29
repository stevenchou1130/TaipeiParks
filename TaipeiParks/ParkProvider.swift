//
//  ParkProvider.swift
//  TaipeiParks
//
//  Created by steven.chou on 2017/5/29.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation

class ParkProvider {

    static let shared = ParkProvider()

    typealias GetParkCompletion = ([ParkModel]?, Error?) -> Void

    func getParkData() {

        let urlString = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=bf073841-c734-49bf-a97f-3757a6013812"

        let limitNum = 30
        let offsetNum = 0

        let urlWithParams = urlString + "&limit=\(limitNum)" + "&offset=\(offsetNum)"

        guard
            let url = URL(string: urlWithParams)
            else { return }

        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)

        request.httpMethod = "GET"

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                                        completionHandler: { (data, response, error) in
            if error != nil {
                print(String(describing: error))
            } else {

                guard
                    let httpResponse = response as? HTTPURLResponse
                    else {
                        print("Can't parse HTTPResponse")
                        return
                    }

                switch httpResponse.statusCode {

                case 200:
                    print("200")

                    guard
                        let parks = self.parseParkJSON(data)
                        else {
                            print("Can't parse park JSON")
                            return
                    }

                    print("parks.count: \(parks.count)")

                default:
                    print("default")

                }

            }
        })

        dataTask.resume()
    }

    func parseParkJSON(_ data: Data?) -> [ParkModel]? {

        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let result = json?["result"] as? [String: Any],
            let parksData = result["results"] as? [[String: Any]] {

//            print("parksData.count: \(parksData.count)")

            var parks: [ParkModel] = []
            var parkModel: ParkModel?

            for park in parksData {

                if let parkName = park["ParkName"] as? String,
                    let name = park["Name"] as? String,
                    let image = park["Image"] as? String,
                    let introduction = park["Introduction"] as? String {

                    parkModel = ParkModel(parkName: parkName,
                                          name: name,
                                          image: image,
                                          introduction: introduction)

                    parks.append(parkModel!)
                }
            }

            return parks

        } else {

            print("Something is wrong")
            return nil
        }
    }
}

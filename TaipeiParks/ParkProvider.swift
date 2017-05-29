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

    func getParkData(limitNum: Int, offsetNum: Int, completion: @escaping GetParkCompletion) {

        let urlString = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=bf073841-c734-49bf-a97f-3757a6013812"

        let urlWithParams = urlString + "&limit=\(limitNum)" + "&offset=\(offsetNum)"

        guard
            let url = URL(string: urlWithParams)
            else { return }

        var request = URLRequest(url: url)

        request.httpMethod = "GET"

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                                        completionHandler: { (data, response, error) in

            if error == nil {

                guard
                    let httpResponse = response as? HTTPURLResponse
                    else {
                        print("Can't parse HTTPResponse")
                        return
                }

                switch httpResponse.statusCode {

                case 200:
                    guard
                        let parks = self.parseParkJSON(data)
                        else {
                            print("Can't parse park JSON")
                            return
                    }

                    completion(parks, nil)

                default:
                    print("The httpResponse is not 200.")
                }

            } else {
                print(String(describing: error))
                completion(nil, error)
            }
        })

        dataTask.resume()
    }

    func parseParkJSON(_ data: Data?) -> [ParkModel]? {

        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let result = json?["result"] as? [String: Any],
            let parksData = result["results"] as? [[String: Any]] {

            var parks: [ParkModel] = []
            var parkModel: ParkModel?

            // Get data of each park
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

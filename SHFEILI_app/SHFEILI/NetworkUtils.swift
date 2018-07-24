//
//  NetworkUtils.swift
//  SHFEILI
//
//  Created by Michael Hu on 7/23/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import Foundation
open class NetworkUtils {
    static func get(endpoint: String, completionHandler: ((NSDictionary?) -> Void)? = nil) {
        guard let url = URL(string: endpoint) else {
            print("Error: cannot creaet URL!")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                print("Error: error using get method");
                print(error!);
                return;
            }
            guard let responseData = data else {
                print("Error: did not receive data");
                return;
            }
            do {
                guard let result = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? NSDictionary else {
                        print("error trying to convert data to JSON");
                        return;
                    }
                print(result);
                DispatchQueue.main.async {
                    completionHandler!(result)
                }
                return;
            } catch {
                print("error trying to convert data to JSON")
                return;
            }
        }
        task.resume()
    }
    
//    static func post(endpoint: String, inputData: NSMutableDictionary) {
//        guard let url = URL(string: endpoint) else {
//            print("Error: cannot creaet URL!")
//            return
//        }
//        var todosUrlRequest = URLRequest(url: url);
//        todosUrlRequest.httpMethod = "POST";
//        let jsonData: Data
//        do {
//            jsonData = try JSONSerialization.data(withJSONObject: inputData, options:[])
//            todosUrlRequest.httpBody = jsonData;
//            print(jsonData);
//        } catch {
//            print("Error: cannot create JSON");
//            return;
//        }
//        let task = URLSession.shared.dataTask(with: todosUrlRequest) {
//            (data, response, error) in
//            guard error == nil else {
//                print("Error: error using post method");
//                print(error!);
//                return;
//            }
//            guard let responseData = data else {
//                print("Error: did not receive data");
//                return;
//            }
//            do {
//                print(responseData)
//                guard let result = try JSONSerialization.jsonObject(with: responseData, options: [])
//                    as? NSDictionary else {
//                        print("error trying to convert data to JSON");
//                        return;
//                }
//                print(result);
//            } catch {
//                print("error trying to convert data to JSON")
//                return;
//            }
//        }
//        task.resume()
//    }
    
    static func post(endpoint: String, inputData: [String: Any], completionHandler: ((NSDictionary?) -> Void)? = nil) {
        guard let url = URL(string: endpoint) else {
            print("Error: cannot creaet URL!")
            return;
        }
        var todosUrlRequest = URLRequest(url: url);
        todosUrlRequest.httpMethod = "POST";
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: inputData, options:[])
            todosUrlRequest.httpBody = jsonData;
            print(jsonData);
        } catch {
            print("Error: cannot create JSON");
            return;
        }
        let task = URLSession.shared.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("Error: error using post method");
                print(error!);
                return;
            }
            guard let responseData = data else {
                print("Error: did not receive data");
                return;
            }
            do {
                print(responseData)
                guard let result = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? NSDictionary else {
                        print("error trying to convert data to JSON");
                        return;
                }
                print(result);
                DispatchQueue.main.async {
                    completionHandler!(result)
                }
                return;
            } catch {
                print("error trying to convert data to JSON")
                return;
            }
        }
        task.resume()
    }
    
}

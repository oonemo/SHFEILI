//
//  NetworkUtils.swift
//  SHFEILI
//
//  Created by Michael Hu on 7/23/18.
//  Copyright © 2018 Sijie Tan. All rights reserved.
//

import Foundation
open class NetworkUtils {
    
    static let serverBaseUrl = "http://localhost:8000"
    
    static func get(endpoint: String, completionHandler: ((NSDictionary?) -> Void)? = nil) {
        guard let url = URL(string: (serverBaseUrl + endpoint)) else {
            print("Error: cannot creaet URL!")
            return
        }
        let todoURLrequest = URLRequest(url: url)
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
                if (completionHandler != nil) {
                    DispatchQueue.main.async {
                        completionHandler!(result)
                    }
                }
                return;
            } catch {
                print("error trying to convert data to JSON")
                return;
            }
        }
        task.resume()
    }
    
    static func post(endpoint: String, inputData: [String: Any], completionHandler: ((NSDictionary?) -> Void)? = nil) {
        guard let url = URL(string: (serverBaseUrl + endpoint)) else {
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
//                print(responseData)
//                print(response?.url!)
//                let cookies = HTTPCookieStorage.shared.cookies(for: (response?.url)!)
//                print(cookies)
//                let test = HTTPCookieStorage.shared.cookies
                guard let result = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? NSDictionary else {
                        print("error trying to convert data to JSON");
                        return;
                }
                print(result);
                if (completionHandler != nil) {
                    DispatchQueue.main.async {
                        completionHandler!(result)
                    }
                }
                return;
            } catch {
                print("error trying to convert data to JSON")
                return;
            }
        }
        task.resume()
    }
    
   
    
    static func storeCookies() {
        //credit @Ankit chauhan @stackoverflow.com
        let cookiesStorage = HTTPCookieStorage.shared
        let userDefaults = UserDefaults.standard
        
        var cookieDict = [String : AnyObject]()
        
        for cookie in cookiesStorage.cookies(for: NSURL(string: serverBaseUrl)! as URL)! {
            cookieDict[cookie.name] = cookie.properties as AnyObject?
        }
        
        userDefaults.set(cookieDict, forKey: "cookiesKey")
    }
    
    static func restoreCookies() {
        //credit @Ankit chauhan @stackoverflow.com
        let cookiesStorage = HTTPCookieStorage.shared
        let userDefaults = UserDefaults.standard
        
        if let cookieDictionary = userDefaults.dictionary(forKey: "cookiesKey") {
            
            for (_, cookieProperties) in cookieDictionary {
                if let cookie = HTTPCookie(properties: cookieProperties as! [HTTPCookiePropertyKey : Any] ) {
                    cookiesStorage.setCookie(cookie)
                }
            }
        }
    }
    
}

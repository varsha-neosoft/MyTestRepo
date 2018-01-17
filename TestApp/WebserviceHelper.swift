//
//  WebserviceHelper.swift
//
//  Created by varsha on 1/16/18.
//  Copyright © 2018 varsha. All rights reserved.
//

import UIKit
import Alamofire



enum MethodType
{
    case get
    case post
}

enum APIEndUrl
{
    case fetchData

}

///API constant
struct WSAPIConstant {
        static var API_BASEURL = "http://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"

}

// MARK: Webservices
class WebserviceHelper: NSObject {
    var alamoFireManager : SessionManager!
    
    func callWebservice(_ method:MethodType,  endUrl:APIEndUrl, completionHandler: @escaping (_ r: String) -> Void)
    {
    
        let path = WSAPIConstant.API_BASEURL
        
        switch method {
        case .post:
            print("*****")
            
        case .get:
            
            /*
            let headers = [
                "cache-control": "no-cache",
                "postman-token": "d881ec05-b40a-2a67-e6c7-2d2964829916"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: path)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                }
            })
            
            dataTask.resume()
            
            
 */
            var mutableRequest : URLRequest!
            mutableRequest = URLRequest.init(url: URL(string: path)!)
            mutableRequest.httpMethod = "GET"
            
            if alamoFireManager == nil
            {
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 120 // seconds
                alamoFireManager  = Alamofire.SessionManager(configuration: configuration)
            }
            
            alamoFireManager.request(mutableRequest)
                .responseString { response in
                    print(response)
                    
            }
            
        }
    }
    
    
    
    //MARK: CallFetchDataApi WS
    func callFetchDataApi(completionHandler: @escaping (_ r: String) -> Void)
    {
        
        self.callWebservice(MethodType.get , endUrl: APIEndUrl.fetchData) { (resp) in
            
            completionHandler(resp)
        }
    }

    func isConnectedToInternet() -> Bool {
        
        if NetworkReachabilityManager()!.isReachable {
            return true
        } else {
            alertMessageOnWindow("", message: "No Internet Connection \n Make sure your device is connected to the internet.")
            return false
        }
    }
    
    
    //MARK: AlertMessage
    func alertMessageOnWindow(_ title:String, message:String) -> Void {
        
        let alert = UIAlertController(title: title as String, message:message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        DispatchQueue.main.async(execute: {
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                rootVC.present(alert, animated: true, completion: nil)}
        })
    }
}

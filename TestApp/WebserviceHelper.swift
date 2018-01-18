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
    
    func callWebservice(_ method:MethodType,  endUrl:APIEndUrl, completionHandler: @escaping (_ r: [String : Any]?) -> Void)
    {
    
        let path = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
        
        switch method {
            
        case .post:
            print("*****")
            
        case .get:
            if isConnectedToInternet() {
            Alamofire.request(path,method: .get, parameters: nil, encoding: URLEncoding.default, headers:["Authorization": ""]) .responseJSON
                { response in

                    if response.response?.statusCode == 401{
                        return
                    }
           
                    do {
                        
                        let iso = String(data: response.data!, encoding: String.Encoding.isoLatin1)
                        
                        let dutf8: Data? = iso?.data(using: String.Encoding.utf8)
                        
                        if let responseJSON = try JSONSerialization.jsonObject(with: dutf8!, options: .allowFragments) as? NSDictionary {
                            
                            completionHandler(responseJSON as? [String : Any])
                            
                        }
                    } catch {
                        print("Error getting API data: \(error.localizedDescription)")
                        
                    }
            }
            }
    }
    }
    
    
    
    //MARK: CallFetchDataApi WS
    func callFetchDataApi(completionHandler: @escaping (_ r: [String : Any]?) -> Void)
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

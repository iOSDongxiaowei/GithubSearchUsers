//
//  GSUHTTPKit.swift
//  GithubSearchUsers
//
//  Created by dongxiaowei on 2017/5/8.
//  Copyright © 2017年 iOSDongxiaowei. All rights reserved.
//

import UIKit

class GSUHTTPKit: NSObject {
    
    public typealias usersCallBack = ( _ usersDictionary : Dictionary<String, Any>?, _ error : Error?) -> (Void)
    
    public class func users(userName:String,callBack:@escaping usersCallBack)
    {
        self.getHTTP(url : "https://api.github.com/users/\(userName)"){(response, data, error) -> (Void) in
            
            if error != nil
            {
                callBack(nil,error)
            }

            let jsonDict = try? JSONSerialization.jsonObject(with: data!,options:.allowFragments) as! [String: Any]
            print("记录数：\(jsonDict!.count)")
            callBack(jsonDict,nil)
        }
    }
    
    public typealias reposCallBack = ( _ reposArray : [Dictionary<String, Any>]?, _ error : Error?) -> (Void)
    
    public class func repos(userName:String,callBack:@escaping reposCallBack)
    {
        self.getHTTP(url : "https://api.github.com/users/\(userName)/repos"){(response, data, error) -> (Void) in
            
            if error != nil
            {
                callBack(nil,error)
            }
            
            let jsonArray = try? JSONSerialization.jsonObject(with: data!,options:.allowFragments) as! [Dictionary<String, Any>]
            print("记录数：\(jsonArray!.count)")
            callBack(jsonArray,nil)
        }
    }

    
    typealias GSUHTTPCallBack = ( _ response : URLResponse?, _ data : Data?, _ error : Error?) -> (Void)
    
    class func getHTTP(url : String, callBack : @escaping GSUHTTPCallBack)
    {
        var request : URLRequest = URLRequest.init(url: URL.init(string: url)!)
        request.httpMethod = "GET"

        let session : URLSession = URLSession.shared
        let sessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            callBack(response,data,error)
            return ()
        }
        sessionDataTask.resume()
    }
}

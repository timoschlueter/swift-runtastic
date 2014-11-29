/*

The MIT License (MIT)
Copyright (c) 2014 Timo Schlueter <timo.schlueter@me.com>
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

import Foundation

class Runtastic {
    
    var loginUsername: String = ""
    var loginPassword: String = ""
    
    /* URL */
    let loginUrl: String = "https://www.runtastic.com/en/d/users/sign_in.json"
    let logoutUrl: String = "https://www.runtastic.com/en/d/users/sign_out"
    let sessionsApiUrl: String = "https://www.runtastic.com/api/run_sessions/json"
    
    func getRuntasticActivities() {
        
        /*
            Login to Runtstic
        */
        
        /* Create POST request */
        let postRequest = NSMutableURLRequest(URL: NSURL(string: self.loginUrl)!)
        
        /* Put together the POST fields */
        let postString = "user[email]=\(self.loginUsername)&user[password]=\(self.loginPassword)&authenticity_token="
        
        /* Set method to POST and attach POST fields */
        postRequest.HTTPMethod = "POST"
        postRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let requestSession = NSURLSession.sharedSession()
        
        /* Create NSURLSession task to fetch POST data asynchronously */
        let task = requestSession.dataTaskWithRequest(postRequest, completionHandler:{(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if error != nil {
                println(error)
                return
            } else {
                let jsonData: NSData = data
                var error: NSError?
                let jsonDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as NSDictionary
                
                if (jsonDictionary.valueForKey("current_user") != nil) {
                    /* Print out the username of logged-in user */
                    println("Logged in with \(self.loginUsername)")
                    
                    let updateString: NSString = jsonDictionary.valueForKey("update") as NSString
                    
                    /* Extract authenticity token */
                    let pattern: NSString = "<input name=\"authenticity_token\" type=\"hidden\" value=\"(.*)\" /></div>"
                    let regex: NSRegularExpression = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
                    
                    if let match = regex.firstMatchInString(updateString, options: nil, range: NSMakeRange(0, updateString.length)) {
                        
                        let authenticityToken = updateString.substringWithRange(match.rangeAtIndex(1))
                        var userId: Int = jsonDictionary.objectForKey("current_user")!.objectForKey("id")! as Int
                        var sessionUrl: String = jsonDictionary.objectForKey("current_user")!.objectForKey("run_sessions_path")! as String
                        sessionUrl = "https://www.runtastic.com" + sessionUrl
                        
                        /* Print out the fetched information */
                        println("Session-URL: \(sessionUrl)")
                        println("UID: \(userId)")
                        println("Token: \(authenticityToken)")
                        
                        /*
                            Get uid, session url, authenticity token
                        */
                        
                        /* Create POST request */
                        let getRequest = NSMutableURLRequest(URL: NSURL(string: sessionUrl)!)
                        
                        /* Put together the POST fields */
                        let getString = ""
                        
                        /* Set method to POST and attach POST fields */
                        getRequest.HTTPMethod = "GET"
                        getRequest.HTTPBody = getString.dataUsingEncoding(NSUTF8StringEncoding)
                        
                        let task = requestSession.dataTaskWithRequest(getRequest, completionHandler:{(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                            let responseDataString: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                            
                            /* Extract activity ids */
                            let pattern: NSString = "var index_data = (.*);"
                            let regex: NSRegularExpression = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
                            if let match = regex.firstMatchInString(responseDataString, options: nil, range: NSMakeRange(0, responseDataString.length)) {
                                
                                var activitiyRawString:String = responseDataString.substringWithRange(match.rangeAtIndex(1))
                                
                                var error: NSError?
                                
                                activitiyRawString = activitiyRawString.stringByReplacingOccurrencesOfString("[[", withString: "[", options: nil, range: nil).stringByReplacingOccurrencesOfString("]]", withString: "]", options: nil, range: nil)
                                var splittedActivities: Array = activitiyRawString.componentsSeparatedByString("],")
                                
                                let pattern: NSString = "\\[(.*),\""
                                let regex: NSRegularExpression = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
                                
                                var itemList: String = ""
                                
                                for var i = 0; i < splittedActivities.count; i++ {
                                    
                                    var activity: NSString = splittedActivities[i]
                                    
                                    if let match = regex.firstMatchInString(activity, options: nil, range: NSMakeRange(0, activity.length)) {
                                        var item: String = activity.substringWithRange(match.rangeAtIndex(1))
                                        itemList += item + ","
                                    }
                                }
                                
                                /*
                                    Get all the activities through API
                                */
                                
                                /* Create POST request */
                                let postRequest = NSMutableURLRequest(URL: NSURL(string: self.sessionsApiUrl)!)
                                
                                /* Put together the POST fields */
                                let postString = "user_id=\(userId)&items=\(itemList)&authenticity_token=\(authenticityToken)"
                                
                                /* Set method to POST and attach POST fields */
                                postRequest.HTTPMethod = "POST"
                                postRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                                
                                let task = requestSession.dataTaskWithRequest(postRequest, completionHandler:{(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                                    if error != nil {
                                        println(error)
                                        return
                                    } else {
                                        var jsonData: NSData = data
                                        var error: NSError?
                                        
                                        /*
                                        
                                        let responseDataString: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                                        println(responseDataString)
                                        
                                        */
                                        
                                        /* Print out the json-response which contains all activities */
                                        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
                                        println(json)
                                        
                                    }
                                    
                                })
                                
                                task.resume()
                                
                            }
                        })
                        
                        task.resume()
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func logout() {
        
    }
    
    func setUsername(userName: String) {
        self.loginUsername = userName
    }
    
    func setPassword(password: String) {
        self.loginPassword = password
    }
    
    func getUsername() -> String {
        return self.loginUsername
    }
}
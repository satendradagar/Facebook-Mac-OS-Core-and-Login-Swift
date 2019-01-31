//
//  FacebookLoginWindowController.swift
//  AdvancedCalendar
//
//  Created by Satendra Dagar on 15/12/17.
//  Copyright © 2017 Satendra Singh. All rights reserved.
//

import Foundation
import Cocoa
import Facebook_Mac_Core
import Cocoa_Extensions

public class FacebookLoginWindowController: NSWindowController, FBTokenFacebookDelegate {
    
    @IBOutlet var topViewController: NSViewController!
    var loginController: PhFacebook?
    
    var fbToken :AccessToken? = AccessToken.current
    
    public var  completionHandler: ((_ accessToken: AccessToken?, _ error:NSError?) -> Swift.Void)?;
    
    public func tokenResult(_ result: [AnyHashable : Any]) {
        print(result)
        if let fbApp = Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as? String{
            fbToken = AccessToken.init(appId: fbApp, authenticationToken: result["token"] as! String, userId: nil, refreshDate: Date(), expirationDate: result["expiry"] as! Date, grantedPermissions: Set.init(arrayLiteral: Permission.init(name: result["permissions"] as! String)), declinedPermissions: nil)
            AccessToken.current = fbToken
            completionHandler!(fbToken, nil)

        }
        self.window?.close()

//        let answer = dialogOKCancel(question: "Ok?", text: result.description)
        
    }
    
    public func requestResult(_ result: [AnyHashable : Any]) {
        print(result)
        
    }
    
    public func needsAuthentication(_ authenticationURL: String, forPermissions permissions: String) -> Bool {
        print(permissions)
        
        return true
    }
    
    override public func awakeFromNib() {
            super.awakeFromNib()
//        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        if let fbApp = Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as? String{
            loginController = PhFacebook.init(appID: fbApp , andDelegate: self)
            self.topViewController.addSSChildViewController(child: loginController!.webViewController!)
            loginController?.getAccessToken(forPermissions: ["user_events"], cached: false)
        }
        else{
            assertionFailure("Can not continue, no Facebook id is added into Info plist")
        }
        
    }
    
    @IBAction func didClickedCancel(sender:NSButton){
        completionHandler!(nil, NSError.init(domain: "User canceled login session", code: 6544, userInfo: nil))
        self.window?.close()
    }
    
 

    public func showLoginSheet(fromWindow:NSWindow)  {
        AccessToken.refreshCurrentToken { (token, error) in
            print("refreshed token:\(String(describing: token)), \nError:\(String(describing: error))")
            print("Expiry:\(String(describing: token?.expirationDate))")
            if nil != error{
                fromWindow.addChildWindow(self.window!, ordered: .above)
            }
            else{
                self.completionHandler!(token, nil)
            }
        }
    }
}

/*
 var controller: ViewController?
 Then we need a method that will return a window of the current document. Somehow self.windowControllers[0].window as NSWindow doesn't work.
 
 func window() -> NSWindow {
 let windowControllers = self.windowControllers
 let controller = windowControllers[0] as NSWindowController
 let window = controller.window
 return window
 }
 And finally, the code that opens up the sheet window will look like this:
 
 @IBAction func didPressEditF(sender: AnyObject) {
 controller = ViewController(nibName: "ViewController", bundle: nil)
 self.window().beginSheet(controller!.view.window, completionHandler: didEndPresentingF)
 }
 */

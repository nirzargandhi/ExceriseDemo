//
//  SampleNotificationDelegate.swift
//  NotificationSample

class NotificationDelegate: NSObject , UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo as NSDictionary
        let aps = userInfo.value(forKey: "aps") as! NSDictionary
        let alert = aps.value(forKey: "alert") as! NSDictionary
        
        let contentAvailable = aps.value(forKey: "content-available") as? Int ?? 0
        
        if contentAvailable == 1 && aps.value(forKey: "sound") as? String == "" {
            notificationNavigation(notificationData: alert)
        }
        
        completionHandler([.alert,.sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        let aps = userInfo.value(forKey: "aps") as! NSDictionary
        let alert = aps.value(forKey: "alert") as! NSDictionary
        
        notificationNavigation(notificationData: alert)
    }
    
    //MARK: - Notification Navigation Method
    func notificationNavigation(notificationData : NSDictionary) {
        
    }
}



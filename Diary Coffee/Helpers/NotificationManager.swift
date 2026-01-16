//
//  NotificationManager.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 3.11.2024.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
               
                completion(false)
                return
            }

            if granted {
               
                self.printLocalTime()
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                completion(true)
            } else {
                
                completion(false)
            }
        }
    }
    
    
    func scheduleMorningReminder() {
        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = NSLocalizedString("morning_notification", comment: "") + " 🌞☕"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.current
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "morningReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
               
            } else {
               
            }
        }
    }
    
   
    func scheduleAfternoonReminder() {
        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = NSLocalizedString("day_rhythm_notification", comment: "") + "🕰️☕"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 15
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.current
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "afternoonReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
              
            } else {
                
            }
        }
    }
    
    
    func scheduleNightReminder() {
        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = NSLocalizedString("record_reminder", comment: "") + "📖☕"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.current
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "nightReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
             
            } else {
                
            }
        }
    }
    
    func scheduleMidweekReminder() {
           let content = UNMutableNotificationContent()
           content.title = ""
           content.body = NSLocalizedString("week_checkin", comment: "") + "🍩☕"
           content.sound = .default
           
           var dateComponents = DateComponents()
           dateComponents.weekday = 4
           dateComponents.hour = 15
           dateComponents.minute = 0
           dateComponents.timeZone = TimeZone.current
           
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
           let request = UNNotificationRequest(identifier: "midweekReminder", content: content, trigger: trigger)
           
           UNUserNotificationCenter.current().add(request) { error in
               if let error = error {
                  
               } else {
                   
               }
           }
       }
    
    func scheduleMondayReminder() {
        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = NSLocalizedString("monday_greeting", comment: "")
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.weekday = 2
        dateComponents.hour = 11
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.current

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "mondayReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                
            } else {
                
            }
        }
    }
    
    
    func scheduleFridayWeekendReminder() {
        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = NSLocalizedString("weekend_reminder", comment: "")
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.weekday = 6
        dateComponents.hour = 18
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.current

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "fridayWeekendReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
              
            } else {
               
            }
        }
    }
    
    func scheduleWeeklyThemeReminder() {
            let content = UNMutableNotificationContent()
            content.title = ""
            content.body = NSLocalizedString("day_rhythm_notification", comment: "")
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.weekday = 2
            dateComponents.hour = 13
            dateComponents.minute = 0
            dateComponents.timeZone = TimeZone.current
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "weeklyThemeReminder", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                   
                } else {
                   
                }
            }
        }
    
    func scheduleNotification(title: String, body: String, day: Int, month: Int) {
         let content = UNMutableNotificationContent()
         content.title = title
         content.body = body
         content.sound = .default
         
         var dateComponents = DateComponents()
         dateComponents.day = day
         dateComponents.month = month
         dateComponents.hour = 13
         dateComponents.minute = 0
         dateComponents.timeZone = TimeZone.current
         
         let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
         let request = UNNotificationRequest(identifier: "\(title)_\(day)_\(month)", content: content, trigger: trigger)
         
         UNUserNotificationCenter.current().add(request) { error in
             if let error = error {
              
             } else {
               
             }
         }
     }
    
     func scheduleNotificationsForSpecialDays() {
         scheduleNotification(
             title: NSLocalizedString("coffee_day", comment: ""),
             body: NSLocalizedString("coffee_day_celebration", comment: ""),
             day: 1,
             month: 10
         )
         scheduleNotification(
            title: NSLocalizedString("espresso_day", comment: ""),
             body: NSLocalizedString("espresso_day_message", comment: ""),
             day: 23,
             month: 11
         )
         scheduleNotification(
            title: NSLocalizedString("chocolate_day", comment: ""),
            body: NSLocalizedString("chocolate_day_message", comment: ""),
             day: 7,
             month: 7
         )
         scheduleNotification(
            title: NSLocalizedString("barista_day", comment: ""),
            body: NSLocalizedString("barista_day_message", comment: ""),
             day: 6,
             month: 3
         )
         scheduleNotification(
            title: NSLocalizedString("valentines_day", comment: ""),
            body: NSLocalizedString("valentines_day_message", comment: ""),
             day: 14,
             month: 2
         )
         scheduleNotification(
            title: NSLocalizedString("friendship_day", comment: ""),
            body: NSLocalizedString("friendship_day_message", comment: ""),
             day: 30,
             month: 7
         )
         scheduleNotification(
            title: NSLocalizedString("new_years_day", comment: ""),
            body: NSLocalizedString("new_years_day_message", comment: ""),
             day: 1,
             month: 1
         )
     }
    
    private func printLocalTime() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone.current
        let localTime = formatter.string(from: Date())
        
    }
    
    
    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

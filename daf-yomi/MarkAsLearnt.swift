//
//  MarkAsLearnt.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 08/03/2024.
//

import SwiftUI
import UserNotifications

struct CheckboxToggleStyle: ToggleStyle {
    var callback: () -> Void
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation {
                configuration.isOn.toggle()
                callback() // Call the callback when the toggle is clicked
            }
        } label: {
            ZStack {
                Image(systemName: "book.closed")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64)
                
                if configuration.isOn {
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 26, height: 26)
                        .offset(CGSize(width: 3, height: -5))
                        .foregroundColor(.green)
                        .transition(.push(from: .top))
                }
            }
        }
    }
}

struct MarkAsLearnt: View {
    @State private var isDafLearnt: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
        
    func markAsLearned() {
        // Mark today's Daf as learned
        if isDafLearnt {
            UserDefaults.standard.set(Date(), forKey: "LastLearnedDate")
        } else {
            UserDefaults.standard.removeObject(forKey: "LastLearnedDate")
        }
        // You can also store this information for persistence
    }
    
    func checkIfDafLearnedToday() -> Bool {
        // Compare the current date with the last learned date
        // If the current date is different, reset the state
        // Otherwise, return the stored state
        let lastLearnedDate = UserDefaults.standard.object(forKey: "LastLearnedDate") as? Date
        let calendar = Calendar.current
        if let lastDate = lastLearnedDate, calendar.isDate(Date(), inSameDayAs: lastDate) {
            return true
        } else {
            return false
        }
    }
    
    func scheduleDailyReset() {
           // Schedule a daily reset at midnight
           let now = Date()
           let calendar = Calendar.current
           let midnight = calendar.startOfDay(for: now).addingTimeInterval(24 * 60 * 60) // Next midnight
           let resetTimeComponents = calendar.dateComponents([.hour, .minute], from: midnight)
           
           let content = UNMutableNotificationContent()
           content.title = "Daily Reset"
           
           let trigger = UNCalendarNotificationTrigger(dateMatching: resetTimeComponents, repeats: true)
           
           let request = UNNotificationRequest(identifier: "DailyReset", content: content, trigger: trigger)
           
           UNUserNotificationCenter.current().add(request)
       }
       
       func checkNotificationAuthorization() {
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
               if success {
                   print("Notification authorization granted.")
               } else if let error = error {
                   print("Error requesting notification authorization: \(error)")
               }
           }
       }
       
       func scheduleNotifications() {
           let content = UNMutableNotificationContent()
           content.title = "Don't forget to learn today's Daf!"
           content.sound = UNNotificationSound.default
           
           // Notification trigger for 12 PM
           var dateComponents = DateComponents()
           dateComponents.hour = 12
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
           
           // Create notification request
           let request = UNNotificationRequest(identifier: "DafReminder12PM", content: content, trigger: trigger)
           
           // Schedule the notification
           UNUserNotificationCenter.current().add(request)
           
           // Similar setup for 6 PM notification
           
//           // Testing trigger for notification
//           let triggerNow = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // Notification will trigger in 5 seconds
//           
//           // Create notification request for testing trigger now
//           let requestNow = UNNotificationRequest(identifier: "TestTriggerNow", content: content, trigger: triggerNow)
//           
//           // Schedule the notification for testing trigger now
//           UNUserNotificationCenter.current().add(requestNow) { error in
//               if let error = error {
//                   self.alertMessage = "Error scheduling test notification: \(error)"
//                   self.showAlert = true
//               } else {
//                   self.alertMessage = "Test notification scheduled successfully"
//                   self.showAlert = true
//               }
//           }
       }
    
        var body: some View {
            VStack {
                Toggle(isOn: $isDafLearnt) {
                    Text("Learned")
                }.toggleStyle(CheckboxToggleStyle(callback: markAsLearned))
            }.onAppear {
                // Check if the Daf was learned today
                isDafLearnt = checkIfDafLearnedToday()
                // Schedule daily reset for midnight
                scheduleDailyReset()
                // Request notification authorization
                checkNotificationAuthorization()
                // Schedule notifications
                scheduleNotifications()
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
}

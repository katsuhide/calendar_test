//
//  ViewController.swift
//  calendarTest
//
//  Created by AirMyac on 3/27/16.
//  Copyright © 2016 AirMyac. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    var eventStore: EKEventStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // EventStore
        eventStore = EKEventStore()
        
        // カレンダーのリストを取得
        let calendars = eventStore.calendarsForEntityType(.Event)
        print(calendars)
        
        // カレンダーへのアクセス許可の取得
        allowAuthorization()
       
        // イベントの登録
        addEvent()
        
        // イベントの取得
        let events = listEvents()
        
        // イベントの削除
        deleteEvent(events[0])
        listEvents()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func listEvents() -> [EKEvent]{
        let startDate = NSDate()
        let endDate = NSDate()
        let defaultCalendar = eventStore.defaultCalendarForNewEvents
        let predicate = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: [defaultCalendar])
        let events = eventStore.eventsMatchingPredicate(predicate)
        print(events)
        return events
        
    }
   
    func addEvent() {
        let startDate = NSDate()
        let cal = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let endDate = cal.dateByAddingUnit(.Hour, value: 2, toDate: startDate, options: NSCalendarOptions())!
        let title = "カレンダーテストイベント"
        let defaultCalendar = eventStore.defaultCalendarForNewEvents
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = defaultCalendar
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
        } catch let error {
            print(error)
        }
        
    }
    
    func deleteEvent(event: EKEvent) {
        do {
            try eventStore.removeEvent(event, span: .ThisEvent)
        } catch let error {
            print(error)
        }
    }
    
    func allowAuthorization() {
        if getAuthorization_status() {
            print("success")
            return
        } else {
            print("failed")
            eventStore.requestAccessToEntityType(.Event, completion: {
            (granted, error) in
                if granted {
                    return
                }
                else {
                    print("access denied")
                }
            })
            
        }
    }
    
    func getAuthorization_status() -> Bool {
        // ステータスを取得.
        let status = EKEventStore.authorizationStatusForEntityType(.Event)
        
        // ステータスを表示 許可されている場合のみtrueを返す.
        switch status {
        case .NotDetermined:
            print("NotDetermined")
            return false
            
        case .Denied:
            print("Denied")
            return false
            
        case .Authorized:
            print("Authorized")
            return true
            
        case .Restricted:
            print("Restricted")
            return false
        }
    }
}


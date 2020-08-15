//
//  HomeViewController.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 8/1/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit
import HealthKit

class HomeViewController: UIViewController {
    
    let healthStore = HKHealthStore()
    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var weeklySteps: UILabel!
    @IBOutlet weak var totalSteps: UILabel!
    @IBOutlet weak var todaySteps: UILabel!
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var icons: UIStackView!
    @IBOutlet weak var statsStack: UIStackView!
    @IBOutlet weak var avatarShirt: UIImageView!
    @IBOutlet weak var avatarPants: UIImageView!
    @IBOutlet weak var avatarLeftShoe: UIImageView!
    @IBOutlet weak var avatarRightShoe: UIImageView!
    @IBOutlet weak var avatarBody: UIImageView!
    
    
    struct HomeData: Codable {
        let username: String
        let name: String
        let totCoins: Int
        let shirt: String
        let pants: String
        let shoes: String
        let hair: String
    }
    
    struct jsonTotSteps: Codable {
        let previous_aggregate_steps: Int
    }
    
    struct jsonDate: Codable {
        let startDate: String
    }
    
    struct getNewCoin: Codable {
        let newCoins: Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // aesthetics
        homeAesthetics()
        
        // retrieve and update health data
        authorizeHealthKit()
        // update previous week's steps
        updatePreviousAggregate {
            // update this week's steps
            self.getSteps()
        }
        
        // load user data on UI
        getUserData()
    }
    
    // design edits of home
    private func homeAesthetics() {
        
        // round home label
        homeLabel.layer.masksToBounds = true
        homeLabel.layer.cornerRadius = 10
        
        // round stats buttons
        weeklySteps.layer.masksToBounds = true
        weeklySteps.layer.cornerRadius = 10
        totalSteps.layer.masksToBounds = true
        totalSteps.layer.cornerRadius = 10
        todaySteps.layer.masksToBounds = true
        todaySteps.layer.cornerRadius = 10
        
        // padding of stats background
        statsStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        statsStack.isLayoutMarginsRelativeArrangement = true
        
        // adding background of stats data
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.5137547851, blue: 0.4823105335, alpha: 0.2499732449)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 15
        statsStack.insertSubview(backgroundView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: statsStack.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: statsStack.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: statsStack.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: statsStack.bottomAnchor)
        ])
    }
    
    // get user data
    private func getUserData() {
        // load user data
        let url = URL(string: "http://3.14.11.198:5000/get-home-data")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempHomeData = try JSONDecoder().decode(HomeData.self, from: data)
                DispatchQueue.main.async {
                    // string data
                    self.Name.text = tempHomeData.name
                    self.statsLabel.text = "\(tempHomeData.username)'s STATS".uppercased()
                    // image data
                    self.avatarShirt.image = UIImage(named: tempHomeData.shirt)
                    self.avatarPants.image = UIImage(named: tempHomeData.pants)
                    self.avatarLeftShoe.image = UIImage(named: tempHomeData.shoes)
                    self.avatarRightShoe.image = UIImage(named: "\(tempHomeData.shoes)1")
                    self.avatarBody.image = UIImage(named: "\(tempHomeData.hair)-Avatar")
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()
    }
    
    // authorize HealthKit for this device
    private func authorizeHealthKit() {
        let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk, error) in
            if(chk) {
                print("permission granted")
            }
        }
    }
    
    private func updateCoinage(dailySteps: Int) {
        let oldCoins = UserDefaults.standard.integer(forKey: defaultsKeys.oldCoinsKey)
        let oldDate = UserDefaults.standard.integer(forKey: defaultsKeys.oldDateKey)
        if oldDate == Date().dayNumberOfWeek() {
            let tempCoins = dailySteps - oldCoins
            let url = URL(string: "http://3.14.11.198:5000/get-new-coin-data")!
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            request.httpMethod = "POST"
            request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))", "add_coins": "\(tempCoins)"])
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let tempCoinData = try JSONDecoder().decode(getNewCoin.self, from: data)
                    DispatchQueue.main.async {
                        // string data
                        self.coins.text = "\(tempCoinData.newCoins)"
                    }
                } catch let jsonErr {
                    print(jsonErr)
                }
            }
            task.resume()
            UserDefaults.standard.set(dailySteps, forKey: defaultsKeys.oldCoinsKey)
            //UserDefaults.standard.set(Date().dayNumberOfWeek(), forKey: defaultsKeys.oldDateKey)
        } else {
            let tempCoins = dailySteps
            let url = URL(string: "http://3.14.11.198:5000/get-new-coin-data")!
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            request.httpMethod = "POST"
            request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))", "add_coins": "\(tempCoins)"])
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let tempCoinData = try JSONDecoder().decode(getNewCoin.self, from: data)
                    DispatchQueue.main.async {
                        // string data
                        self.coins.text = "\(tempCoinData.newCoins)"
                    }
                } catch let jsonErr {
                    print(jsonErr)
                }
            }
            task.resume()
            UserDefaults.standard.set(dailySteps, forKey: defaultsKeys.oldCoinsKey)
            UserDefaults.standard.set(Date().dayNumberOfWeek(), forKey: defaultsKeys.oldDateKey)
        }
    }
    
    // OberservableQuery to track updates in step count
    private func getSteps() {
        let steps: HKObjectType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        if healthStore.authorizationStatus(for: steps) != HKAuthorizationStatus.notDetermined {
            healthStore.enableBackgroundDelivery(for: steps, frequency: .immediate, withCompletion: { (worked, error) in
                if error != nil { print("error") }
            })
            let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
            let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { query, completionHandler, error in
                if error != nil {
                    print("error")
                    abort()
                }
                // get and update all steps
                self.getDailySteps(completion: { (dailyStepCount) in
                    print("Daily step display to \(dailyStepCount)")
                    self.updateCoinage(dailySteps: dailyStepCount)
                    // get newest weekly steps
                    self.getWeeklySteps(completion: { (weeklyStepCount) in
                        print("Weekly step display to \(weeklyStepCount)")
                        // get total steps
                        self.getTotalSteps(weeklySteps: weeklyStepCount) { (totalStepCount) in
                            print("Total step display to \(totalStepCount)")
                            // update steps table
                            self.updateSteps(dailySteps: dailyStepCount, weeklySteps: weeklyStepCount, totalSteps: totalStepCount) {
                                print("Steps display data set")
                            }
                        }
                    })
                })
                // complete update query
                completionHandler()
            }
            healthStore.execute(query)
        }
    }
    
    // StatisticsCollectionQuery to get steps from a specific interval of the day
    private func getDailySteps(completion: @escaping (Int) -> ()) {
        var val: Int = 0
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        var interval = DateComponents()
        interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)
        query.initialResultsHandler = { query, result, error in
            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to: Date()) { (statistic, value) in
                    if let count = statistic.sumQuantity() {
                        val = Int(count.doubleValue(for: HKUnit.count()))
                        DispatchQueue.main.async {
                            self.todaySteps.text = "\(val)"
                        }
                    }
                }
            }
            completion(val)
        }
        healthStore.execute(query)
    }
    
    // StatisticsCollectionQuery to get steps from a specific interval of the week
    private func getWeeklySteps(completion: @escaping (Int) -> ()) {
        var val: Int = 0
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        let date = Calendar.current.startOfDay(for: Date())
        let modifiedDate = Calendar.current.date(byAdding: .day, value: -(Date().dayNumberOfWeek()! - 1), to:date)!
        let predicate = HKQuery.predicateForSamples(withStart: modifiedDate, end: Date(), options: .strictEndDate)
        var interval = DateComponents()
        interval.day = 7
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: modifiedDate, intervalComponents: interval)
        query.initialResultsHandler = {
            query,result,error in
            if let myresult = result {
                myresult.enumerateStatistics(from: modifiedDate, to: Date()) { (statistic, value) in
                    if let count = statistic.sumQuantity() {
                        val = Int(count.doubleValue(for: HKUnit.count()))
                        DispatchQueue.main.async {
                            self.weeklySteps.text = "\(val)"
                        }
                    }
                }
            }
            completion(val)
        }
        healthStore.execute(query)
    }
    
    // URLSession to get previous total steps
    private func getTotalSteps(weeklySteps: Int, completion: @escaping (Int) -> ()) {
        var total: Int = 0
        let url = URL(string: "http://3.14.11.198:5000/get-previous-aggregate-steps")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempTotData = try JSONDecoder().decode(jsonTotSteps.self, from: data)
                DispatchQueue.main.async {
                    total = tempTotData.previous_aggregate_steps + weeklySteps
                    self.totalSteps.text = "\(total)"
                    completion(total)
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()
    }
    
    // update steps table in db
    private func updateSteps(dailySteps: Int, weeklySteps: Int, totalSteps: Int, completion: @escaping () -> ()) {
        let url = URL(string: "http://3.14.11.198:5000/update-steps")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))", "daily_steps": "\(dailySteps)", "weekly_steps": "\(weeklySteps)", "aggregate_steps": "\(totalSteps)"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion()
        }
        task.resume()
    }
    
    // check to see if we need to update previous aggregate steps
    private func updatePreviousAggregate(completion: @escaping () -> ()) {
        let url = URL(string: "http://3.14.11.198:5000/get-start-date")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                // retrieve previous sunday
                let tempDate = try JSONDecoder().decode(jsonDate.self, from: data)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss ZZZZZ"
                let previousSunday = dateFormatter.date(from: tempDate.startDate)!
                // calculate current sunday
                let date = Calendar.current.startOfDay(for: Date())
                let endDate = Calendar.current.date(byAdding: .day, value: -(Date().dayNumberOfWeek()! - 1), to:date)!
                let currentSundayString = dateFormatter.string(from: endDate)
                let currentSunday = dateFormatter.date(from: currentSundayString)!
                // check if this sunday is the same as previous sunday
                print("current \(currentSunday)")
                print("previous \(previousSunday)")
                if currentSunday > previousSunday {
                    // update aggregate steps
                    self.getAggregateSteps(startDate: previousSunday, endDate: currentSunday) { (newAggregate) in
                        print("new aggregate \(newAggregate)")
                        print(currentSunday)
                        self.updateAggregateSteps(newAggregate: newAggregate, newDate: currentSunday)
                    }
                }
            } catch let jsonErr {
                print(jsonErr)
            }
            completion()
        }
        task.resume()
    }
    
    // get aggregate steps from healthkit
    private func getAggregateSteps(startDate: Date, endDate: Date, completion: @escaping (Int) -> ()) {
        var val: Int = 0
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let diffComponents = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        var interval = DateComponents()
        interval.day = diffComponents.day
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)
        query.initialResultsHandler = {
            query,result,error in
            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to: endDate) { (statistic, value) in
                    if let count = statistic.sumQuantity() {
                        val = Int(count.doubleValue(for: HKUnit.count()))
                    }
                }
            }
            completion(val)
        }
        healthStore.execute(query)
    }
    
    // update aggregate steps in db
    private func updateAggregateSteps(newAggregate: Int, newDate: Date) {
        // convert date to GMT and string
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone?
        let createdDate = dateFormatter.string(from: newDate)
        // web request to update
        let url = URL(string: "http://3.14.11.198:5000/update-aggregate")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))", "previous_aggregate_steps": "\(newAggregate)", "aggregate_update": createdDate])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in }
        task.resume()
    }
}

// get numerical equivalent to the day of the week
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

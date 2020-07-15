//
//  ViewController.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 6/15/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

   @IBOutlet weak var stepsLabel: UILabel!
    var val = 0
    let healthStore = HKHealthStore()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
    }
    
    func authorizeHealthKit(){
        let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk, error) in
            if(chk) {
                print("permission granted")
                self.getTodayTotalStepCounts()
            }
        }
    }

    func getTodayTotalStepCounts() {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        var interval = DateComponents()
     
        // not sure lol
        interval.day = 7
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)
        query.initialResultsHandler = {
            query,result,error in

            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to: Date()) { (statistic, value) in
                    if let count = statistic.sumQuantity() {
                        self.val = Int(count.doubleValue(for: HKUnit.count()))
                        print("Total step taken today is \(self.val) steps")
                     
                    }
                }
            }
        }
        healthStore.execute(query)
    }
    
    @IBAction func reloadSteps(_ sender: Any) {
        getTodayTotalStepCounts()
        stepsLabel.text = String(val)
    }
}


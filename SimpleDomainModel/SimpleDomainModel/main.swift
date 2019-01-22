//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    switch currency {
    case "USD":
        switch to {
        case "USD":
            return self
        case "GBP":
            return Money(amount: Int(Double(self.amount)/2), currency: "GBP")
        case "EUR":
            return Money(amount: Int(Double(self.amount)*1.5), currency: "EUR")
        case "CAN":
            return Money(amount: Int(Double(self.amount)*1.25), currency: "CAN")
        default:
            print("invalid currency")
            return self
        }
    case "GBP":
        switch to {
        case "USD":
            return Money(amount: Int(Double(self.amount)*2), currency: "GBP")
        case "GBP":
            return self
        case "EUR":
            return Money(amount: Int(Double(self.amount)*3), currency: "EUR")
        case "CAN":
            return Money(amount: Int(Double(self.amount)*2.5), currency: "CAN")
        default:
            print("invalid currency")
            return self
        }
    case "EUR":
        switch to {
        case "USD":
            return Money(amount: Int(Double(self.amount)/1.5), currency: "EUR")
        case "GBP":
            return Money(amount: Int(Double(self.amount)/3), currency: "GBP")
        case "EUR":
            return self
        case "CAN":
            return Money(amount: Int(Double(self.amount)/1.2), currency: "CAN")
        default:
            print("invalid currency")
            return self
        }
    case "CAN":
        switch to {
        case "USD":
            return Money(amount: Int(Double(self.amount)/1.25), currency: "CAN")
        case "GBP":
            return Money(amount: Int(Double(self.amount)/2.5), currency: "GBP")
        case "EUR":
            return Money(amount: Int(Double(self.amount)*1.2), currency: "EUR")
        case "CAN":
            return self
        default:
            print("invalid currency")
            return self
        }
    default:
        print("invalid currency")
        return self
    }
  }
  
  public func add(_ to: Money) -> Money {
    let rightCurrency = self.convert(to.currency)
    return Money(amount: (rightCurrency.amount+to.amount), currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    let rightCurrency = self.convert(from.currency)
    return Money(amount: (from.amount-rightCurrency.amount), currency: from.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Salary(let year):
        return year
    case .Hourly(let hour):
        return Int(round(hour*2000))
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Salary(let year):
        self.type = JobType.Salary(Int(round(Double(year)*amt)))
    case .Hourly(let hour):
        self.type = JobType.Hourly(hour*amt)
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(value) {
        _job = value
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
        _spouse = value
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    var jobString : String = "none"
    if self.job != nil {
        jobString = "\(self.job?.type)"
    }
    var spouseString : String = "none"
    if self.spouse != nil {
        spouseString = "\(self.spouse?.firstName)"
    }
    
    return "[Person: firstName: \(self.firstName) lastName: \(self.lastName) age: \(self.age) job: \(jobString) spouse: \(spouseString)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.spouse == nil && spouse2.spouse == nil) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    var oldEnough : Bool = false
    for member in members {
        if (member.age > 21) {
            oldEnough = true
        }
    }
    if oldEnough {
        members.append(child)
        return true
    } else {
        return false
    }
  }
  
  open func householdIncome() -> Int {
    var total : Int = 0
    for member in members {
        if (member.job != nil) {
            total += member.job!.calculateIncome(2000)
        }
    }
    return total
  }
}






//  BoardFoot.swift
//
//  Created by Christopher Di Bert
//  Created on 2024-03-21
//  Version 1.0
//  Copyright (c) Christopher Di Bert. All rights reserved.
//
//  Package checking problem.

import Foundation

final class PackageChecker {
    // Static variables that can be used across the class.
    private static var playAgain = true
    private static let massUnits = ["lbs", "kg", "g"]
    private static let lengthUnits = ["mm", "cm", "m"]
    private static var packageDimensions = Array<Double?>(repeating: nil, count: 3)
    private static var packageMass: Double = 0
    private static var userMassUnit = ""
    private static var userLengthUnit = ""

    // Main method. Execution of the program loop happens here.
    static func main() {
        while playAgain {
            print("\nWelcome to the package checker.")
            if getUserValues() {
                packageCanBeLoaded()
            }
            print("\nEnter 'y' to start again:\n> ", terminator: "")
            if let playAgainInput = readLine()?.lowercased(), playAgainInput.first != "y" {
                resetValues()
                break
            }
        }
    }

    // Master method to get all user values necessary for calculations.
    private static func getUserValues() -> Bool {
        presentOptionsMenu(title: "MASS UNITS", options: massUnits)
        print("Enter the mass unit you would like to use:\n> ", terminator: "")
        if let userMassUnit = getChoice(unitType: "mass"), userMassUnit != "Choice does not exist" {
            self.userMassUnit = userMassUnit
        } else {
            print("\nYou must select a valid mass unit!")
            return false
        }

        presentOptionsMenu(title: "LENGTH UNITS", options: lengthUnits)
        print("Enter the length unit you would like to use:\n> ", terminator: "")
        if let userLengthUnit = getChoice(unitType: "length"), userLengthUnit != "Choice does not exist" {
            self.userLengthUnit = userLengthUnit
        } else {
            print("\nYou must select a valid length unit!")
            return false
        }

        guard getMeasurements() else {
            print("\nYou must enter numbers for measurements!")
            return false
        }

        return true
    }


    // Simple method to present an options menu to the user.
    private static func presentOptionsMenu(title: String, options: [String]) {
        print("\n===== \(title) =====")
        for (index, option) in options.enumerated() {
            print("\(index + 1). \(option)")
        }
    }

    // Method to get user's choice from a list.
    private static func getChoice(unitType: String) -> String? {
        guard let userChoice = readLine() else { return nil }

        let options = unitType == "mass" ? massUnits : lengthUnits

        for option in userChoice.components(separatedBy: " ") {
            if options.contains(option) {
                return option
            }
        }

        if let userChoiceNum = Int(userChoice), (1...options.count).contains(userChoiceNum) {
            return options[userChoiceNum - 1]
        }

        return "Choice does not exist"
    }


    /*Method to get numeric measurements from the user.
    Returns a bool to indicate successful execution.*/
    private static func getMeasurements() -> Bool {
        let measurements = ["length", "width", "height"]

        // Gets the side lengths. Loops through each side length.
        for (index, measurement) in measurements.enumerated() {
            print("\nEnter the package \(measurement) in \(userLengthUnit)\n> ", terminator: "")
            if let userInput = readLine(), let userDim = Double(userInput) {
                packageDimensions[index] = userDim
            } else {
                return false
            }
        }

        // Gets the mass.
        print("\nEnter the package mass in \(userMassUnit)\n> ", terminator: "")
        if let userInput = readLine(), let mass = Double(userInput) {
            packageMass = mass
        } else {
            return false
        }

        return true
    }

    /*Method to check if package can be loaded. Calculations, unit
    conversions, and comparisons take place here.*/
    private static func packageCanBeLoaded() {
        var volume = 1.0

        for dimension in packageDimensions {
            if let dimension = dimension {
                volume *= dimension
            }
        }

        switch userLengthUnit {
            case "mm":
                volume /= 10
            case "m":
                volume *= 100
            default:
                break
        }

        if volume > 10000 {
            print("Cannot send package! It is too large!")
        } else {
            switch userMassUnit {
                case "g":
                    packageMass /= 1000
                case "lbs":
                    packageMass /= 2.205
                default:
                    break
            }

            if packageMass > 27 {
                print("Cannot send package! It weighs too much!")
            } else {
                print("\n~Your package can be loaded!~")
            }
        }
    }

    // Method to reset values
    private static func resetValues() {
        packageDimensions = Array<Double?>(repeating: nil, count: 3)
        packageMass = 0
        userMassUnit = ""
        userLengthUnit = ""
    }
}
PackageChecker.main()
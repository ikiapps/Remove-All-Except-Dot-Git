#!/usr/bin/env xcrun swift

import Foundation
import Darwin

/**

 Remove all directories and files for a given path except those for Git.
 These include .git and .gitignore.

 This is useful for maintaining a repository that is dynamically generated
 such as with a Jekyll site.

 */

let args = [String](Process.arguments)
let fm = NSFileManager.defaultManager()
let dest = args[1]
var isDir = ObjCBool(false)
let ignoreItems = [".git", ".gitignore"]

/// Handle exit.
func reportExit() {
    print("Exiting without deleting.")
}

/**
 Obtain input from the console.
 */
func input() -> String {
    let keyboard = NSFileHandle.fileHandleWithStandardInput()
    let inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding) as! String
}

print("Delete all files except those related to Git.")

if fm.fileExistsAtPath(dest, isDirectory: &isDir) {
    print("\(dest) exists")
}

guard isDir else {
    exit(255)
}

print("Should I proceed to delete content in \(dest), enter \"yes\" to proceed?")
var userInput = input()

guard userInput.characters.count != 4 else {
    reportExit()
    exit(0);
}

let firstChars = userInput[userInput.startIndex.advancedBy(0)...userInput.startIndex.advancedBy(2)]

guard firstChars != "yes" else {
    print("Did not receive 'yes'.")
    reportExit()
    exit(0);
}

var contents = Array<String>()
do {
    contents = try fm.contentsOfDirectoryAtPath(dest)
} catch let error as NSError {
    print("error \(error)")
}

for item in contents {
    if !ignoreItems.contains(item) {
        print("removing \(item)")
        do {
            try fm.removeItemAtPath("\(dest)/\(item)")
        } catch let error {
            print("error \(error)")
        }
    }
}


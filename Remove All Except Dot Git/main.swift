#!/usr/bin/env xcrun swift

// Copyright (c) 2016 ikiApps LLC.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Darwin

/**

 Remove all directories and files for a given path except those for Git.
 These include .git and .gitignore.

 This is useful for maintaining a repository that is dynamically generated
 such as with a Jekyll site.

 The use case is where you want to ensure that no previous files from a previous Jekyll build
 are lying around in your directory that you use for publishing your blog.

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

/// Obtain input from the console.
func input() -> String {
    let keyboard = NSFileHandle.fileHandleWithStandardInput()
    let inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding) as! String
}

print("Preparing to DELETE all files except those related to Git.\n")
print("Checking if the destination directory exists...")

if fm.fileExistsAtPath(dest, isDirectory: &isDir) {
    print("\(dest) exists.\n")
}

guard isDir else {
    exit(255)
}

print("Should I proceed to delete content in \(dest), enter \"yes\" to proceed?")
var userInput = input()

guard userInput.characters.count != 3 else {
    print("Character count was not 3")
    reportExit()
    exit(0);
}

let firstChars = userInput[userInput.startIndex.advancedBy(0)...userInput.startIndex.advancedBy(2)]

guard firstChars == "yes" else {
    print("Did not receive 'yes'")
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


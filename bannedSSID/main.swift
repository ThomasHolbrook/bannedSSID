//
//  main.swift
//  bannedWifi
//
//  Created by Thomas Holbrook on 05/10/2015.
//  Copyright © 2015 Thomas Holbrook. All rights reserved.
//

// Banned WiFi CLI App
// Bored in a hotel with SSID "Premier Inn Ultimate Wi-Fi"

import Cocoa
import CoreWLAN
import Foundation

let iface = CWWiFiClient.sharedWiFiClient().interface()?.interfaceName

// Argument parsing Errors.

let arguments = Process.arguments
let currentSSID = CWWiFiClient.sharedWiFiClient().interface()?.ssid()
let executableName = NSString(string: Process.arguments.first!).pathComponents.last!

func usage() {
    
    print("")
    print("Usage:")
    print("\t\(executableName) <banned_ssid> <wait_time>")
    print("")
    print("\t\(executableName) checks the current SSID against banned SSID")
    print("")
    print("wait_time defines the amount of time we wait for WiFi to settle before executing the check")
    print("")
    print("Where a match is found the client is disassociated and the SSID removed from Prefered Networks")
    print("")
    print("Example - bannedSSID \"Tom Tom\" 30")
    print("")
    print("Thomas Holbrook - The software is provided \"as is\", without warranty of any kind")
    print("")
}

//Wait for Wireless to settle.

if arguments.count == 3 {
    
    var delay = UInt32(arguments[2])
    sleep(delay!)

}

if arguments.contains("-help") || arguments.contains("-h") {
    usage()
    exit(0)
}

else if arguments.count == 1 {
    usage()
    exit(0)
}
    
else if arguments.count == 2 {
    usage()
    exit(0)
}


else if arguments.count > 3 {
    usage()
    exit(0)
}

else if currentSSID == nil {
    print("Wifi Not Connected to SSID")
    exit(0)
}


let bannedSSID = arguments[1]

let delay = arguments[2]

print("Current SSID is " + currentSSID!)

print("Banned SSID is " + bannedSSID)


//Check if our current SSID is banned?
if currentSSID! == bannedSSID {
    
    //If its a banned SSID diconnect the client
    
    print("Disconnecting from Banned SSID")
    CWWiFiClient.sharedWiFiClient().interface()!.disassociate()
    
    //Use networksetup to remove the prefered network entry
    
    print("Removing from Preferred Networks")
    let taskCheck = NSTask()
    taskCheck.launchPath = "/usr/sbin/networksetup"
    taskCheck.arguments = ["-removepreferredwirelessnetwork",iface!,bannedSSID]
    
    let pipe = NSPipe()
    taskCheck.standardOutput = pipe
    
    taskCheck.launch()
    taskCheck.waitUntilExit()
    
    print(taskCheck.terminationStatus)
}
    
else
    
{
    print("Allowed SSID Doing Nothing")
}

//The End

exit(0)


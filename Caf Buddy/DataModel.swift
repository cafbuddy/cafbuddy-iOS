//
//  DataModel.swift
//  Caf Buddy
//
//  Created by Armaan Bindra2 on 11/24/14.
//  Copyright (c) 2014 St. Olaf Acm. All rights reserved.
//

import Foundation

class DataModel :NSObject
{
    class func  addMessageToPlist(from:String,message:String,matchId:String)
    {
        let myFile = "\(matchId).plist"
        var filePaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var path = filePaths.stringByAppendingPathComponent(myFile)
        
        var checkValidation = NSFileManager.defaultManager()
        var ChatLog = NSMutableArray()
        if (checkValidation.fileExistsAtPath(path))
        {
            println("FILE AVAILABLE");
            ChatLog = DataModel.loadMessagesFromPlist(matchId)
            var chatItem = Dictionary<String, String>()
            chatItem["User"] = from
            chatItem["Message"] = message
            ChatLog.addObject(chatItem)
            println("chatLog is \(ChatLog)")
        }
        else
        {
            println("FILE NOT AVAILABLE");
            var chatItem = Dictionary<String, String>()
            chatItem["User"] = from
            chatItem["Message"] = message
            ChatLog.addObject(chatItem)
            println("chatLog is \(ChatLog)")
        }
        
        let plistData = NSPropertyListSerialization.dataFromPropertyList(ChatLog, format:NSPropertyListFormat.XMLFormat_v1_0,errorDescription:nil)
        plistData?.writeToFile(path, atomically: true)
    }
    
    class func loadMessagesFromPlist(matchId:String)->NSMutableArray
    {
         var checkValidation = NSFileManager.defaultManager()
        let myFile = "\(matchId).plist"
        var filePaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var path = filePaths.stringByAppendingPathComponent(myFile)
        var myArray = NSMutableArray()
        if (checkValidation.fileExistsAtPath(path))
        {
        //let dict = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        myArray = NSMutableArray(contentsOfFile: path)!
        println("dict is \(myArray)")
        }
        return myArray
    }
}
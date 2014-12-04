import UIKit

class Message: NSObject, JSQMessageData {
    private var body: String
    private var creator: String
    private var created: NSDate
    
    init(body: String, sender: String) {
        self.body = body
        self.creator = sender
        self.created = NSDate()
    }
    
    func text() -> String! {
        return self.body
    }
    
    func sender() -> String! {
        return self.creator
    }
    
    func date() -> NSDate! {
        return self.created
    }
}

import Foundation


extension String {
    
    func isValidEmail() -> Bool {
        // test@email.com -> true
        // test.com -> false
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        
        return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPassword() -> Bool {
        // minimum 6 characters long
        // 1 uppercase character
        // at least 1 special char
        let pattern = "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
                
        return regex.firstMatch(in: self, range: NSRange(location: 0, length: self.count)) != nil
    }
}

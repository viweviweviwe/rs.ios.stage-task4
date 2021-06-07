import Foundation

public extension Int {
    
    var roman: String? {
        var intValue = self
        if intValue <= 0 {return nil}
        let romanLiterals: [(intNumber: Int,romanNumber: String)] = [(1000, "M"),
                                              (900, "CM"),
                                              (500, "D"),
                                              (400, "CD"),
                                              (100, "C"),
                                              (90, "XC"),
                                              (50, "L"),
                                              (40, "XL"),
                                              (10, "X"),
                                              (9, "IX"),
                                              (5, "V"),
                                              (4, "IV"),
                                              (1, "I")]
        
        var romanNumber = ""
        for i in romanLiterals{
            while intValue >= i.intNumber {
                intValue -= i.intNumber
                romanNumber += i.romanNumber
            }
        }
        return romanNumber
    }
}

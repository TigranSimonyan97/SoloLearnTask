//
//  SnowboardJumpTrick.swift
//  SoloLearnTask
//
//  Created by Tigran  Simonyan on 5/9/19.
//  Copyright © 2019 Tigran  Simonyan. All rights reserved.
//

import Foundation

public class SnowboardJumpTrick {
    
    public var timesLanded = 0
    
    public var grabName: String
    public var spinDegrees: Int?
    
    public init? (grabName: String, spinDegrees: Int?) {
        guard SnowboardJumpTrick.validate(spinDegrees: spinDegrees) else {
            return nil
        }
        
        self.grabName = grabName
        self.spinDegrees = spinDegrees
    }
    
    //1.) Note the internal access level.
    internal static func validate(spinDegrees: Int?) -> Bool {
        
        //2.) It's totally valid to not spin while hitting a jump.
        //    We call that a straight air.
        guard let spinDegrees = spinDegrees else {
            return true
        }
        
        return isMultipleOf180(spinDegrees: spinDegrees)
    }
    
    //3.) The modulo operator can be used to verify that the spin amount is
    //    cleanly divisible by 180.
    internal static func isMultipleOf180(spinDegrees: Int) -> Bool {
        return spinDegrees%180 == 0
    }

}

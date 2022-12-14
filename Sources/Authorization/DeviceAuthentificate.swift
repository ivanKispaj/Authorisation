//
//  DeviceAuthentificate.swift
//  
//
//  Created by Ivan Konishchev on 14.12.2022.
//

import Foundation
import LocalAuthentication


public final class DeviceAuthentificate {
    
    @available(iOS 13.0.0, *)
    public  func getAuthType() async -> BiometricType {
        var error: NSError?
        let context = LAContext()
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            
            if let errorCode = error?.code {
                self.getErrorDescription(errorCode: errorCode)
            }
            return .none
        }
        
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
            }
        }
        
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
    
    @available(iOS 13.0.0, *)
   public func authentificate(_ completion: @escaping(Bool)-> ()) async {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
        }
    }
    
    private  func getErrorDescription(errorCode: Int)  {
        let description: String
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            description = "Authentication was not successful, because user failed to provide valid credentials."
            
        case LAError.appCancel.rawValue:
            description = "Authentication was canceled by application (e.g. invalidate was called while authentication was in progress)."
            
        case LAError.invalidContext.rawValue:
            description = "LAContext passed to this call has been previously invalidated."
            
        case LAError.notInteractive.rawValue:
            description = "Authentication failed, because it would require showing UI which has been forbidden by using interactionNotAllowed property."
            
        case LAError.passcodeNotSet.rawValue:
            description = "Authentication could not start, because passcode is not set on the device."
            
        case LAError.systemCancel.rawValue:
            description = "Authentication was canceled by system (e.g. another application went to foreground)."
            
        case LAError.userCancel.rawValue:
            description = "Authentication was canceled by user (e.g. tapped Cancel button)."
            
        case LAError.userFallback.rawValue:
            description = "Authentication was canceled, because the user tapped the fallback button (Enter Password)."
            
        default:
            description = "Error code \(errorCode) not found"
        }
        print(description)
        
    }
    
}

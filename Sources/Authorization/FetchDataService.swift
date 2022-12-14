//
//  FetchDataService.swift
//  
//
//  Created by Ivan Konishchev on 14.12.2022.
//

import Foundation
import LoadService
import VKApiMethods
import AccountModel
import SwiftUI

@available(iOS 14.0, *)
final class FetchDataService {
    let service: LoadService
    init (token: String, userId: String) {
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        self.service = LoadService(userId: userId, method: .getUserInfo(token: token, userId: userId))
    }
    
    func loadAccountData() async {
        await service.loadFromInternet(object: AccountModel.self) { result in
            if let account = result.response.first {
                UserDefaults.standard.set(account.fullName, forKey: "userName")
                UserDefaults.standard.set(account.avatar, forKey: "userAvatar")
                UserDefaults.standard.set(account.screenName, forKey: "userNikName")
            }
        }
    }
    
}

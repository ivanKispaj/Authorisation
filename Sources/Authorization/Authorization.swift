//
//
// Authorisation.swift
//
// Created by Ivan Konishchev on 14.12.2022.
//
// Package for user authorization
// The minimum version of iOS is 15.0
//
// Writing documentation in active development!
//

import SwiftUI

@available(iOS 15.0, *)
public struct Authorisation: View {
    @State private var viewModel: FetchDataService = FetchDataService()
    @Binding var isLoggined: Bool // При изменении выйдет из пакета и перейдет дальше
    @AppStorage("token") private(set) var token = ""
    @AppStorage("userId") private(set) var userId: String = ""
    @AppStorage("authCode") private(set) var code = ""
    @AppStorage("userName") private(set) var userName = ""
    @State var isCancelBiometric = false
    // Использовать или нет биометрию для входа
    @AppStorage("isBiometricAuth") private(set) var isBiometricAuth = false
    // Тип биометрической авторизации поддержывающее кустройством
    var biometryAuthType: BiometricType = .none
    // Если входим впервые!!
    
    @State private var firstInput: Bool = false
    @State private(set) var isSaccesCode: Bool = false
    
    public var body: some View {
        
        if token.isEmpty {
            // If there is no token, then receiving the token,
            // after receiving the token, VKloginScene in UserDefaults (key: "token")
            // will write the token and the View will rebuild!
            VKLoginScene()
                .onAppear {
                    self.firstInput = true
                }
        } else if code.isEmpty {
            // If the code is missing, then create the code
            // After creating the code, SetCodeAuthentificate in UserDefaults (key: "AuthCode")
            // will write down the code
            SetCodeAuthentificate(biometryType: self.biometryAuthType)
                .onAppear {
                    self.viewModel = FetchDataService()
                    self.firstInput = true
                }
            
        } else {
            
            // If we are entering the application for the first time then
            if userName.isEmpty {
                GreetingМiew()
                    .onAppear {
                        isSaccesCode = true
                    }
                    .task {
                        await self.viewModel.loadAccountData()
                    }
                
            } else {
                
                if self.isBiometricAuth && !isCancelBiometric {
                    GreetingМiew()
                        .task {
                           await self.viewModel.authService.authentificate { result in
                               if result {
                                   self.isLoggined = true
                               }
                                isCancelBiometric = true
                            }
                        }
                } else {
                    if !isSaccesCode {
                        CodeAuthentificate(biometryType: self.biometryAuthType, verifyCode: self.code, isSuccesCode: $isSaccesCode, isBiometricAuth: $isBiometricAuth, isCancelBiopmetric: $isCancelBiometric)
                        
                    } else {
                        GreetingМiew()
                            .onAppear {
                                self.isLoggined = true
                            }
                    }
                }
              
                
            }
        }
        
    }
    
    
    public init(isLoggined: Binding<Bool>) {
        let device = DeviceAuthentificate()
        self.biometryAuthType = device.getAuthType()
        UserDefaults.standard.set(self.biometryAuthType.rawValue, forKey: "biometricType")
        self._isLoggined = isLoggined
    }
}

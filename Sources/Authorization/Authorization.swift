//
//
//
//
//
//
//
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
    // Использовать или нет биометрию для входа
    @AppStorage("isBiometricAuth") private(set) var isBiometricAuth = false
    // Тип биометрической авторизации поддержывающее кустройством
    var biometryAuthType: BiometricType = .none
    // Если входим впервые!!
    
    @State private var firstInput: Bool = false
    @State private(set) var isSaccesCode: Bool = false
    
    public var body: some View {
        
        if token.isEmpty {
            // Если токен отсутствует то получение токена
            // после полуычения токена VKloginScene в UserDefaults (key: "token")
            // запишет токен и View перестроится!
            VKLoginScene()
                .onAppear {
                    self.firstInput = true
                }
        } else if code.isEmpty {
            // Если код отсутствует то создаем код
            // После создания кода, SetCodeAuthentificate в UserDefaults (key: "authCode")
            // запишет код
            SetCodeAuthentificate(biometryType: self.biometryAuthType)
                .onAppear {
                    self.firstInput = true
                }
            
        } else {
            
            // Если мы впервые входим в приложение то
            if userName.isEmpty {
                GreetingМiew()
                    .onAppear {
                        isSaccesCode = true
                    }
                    .task {
                        await self.viewModel.loadAccountData()
                    }
                
            } else {
                
                if self.isBiometricAuth {
                    GreetingМiew()
                        .task {
                           await self.viewModel.authService.authentificate { result in
                               if result {
                                   self.isLoggined = true
                               }
                                isBiometricAuth = result
                            }
                        }
                } else {
                    if !isSaccesCode {
                        CodeAuthentificate(biometryType: self.biometryAuthType, verifyCode: self.code, isSuccesCode: $isSaccesCode, isBiometricAuth: $isBiometricAuth)
                        
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

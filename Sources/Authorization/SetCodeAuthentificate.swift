//
//  SetCodeAuthentificate.swift
//  
//
//  Created by Ivan Konishchev on 14.12.2022.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct SetCodeAuthentificate: View {
    
    @State private var code: String = ""
    @FocusState var isFocused: Bool
    @State var checked: Bool = false
    private(set) var biometryType: BiometricType
    
    var body: some View {
        
        ZStack {
            Color.white.opacity(0.2)
                .ignoresSafeArea()
            HStack {
                VStack() {
                    
                    Text("Установите пароль")
                    Text(" для входа!")
                        .padding(.bottom, 10)
                    
                    HStack(alignment: .center) {
                        
                        if let text = code.first, code.count >= 1 {
                            Text(String(text))
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        } else {
                            
                            Image(systemName: "circle.fill")
                                .frame(width: 20, height: 20)
                        }
                        
                        if  code.count >= 2 {
                            if let index = code.index(code.startIndex, offsetBy: 1) {
                                Text(String(code[index]))
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                            }
                            
                        } else {
                            Image(systemName: "circle.fill")
                                .frame(width: 20, height: 20)
                        }
                        
                        if   code.count >= 3 {
                            if let index = code.index(code.startIndex, offsetBy: 2) {
                                Text(String(code[index]))
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                            }
                            
                        } else {
                            Image(systemName: "circle.fill")
                                .frame(width: 20, height: 20)
                        }
                        
                        if  code.count >= 4 {
                            if let index = code.index(code.startIndex, offsetBy: 3) {
                                Text(String(code[index]))
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                            }
                            
                        } else {
                            Image(systemName: "circle.fill")
                                .frame(width: 20, height: 20)
                        }
                        
                    }
                    .padding()
                    .frame(height: 30)
                    if self.biometryType != .none {
                        Toggle("Использовать \(self.biometryType.rawValue) ?", isOn: $checked)
                            .onChange(of: checked) { newValue in
                                self.checked = newValue
                            }
                    }
                    
                    SecureField(text: $code, prompt:
                                    Text("")
                    ) {
                        Text("")
                    }
                    .frame(width: 0,height: 0)
                    .padding(0)
                    .focused($isFocused)
                    .onChange(of: code) { newValue in
                        if newValue.count == 4 {
                            self.code = String(newValue.prefix(4))
                            UserDefaults.standard.set(self.code.encodeBase64(), forKey: "authCode")
                            UserDefaults.standard.set(self.checked, forKey: "isBiometricAuth")
                            
                        }
                    }
                }
                .onAppear {
                    isFocused = true
                }
            }
            .frame(width: 250)
            .keyboardType(.numberPad)
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(5.0)
            .shadow(color: Color.white, radius: 8, x: -8, y: -8)
            .shadow(color: Color.black, radius: 8, x: 8, y: 8)
        }
        
        
    }
    
    init( biometryType: BiometricType) {
        self.biometryType = biometryType
    }
}

//
//  CodeAuthentificate.swift
//  
//
//  Created by Ivan Konishchev on 14.12.2022.
//

import Foundation

import SwiftUI
@available(iOS 15.0, *)
struct CodeAuthentificate: View {
    
    @State private var code: String = ""
    @State var isWrong: Bool = false
    @FocusState private var isFocused: Bool
    @Binding var isCancelBiometric: Bool
    @State private var colorBlock = Color.white
    @State private(set) var biometryType: BiometricType
    @State private(set) var verifyCode: String
    @Binding private(set) var isSuccesCode: Bool
    @Binding private(set) var isBiometricAuth: Bool
    
    var body: some View {
        // CODE AUTHORIZATION
        HStack {
            VStack {
                Text("Введите пароль")
                    .padding(.bottom, 10)
                HStack(alignment: .center) {
                    
                    
                    if code.count >= 1 {
                        Image(systemName: "circle.fill")
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "circle")
                            .frame(width: 20, height: 20)
                            .foregroundColor(colorBlock)
                    }
                    
                    if code.count >= 2 {
                        Image(systemName: "circle.fill")
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "circle")
                            .frame(width: 20, height: 20)
                            .foregroundColor(colorBlock)
                    }
                    
                    if code.count >= 3 {
                        Image(systemName: "circle.fill")
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "circle")
                            .frame(width: 20, height: 20)
                            .foregroundColor(colorBlock)
                    }
                    
                    if code.count >= 4 {
                        Image(systemName: "circle.fill")
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "circle")
                            .frame(width: 20, height: 20)
                            .foregroundColor(colorBlock)
                    }
                    
                }
                .scaleEffect(isWrong ? 1.3 : 1)
                .padding()
                .frame(height: 30)
                
                SecureField(text: $code, prompt: Text("")) {
                    Text("")
                }
                .frame(width: 0,height: 0)
                .padding(0)
                .focused($isFocused)
                .onChange(of: code) { newValue in
                    if newValue.count >= 4 {
                        self.code = String(newValue.prefix(4))
                        self.verifyLogin()
                        
                    }
                }
                //MARK: View для отображене кнопки вызова faceId or TouchId
                Divider()
                    .background(Color.white)

                VStack {
                    if self.isBiometricAuth  {
                        switch self.biometryType {
                            
                        case .faceID:
                            Image(systemName: "faceid")
                                .resizable()
                                .frame(width: 50,height: 50)
                                .onTapGesture {
                                    if self.isBiometricAuth {
                                        self.isCancelBiometric = false
                                    }
                                }
                                .padding(.top, 10)
                        default:
                            Image(systemName: "touchid")
                                .resizable()
                                .frame(width: 50,height: 50)
                                .onTapGesture {
                                    if self.isBiometricAuth {
                                        self.isCancelBiometric = false
                                    }
                                }
                                .padding(.top, 10)
                        }
                    }
                }
            }
            
        }
        .onAppear {
            isFocused = true
        }
        .onTapGesture {
            colorBlock = .white
            isFocused = true
        }
        
        .frame(width: 150)
        .keyboardType(.numberPad)
        .padding()
        .background(Color.blue.opacity(0.2))
        .cornerRadius(5.0)
        .shadow(color: Color.gray, radius: 5, x: -8, y: -8)
        .shadow(color: Color.blue, radius: 5, x: 8, y: 8)
        
   
        
        
    }
    
    //MARK: - VERIFY  ENTER CODE
    private func verifyLogin() {
        
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
        if  self.verifyCode == self.code.encodeBase64() {
            self.isSuccesCode = true
        } else {
            isWrong.toggle()
            
            withAnimation(.easeIn(duration: 0.2)) {
                self.code = ""
                colorBlock = .red
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation (.spring(response: 0.5,dampingFraction: 0.6)) {
                    isWrong.toggle()
                    colorBlock = .white
                }
            }
            
        }
    }
    init(biometryType: BiometricType, verifyCode: String, isSuccesCode: Binding<Bool>, isBiometricAuth: Binding<Bool>, isCancelBiopmetric: Binding<Bool>) {
        self.biometryType = biometryType
        self.verifyCode = verifyCode
        self._isSuccesCode = isSuccesCode
        self._isBiometricAuth = isBiometricAuth
        self._isCancelBiometric = isCancelBiopmetric
    }
}

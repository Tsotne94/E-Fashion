//
//  LoginView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//

import SwiftUI
import Combine

struct LoginView: View {
    @StateObject private var viewModel = DefaultLoginViewModel()
    @FocusState private var focusedField: InputField?
    
    @State private var emailAnimation = AnimationState()
    @State private var passwordAnimation = AnimationState()
    
    var body: some View {
        VStack(spacing: 35) {
            SUIAuthHeaderView(title: SignInPageTexts.tittle)
            
            inputFieldsGroup
            
            SUIPrimaryButton(title: "Log In", action: viewModel.logIn)
            
            Button {
                viewModel.signUp()
            } label: {
                Text("Don't Have An Account? **Sign Up**")
                    .foregroundStyle(.accentBlack)
                    .shadow(radius: 5, y: 3)
            }
            
            SUIGradientDivider(text: "or")
            
            SUISocialLoginSection(
                title: SignInPageTexts.loginOptions,
                onSocialLogin: { provider in
                    
                }
            )
            
            Spacer()
        }
        .padding()
        .background(Color.customWhite, ignoresSafeAreaEdges: .all)
        .onChange(of: focusedField) { _ in
            updateAnimations()
        }
        .overlay {
            if viewModel.isLoading {
                SUILoader()
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text(SignInPageTexts.loginFail),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var inputFieldsGroup: some View {
        Group {
            emailField
            VStack(alignment: .trailing) {
                passwordField
                forgotPasswordButton
            }
        }
    }
    
    private var emailField: some View {
        TextField("", text: $viewModel.email)
            .padding()
            .textFieldStyle(
                width: emailAnimation.width,
                text: SignInPageTexts.emailTextField,
                animation: emailAnimation.offset
            )
            .textContentType(.emailAddress)
            .focused($focusedField, equals: .email)
    }
    
    private var passwordField: some View {
        ZStack(alignment: .trailing) {
            Group {
                if viewModel.passwordIsHidden {
                    SecureField("", text: $viewModel.password)
                } else {
                    TextField("", text: $viewModel.password)
                }
            }
            .onSubmit {
                viewModel.logIn()
            }
            .frame(height: 55)
            .padding(.leading)
            .textFieldStyle(
                width: passwordAnimation.width,
                text: SignInPageTexts.passwordTextField,
                animation: passwordAnimation.offset
            )
            .focused($focusedField, equals: .password)
            togglePasswordVisibilityButton
        }
    }
    
    private var forgotPasswordButton: some View {
        Button {
            viewModel.forgotPassword()
        } label: {
            Text(SignInPageTexts.forgotPassword)
                .foregroundStyle(.accentRed)
                .shadow(radius: 5, y: 3)
        }
    }
    
    private var togglePasswordVisibilityButton: some View {
        Button {
            viewModel.passwordIsHidden.toggle()
        } label: {
            Image(systemName: viewModel.passwordIsHidden ? Icons.eye : Icons.eyeSlashed)
                .padding(.trailing)
                .foregroundStyle(Color.black)
                .shadow(radius: 5, y: 3)
        }
    }
    
    private func updateAnimations() {
        withAnimation(.spring()) {
            emailAnimation.animate(
                for: .email,
                isFocused: focusedField == .email,
                isEmpty: viewModel.email.isEmpty
            )
            
            passwordAnimation.animate(
                for: .password,
                isFocused: focusedField == .password,
                isEmpty: viewModel.password.isEmpty
            )
        }
    }
}

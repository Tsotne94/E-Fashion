//
//  LoginView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//
import SwiftUI
import Combine

enum InputField: Hashable {
    case name
    case email
    case password
    
    var labelWidth: CGFloat {
        switch self {
        case .email: return 60
        case .password: return 95
        case .name: return 60
        }
    }
}

struct AnimationState {
    var width: CGFloat = 0
    var offset: CGFloat = 0
    
    mutating func animate(for field: InputField, isFocused: Bool, isEmpty: Bool) {
        if isEmpty && !isFocused {
            width = 0
            offset = 0
        } else {
            width = field.labelWidth
            offset = -30
        }
    }
}

struct LoginView: View {
    @StateObject private var viewModel = DefaultLoginViewModel()
    @FocusState private var focusedField: InputField?
    
    @State private var emailAnimation = AnimationState()
    @State private var passwordAnimation = AnimationState()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 35) {
                headerView
                inputFieldsGroup
                loginButton
                signUpButton
                divider
                socialLoginButtons
                Spacer()
            }
        }
        .padding()
        .background(Color.customWhite, ignoresSafeAreaEdges: .all)
        .onChange(of: focusedField) { _ in
            updateAnimations()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text(SignInPageTexts.tittle)
                .font(.custom(CustomFonts.nutinoBlack, size: UIScreen.main.bounds.height > 667 ? 45 : 35))
                .frame(width: UIScreen.main.bounds.height > 667 ? 230 : 300)
                .shadow(radius: 5, y: 3)
                .padding(.bottom, 10)
            Spacer()
        }
    }
    
    private var inputFieldsGroup: some View {
        Group {
            emailField
            passwordField
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
        .padding(.bottom, 10)
    }
    
    private var togglePasswordVisibilityButton: some View {
        Button {
            viewModel.passwordIsHidden.toggle()
        } label: {
            Image(systemName: viewModel.passwordIsHidden ? "eye" : "eye.slash")
                .padding(.trailing)
                .foregroundStyle(Color.black)
                .shadow(radius: 5, y: 3)
        }
    }
    
    private var loginButton: some View {
        Button {
            viewModel.logIn()
        } label: {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .frame(height: 55)
                .overlay {
                    Text("Log In")
                        .bold()
                        .font(.title3)
                        .foregroundStyle(Color.white)
                }
                .foregroundStyle(.accentRed)
                .shadow(radius: 10, y: 5)
        }
    }
    
    private var signUpButton: some View {
        Button {
            viewModel.signUp()
        } label: {
            Text("Don't Have An Account? **Sign Up**")
                .foregroundStyle(.accentBlack)
                .shadow(radius: 5, y: 3)
        }
    }
    
    private var divider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [.black, .white, .black]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay {
                Text("or")
            }
    }
    
    private var socialLoginButtons: some View {
        VStack {
            Text("Continue With")
                .foregroundStyle(.accentBlack)
                .shadow(radius: 5, y: 3)
            
            HStack(spacing: 20) {
                ForEach([LoginSignup.google, LoginSignup.apple, LoginSignup.facebook], id: \.self) { image in
                    socialLoginButton(image: image)
                }
            }
        }
    }
    
    private func socialLoginButton(image: String) -> some View {
        Button {
            
        } label: {
            Image(image)
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

#Preview {
    LoginView()
}

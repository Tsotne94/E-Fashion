//
//  SignUpView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//
import SwiftUI
import Combine

struct SignUpView: View {
    @StateObject private var viewModel = DefaultSignUpViewModel()
    @FocusState private var focusedField: InputField?
    
    @State private var nameAnimation = AnimationState()
    @State private var emailAnimation = AnimationState()
    @State private var passwordAnimation = AnimationState()
    @State private var confirmPasswordAnimation = AnimationState()
    
    @State private var errorMessage = ""
    @State private var showAllert = false
    
    @State private var subscriptions = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button {
                viewModel.goToLogin()
            } label: {
                Text("go back").font(.title3).bold()
            }
        }
    }
}

#Preview {
    SignUpView()
}

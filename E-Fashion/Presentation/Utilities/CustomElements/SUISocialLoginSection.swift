//
//  SocialLoginSection.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 19.01.25.
//
import SwiftUI

struct SUISocialLoginSection: View {
    let title: String
    let onSocialLogin: (String) -> Void
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundStyle(.accentBlack)
                .shadow(radius: 5, y: 3)
            
            HStack(spacing: 20) {
                ForEach([LoginSignup.google, LoginSignup.apple, LoginSignup.facebook], id: \.self) { provider in
                    Button {
                        onSocialLogin(provider)
                    } label: {
                        Image(provider)
                    }
                }
            }
        }
    }
}

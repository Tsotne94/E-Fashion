//
//  LoginView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//

import SwiftUI

struct LoginView: View {
    let doneRequested: () -> Void
    
    init(doneRequested: @escaping () -> Void) {
        self.doneRequested = doneRequested
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LoginView(doneRequested: { })
}

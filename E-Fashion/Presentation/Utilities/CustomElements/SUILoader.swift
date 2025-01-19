//
//  alertView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 19.01.25.
//
import SwiftUI
import Lottie

struct SUILoader: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            LottieView(animation: .named("loader"))
                .configure { lottie in
                    lottie.contentMode = .scaleAspectFit
                }
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .frame(width: 100, height: 100) 
                .scaledToFit()
        }
    }
}

#Preview {
    SUILoader()
}

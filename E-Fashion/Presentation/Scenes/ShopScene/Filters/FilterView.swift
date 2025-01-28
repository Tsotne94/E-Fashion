//
//  FilterViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//

import SwiftUI

struct FilterView: View {
    var body: some View {
        VStack {
            SUICustomHeaderView(title: "testing stuff")
            Text("hello world")
            Spacer()
        }.background(.customWhite)
    }
    
    private func headerView() -> some View {
        VStack {
            HStack {
                
            }
        }.frame(height: FilterView.headerHeight())
            .background(.customWhite)
    }
}

#Preview {
    FilterView()
}



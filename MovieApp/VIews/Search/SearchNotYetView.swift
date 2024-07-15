//
//  SearchNotYetView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 15/07/24.
//

import SwiftUI

struct SearchNotYetView: View {
    var body: some View {
        VStack{
            Image("sny")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    SearchNotYetView()
}

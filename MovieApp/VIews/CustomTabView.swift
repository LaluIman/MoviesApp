//
//  CustomTabView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 15/07/24.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNameSpace
    
    let tabBarItems: [(image: String, title: String)] = [
        ("house.fill", "Home"),
        ("magnifyingglass", "Search"),
        ("heart.fill", "Favorite"),
    ]
    
    var body: some View {
        ZStack {
            CapsuleBackground()
            tabBarItemsView
        }
        .padding(.horizontal)
    }
    
    private var tabBarItemsView: some View {
        HStack {
            ForEach(0..<tabBarItems.count, id: \.self) { index in
                TabBarItemView(
                    image: tabBarItems[index].image,
                    title: tabBarItems[index].title,
                    isSelected: index + 1 == tabSelection,
                    animationNamespace: animationNameSpace
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.6)) {
                        tabSelection = index + 1
                    }
                }
            }
        }
        .frame(height: 70)
        .background(.black)
        .clipShape(Capsule())
    }
}

struct CapsuleBackground: View {
    var body: some View {
        Capsule()
            .frame(height: 70)
            .foregroundStyle(Color(.white))
            .shadow(color: .white,radius: 1)
    }
}

struct TabBarItemView: View {
    let image: String
    let title: String
    let isSelected: Bool
    let animationNamespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 6) {
            Spacer()
            Image(systemName: image)
                .scaleEffect(isSelected ? 1.0 : 0.9)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
            Text(title)
                .scaleEffect(isSelected ? 1.0 : 0.9)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
            if isSelected {
                Capsule()
                    .frame(height: 15)
                    .foregroundStyle(.red)
                    .matchedGeometryEffect(id: "SelectedTabId", in: animationNamespace)
                    .offset(y: 3)
                    .padding(.horizontal, 20)
            } else {
                Capsule()
                    .frame(height: 8)
                    .foregroundStyle(.clear)
                    .offset(y: 3)
            }
        }
        .foregroundStyle(isSelected ? .red : .gray)
        .font(.headline)
        .fontWeight(isSelected ? .bold : .semibold)
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
}

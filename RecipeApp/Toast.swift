//
//  Toast.swift
//  RecipeApp
//
//  Created by mac on 6/13/24.
//

import SwiftUI

struct Toast: View {
  var message: String
  @Binding var isShowing: Bool
  
  var body: some View {
    if isShowing {
      VStack {
        Spacer()
        Text(message)
          .font(.system(size: 14))
          .padding()
          .background(Color.black.opacity(0.8))
          .foregroundColor(.white)
          .cornerRadius(10)
          .padding(.bottom, 20)
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
      }
      .frame(maxWidth: .infinity)
    }
  }
}

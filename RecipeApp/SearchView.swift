import SwiftUI

struct SearchView: View {
  @State private var ingredientInput: String = ""
  @State private var selectedIngredients: [String] = []
  @State private var navigateToSearchRecipeView = false
  
  var body: some View {
    NavigationStack {
        VStack(spacing: 12) {
            headerView
            ingredientInputView
            selectedIngredientsView
            recommendedIngredientsView
            searchButton
        }
        .padding(.bottom, 12)
        .background(Color.white)
        .navigationBarHidden(true) 
    }
  }
  
  private var headerView: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 8) {
        Text("오늘 뭐먹지?")
          .font(.custom("Roboto", size: 20).bold())
          .lineSpacing(24)
          .foregroundColor(.black)
      }
      .padding(.all, 12)
      .frame(maxWidth: .infinity)
    }
    .frame(height: 48)
    .background(Color.white)
    .shadow(color: Color.black.opacity(0.12), radius: 6)
  }
  
  private var ingredientInputView: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("재료 입력")
        .font(.custom("Roboto", size: 18).weight(.medium))
        .foregroundColor(.black)
      HStack(spacing: 4) {
        TextField("재료를 입력하세요...", text: $ingredientInput)
          .font(.custom("Roboto", size: 14))
          .foregroundColor(Color.black.opacity(0.5))
          .padding(8)
          .background(Color.white)
          .cornerRadius(6)
          .overlay(
            RoundedRectangle(cornerRadius: 6)
              .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
          )
        Button(action: {
          addIngredient()
        }) {
          Text("추가")
            .font(.custom("Roboto", size: 14))
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.black)
            .cornerRadius(6)
        }
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 12)
  }
  
  private var selectedIngredientsView: some View {
    VStack(spacing: 0) {
      HStack(spacing: 12) {
        Text("선택된 재료")
          .font(.custom("Roboto", size: 18).weight(.medium))
          .foregroundColor(.black)
        Spacer()
        Text("Clear All")
          .font(.custom("Roboto", size: 12))
          .foregroundColor(.black)
          .padding(.all, 3)
          .background(
            RoundedRectangle(cornerRadius: 4)
              .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
          )
          .onTapGesture {
            selectedIngredients.removeAll()
          }
      }
      .padding(.top, 16)
      .frame(maxWidth: .infinity)
      
      ScrollView {
        VStack(alignment: .leading, spacing: 10) {
          ForEach(selectedIngredients, id: \.self) { ingredient in
            ingredientItemView(emoji: "🍅", name: ingredient)
          }
        }
        .padding(.bottom, 10)
      }
    }
    .padding(.horizontal, 12)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  private var recommendedIngredientsView: some View {
    VStack(spacing: 8) {
      Text("추천 재료")
        .font(.custom("Roboto", size: 18).weight(.medium))
        .foregroundColor(.black)
        .padding(.top, 16)
      HStack(alignment: .top, spacing: 8) {
        recommendedIngredientItemView(emoji: "🌿", name: "시금치")
        recommendedIngredientItemView(emoji: "🧅", name: "양파")
        recommendedIngredientItemView(emoji: "🥕", name: "당근")
      }
    }
    .padding(.horizontal, 12)
    .frame(height: 104)
  }
  
  private var searchButton: some View {
    VStack(spacing: 8) {
      NavigationLink(destination: SearchRecipeView(selectedIngredients: selectedIngredients), isActive: $navigateToSearchRecipeView) {
        Text("검색")
          .font(.custom("Roboto", size: 16).weight(.medium))
          .foregroundColor(.white)
          .padding()
          .frame(maxWidth: .infinity, minHeight: 42, maxHeight: 42)
          .background(Color.black)
          .cornerRadius(8)
          .onTapGesture {
            navigateToSearchRecipeView = true
          }
      }
    }
    .padding(.horizontal, 12)
  }
  
  private func ingredientItemView(emoji: String, name: String) -> some View {
    HStack(spacing: 8) {
      Text(emoji)
        .font(.custom("Roboto", size: 20))
        .frame(width: 32, height: 32)
        .background(Color.black.opacity(0.05))
        .cornerRadius(16)
      Text(name)
        .font(.custom("Roboto", size: 14))
        .foregroundColor(.black)
    }
    .padding(.vertical, 12)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private func recommendedIngredientItemView(emoji: String, name: String) -> some View {
    Button(action: {
      selectedIngredients.append(name)
    }) {
      HStack(spacing: 8) {
        Text(emoji)
          .font(.custom("Roboto", size: 20))
          .frame(width: 32, height: 32)
          .background(Color.black.opacity(0.05))
          .cornerRadius(16)
        Text(name)
          .font(.custom("Roboto", size: 14).weight(.medium))
          .foregroundColor(.black)
      }
      .padding()
      .frame(height: 56)
      .background(
        RoundedRectangle(cornerRadius: 6)
          .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
      )
    }
  }
  
  private func addIngredient() {
    guard !ingredientInput.isEmpty else { return }
    selectedIngredients.append(ingredientInput)
    ingredientInput = ""
  }
}

#Preview {
  SearchView()
}

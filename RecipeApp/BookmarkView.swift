import SwiftUI
import FirebaseFirestore

struct BookmarkView: View {
  @State private var recipes: [RecipeDetail] = []
  @State private var isLoading = true
  private let firebaseService = FirebaseService()
  
  var body: some View {
    NavigationStack{
      VStack(spacing: 0) {
        headerView
        if isLoading {
          ProgressView()
        } else {
          contentView
        }
      }
      .padding(.bottom, 62)
      .background(Color.white)
      .onAppear {
        fetchRecipes()
      }
    }
    .navigationBarHidden(true) // 네비게이션 바 숨김
  }
  
  private func fetchRecipes() {
    firebaseService.fetchRecipes { result in
      switch result {
      case .success(let fetchedRecipes):
        self.recipes = fetchedRecipes
        self.isLoading = false
      case .failure(let error):
        print("Error fetching recipes: \(error)")
        self.isLoading = false
      }
    }
  }
  
  private var headerView: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 8) {
        Text("저장된 레시피")
          .font(.custom("Roboto", size: 20).weight(.medium))
          .lineSpacing(24)
          .foregroundColor(.black)
      }
      .padding(.horizontal, 8)
      .padding(.vertical, 12)
      .frame(maxWidth: .infinity)
    }
    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)
    .background(Color.white)
    .shadow(color: Color.black.opacity(0.12), radius: 6)
  }
  
  private var contentView: some View {
    ScrollView {
      VStack(spacing: 0) {
        ForEach(recipes) { recipe in
          recipeItemView(
            recipe: recipe,
            title: recipe.name ?? "Unknown",
            kcal: "\(recipe.calories)kcal",
            category: recipe.category ?? "Unknown",
            ingredients: "재료 : \(recipe.ingredients.map { $0.name }.joined(separator: ", "))"
          )
          
        }
      }
      .padding(.horizontal, 12)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  
  private func recipeItemView(recipe: RecipeDetail, title: String, kcal: String, category: String, ingredients: String) -> some View {
    NavigationLink(
      destination: RecipeDetailView(
        recipe: Recipe(
          name: recipe.name ?? "Unknown",
          time: recipe.time ?? 0,
          category: recipe.category ?? "Unknown",
          img_url: nil
        ),
        fromRecipeDetail: recipe
      )
    ){
      VStack(spacing: 0) {
        HStack(spacing: 12) {
          imagePlaceholder
          VStack(alignment: .leading, spacing: 0) {
            Text(title)
              .font(.custom("Roboto", size: 16).weight(.medium))
              .lineSpacing(20)
              .foregroundColor(.black)
            HStack(spacing: 6) {
              infoLabel(text: kcal, width: 50)
              infoLabel(text: category, width: 31)
            }
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(ingredients)
              .font(.custom("Roboto", size: 12))
              .lineSpacing(20)
              .foregroundColor(.black)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        Divider() // 여기에 경계선을 추가합니다
      }
    }
  }
  
  private var imagePlaceholder: some View {
    Rectangle()
      .foregroundColor(.clear)
      .frame(width: 80, height: 80)
      .background(Color.black.opacity(0.05))
  }
  
  private func infoLabel(text: String, width: CGFloat) -> some View {
    Text(text)
      .font(Font.custom("Roboto", size: 12))
      .lineSpacing(16)
      .foregroundColor(.black)
      .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
      .background(Color.black.opacity(0.05))
      .cornerRadius(2)
      .overlay(
        RoundedRectangle(cornerRadius: 2)
          .inset(by: 0.25)
          .stroke(Color.black.opacity(0.10), lineWidth: 0.25)
      )
  }
}

#Preview {
  BookmarkView()
}

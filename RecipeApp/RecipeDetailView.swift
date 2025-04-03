//
//  RecipeDetailView.swift
//  RecipeApp
//
//  Created by mac on 6/12/24.
//

import SwiftUI

struct RecipeDetailView: View {
  var recipe: Recipe
  var fromRecipeDetail: RecipeDetail?
  @State private var recipeDetail: RecipeDetail?
  @State private var showToast = false
  @State private var toastMessage = ""
  let openAiSite = "https://api.openai.com/v1/chat/completions"
  let openAiKey = Bundle.main.OpenAiKey
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      recipeHeader
      recipeOverview
      ScrollView {
        VStack(alignment: .leading, spacing: 26) {
          if let detail = recipeDetail {
            nutritionInfoSection(detail: detail)
            ingredientsSection(ingredients: detail.ingredients)
            cookingStepsSection(steps: detail.steps)
          } else {
            Text("로딩 중...")
          }
        }
        .padding(.horizontal, 16)
      }
      .frame(maxHeight: .infinity)
    }
    .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
    .background(Color.white)
    .navigationBarHidden(false) // 네비게이션 바 표시
    .onAppear {
      if let fromRecipeDetail {
        recipeDetail = fromRecipeDetail
      }
      else{
        fetchRecipeDetail()
      }
    }
    .overlay(Toast(message: toastMessage, isShowing: $showToast))
  }
  
  private var recipeHeader: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 8) {
        Text("상세 레시피")
          .font(Font.custom("Roboto", size: 20).weight(.medium))
          .lineSpacing(24)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
      }
      .frame(maxWidth: .infinity)
    }
    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)
    .background(Color.white)
    .shadow(color: Color.black.opacity(0.12), radius: 6)
  }
  
  private var recipeOverview: some View {
    HStack(spacing: 12) {
      Rectangle()
        .foregroundColor(.clear)
        .frame(width: 40, height: 40)
        .background(Color.black.opacity(0.10))
        .cornerRadius(40)
      VStack(alignment: .leading, spacing: 0) {
        Text("\(recipe.name) (1인분)")
          .font(Font.custom("Roboto", size: 16).weight(.medium))
          .lineSpacing(24)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
        Text("조리 시간: \(recipe.time)분")
          .font(Font.custom("Roboto", size: 12))
          .lineSpacing(16)
          .foregroundColor(Color.black.opacity(0.50))
          .multilineTextAlignment(.leading)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      Button(action: {
                 saveRecipeDetailToFirestore()
             }) {
                 Text("저장")
                     .foregroundColor(.white)
                     .padding()
                     .background(Color.black)
                     .cornerRadius(8)
             }
    }
    .padding(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
    .frame(maxWidth: .infinity)
  }
  
  private func ingredientsSection(ingredients: [Ingredient]) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("필요한 재료")
        .font(Font.custom("Roboto", size: 18).weight(.medium))
        .foregroundColor(.black)
        .multilineTextAlignment(.leading)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
          ForEach(ingredients) { ingredient in
            ingredientItem(ingredient: ingredient)
          }
        }
      }
    }
  }
  
  private func ingredientItem(ingredient: Ingredient) -> some View {
    print(ingredient)
    return VStack(spacing: 0) {
      HStack(alignment: .top, spacing: 0) {
        if let imgUrl = ingredient.img_url, let url = URL(string: imgUrl) {
          AsyncImage(url: url) { image in
            image
              .resizable()
              .frame(width: 164, height: 164)
              .background(Color.black.opacity(0.05))
          } placeholder: {
            Color.gray
              .frame(width: 164, height: 164)
          }
        }else {
          Color.gray
            .frame(width: 164, height: 164)
        }
      }
      .frame(maxWidth: .infinity, minHeight: 164, maxHeight: 164)
      VStack(alignment: .leading, spacing: 4) {
        Text(ingredient.name)
          .font(Font.custom("Roboto", size: 12))
          .lineSpacing(1)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
        Text(ingredient.amount)
          .font(Font.custom("Roboto", size: 16).weight(.medium))
          .lineSpacing(1)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
      }
      .padding(8)
      .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .leading)
    }
    .frame(maxWidth: .infinity)
    .cornerRadius(6)
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .inset(by: 0.50)
        .stroke(Color.black.opacity(0.10), lineWidth: 0.50)
    )
  }
  
  private func cookingStepsSection(steps: [RecipeDetailStep]) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("요리법")
        .font(Font.custom("Roboto", size: 18).weight(.medium))
        .foregroundColor(.black)
        .multilineTextAlignment(.leading)
      VStack(alignment: .leading, spacing: 16) {
        ForEach(steps) { step in
          cookingStep("단계 \(step.step)", description: step.description, imgUrl: step.img_url)
        }
      }
    }
  }
  
  private func cookingStep(_ title: String, description: String, imgUrl: String?) -> some View {
    HStack(alignment: .top, spacing: 12) {
      if let imgUrl = imgUrl, let url = URL(string: imgUrl) {
        AsyncImage(url: url) { image in
          image
            .resizable()
            .frame(width: 80, height: 80)
            .background(Color.black.opacity(0.05))
        } placeholder: {
          Color.gray
            .frame(width: 80, height: 80)
        }
      }else {
        Color.gray
          .frame(width: 80, height: 80)
      }
      VStack(alignment: .leading, spacing: 5) {
        Text(title)
          .font(Font.custom("Roboto", size: 16).weight(.medium))
          .lineSpacing(1)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
        Text(description)
          .font(Font.custom("Roboto", size: 12))
          .lineSpacing(1)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  private func nutritionInfoSection(detail: RecipeDetail) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("영양 정보")
        .font(Font.custom("Roboto", size: 18).weight(.medium))
        .foregroundColor(.black)
        .multilineTextAlignment(.leading)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
          nutritionInfo("🔥", title: "칼로리", value: "\(detail.calories) kcal")
          nutritionInfo("🍚", title: "탄수화물", value: "\(detail.carbohydrate) g")
          nutritionInfo("🥩", title: "단백질", value: "\(detail.protain) g")
          nutritionInfo("🍳", title: "지방", value: "\(detail.fat) g")
        }
      }
    }
  }
  
  private func nutritionInfo(_ icon: String, title: String, value: String) -> some View {
    HStack(spacing: 8) {
      Text(icon)
        .font(Font.custom("Roboto", size: 20))
        .lineSpacing(32)
        .foregroundColor(.black)
        .multilineTextAlignment(.leading)
        .frame(width: 32, height: 32)
        .background(Color.black.opacity(0.05))
        .cornerRadius(16)
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(Font.custom("Roboto", size: 14).weight(.medium))
          .lineSpacing(16)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
        Text(value)
          .font(Font.custom("Roboto", size: 12))
          .lineSpacing(16)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
      }
    }
    .padding(12)
    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56, alignment: .leading)
    .cornerRadius(6)
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .inset(by: 0.50)
        .stroke(Color.black.opacity(0.10), lineWidth: 0.50)
    )
  }
  
  private func fetchRecipeDetail() {
    Task {
      do {
        let prompt = """
                {
                  "calories": 200,
                  "carbohydrate":50,
                  "fat": 10,
                  "protain":21,
                  "ingredients":[
                    {
                      "id":1,
                      "name":"양파",
                      "amount":"반 개"
                    },
                    {
                      "id":2,
                      "name":"고추장",
                      "amount":"한 큰술"
                    },
                    {
                      "id":3,
                      "name":"돼지 고기",
                      "amount":"150g"
                    }
                  ],
                  "steps":[
                    {
                      "id":1,
                      "step":1,
                      "description":"양파를 물에 씻으세요."
                    },
                    {
                      "id":2,
                      "step":2,
                      "description":"후라이팬에 식용유를 두르고 다진 마늘을 볶아 주세요."
                    },
                    {
                      "id":3,
                      "step":3,
                      "description":"양파를 후라이팬에 넣고 갈색이 될 때까지 볶아 주세요."
                    }
                  ]
                }
                ingredients와 steps의 갯수는 최소 1개 이상이여야 해.
                ingredients와 steps의 갯수가 꼭 3개씩일 필요는 없어.
                이 형식에 맞게 \(recipe.name) 의 레시피들 알려줘.
                calories는 kcal 단위로 숫자만 넣어줘.
                
                carbohydrate, fat, protain은 g단위로 숫자만 넣어줘.
                반드시 text는 한국어로 적어줘.
                """
        let requestData: [String: Any] = [
          "model": "gpt-3.5-turbo",
          "messages": [["role": "user", "content": prompt]],
          "max_tokens": 500
        ]
        
        var request = URLRequest(url: URL(string: openAiSite)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(openAiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
          print(response)
          throw URLError(.badServerResponse)
        }
        
        let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let choices = responseData?["choices"] as? [[String: Any]],
              let message = choices.first?["message"] as? [String: Any],
              let content = message["content"] as? String else {
          throw URLError(.cannotParseResponse)
        }
        
//        let content = """
//{
//  "calories": 250,
//  "carbohydrate": 15,
//  "fat": 18,
//  "protain": 12,
//  "ingredients":[
//    {
//      "id":1,
//      "name":"소세지",
//      "amount":"2개"
//    },
//    {
//      "id":2,
//      "name":"당근",
//      "amount":"1/2개"
//    },
//    {
//      "id":3,
//      "name":"양파",
//      "amount":"1/2개"
//    }
//  ],
//  "steps":[
//    {
//      "id":1,
//      "step":1,
//      "description":"소세지를 편으로 자른 후 당근과 양파를 채 썰어 준비합니다."
//    },
//    {
//      "id":2,
//      "step":2,
//      "description":"후라이팬에 식용유를 두르고 소세지를 볶아줍니다."
//    },
//    {
//      "id":3,
//      "step":3,
//      "description":"소세지가 익으면 당근과 양파를 넣고 볶아줍니다."
//    }
//  ]
//}
//"""
        print(content)
        
        
        // JSON 응답을 RecipeDetail로 변환
        if let jsonData = content.data(using: .utf8) {
          let decoder = JSONDecoder()
          var detail = try decoder.decode(RecipeDetail.self, from: jsonData)
          detail.category = recipe.category
          detail.time = recipe.time
          detail.name = recipe.name
          detail.id = UUID()
          print(detail)
          DispatchQueue.main.async {
            self.recipeDetail = detail
          }
        }
      } catch {
        print("Error fetching recipe detail: \(error)")
      }
    }
  }
  
  private func saveRecipeDetailToFirestore() {
      guard let recipeDetail = recipeDetail else { return }
      
      let firebaseService = FirebaseService()
      firebaseService.saveRecipeDetail(recipeDetail: recipeDetail) { result in
          switch result {
          case .success():
              print("Recipe detail saved successfully.")
            showToastMessage("저장되었습니다.")
          case .failure(let error):
              print("Error saving recipe detail: \(error)")
            showToastMessage("저장을 실패했습니다.")
          }
      }
  }
  
  private func showToastMessage(_ message: String) {
          toastMessage = message
          withAnimation {
              showToast = true
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              withAnimation {
                  showToast = false
              }
          }
      }
}

struct RecipeDetailView_Previews: PreviewProvider {
  static var previews: some View {
    RecipeDetailView(recipe: Recipe(name: "스팸김치찌개", time: 15, category: "국", img_url: "https://www.foodsafetykorea.go.kr/uploadimg/20200309/20200309012227_1583727747787.JPG"))
  }
}

struct RecipeDetail: Identifiable, Codable {
  var id: UUID?
  var calories: Int
  var carbohydrate: Int
  var fat: Int
  var protain: Int
  var ingredients: [Ingredient]
  var steps: [RecipeDetailStep]
  var time: Int?
  var category: String?
  var name:String?
}

struct Ingredient: Identifiable, Codable {
  var id: Int?
  var name: String
  var amount: String
  var img_url: String?
}

struct RecipeDetailStep: Identifiable, Codable {
  var id: Int?
  var step: Int
  var description: String
  var img_url: String?
} 



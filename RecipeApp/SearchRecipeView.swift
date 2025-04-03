//
//  SearchRecipeView.swift
//  RecipeApp
//
//  Created by mac on 6/11/24.
//

import SwiftUI

struct Recipe: Identifiable, Codable {
  var id: UUID = UUID()
  var name: String
  var time: Int
  var category: String
  var img_url: String? // Optional type
  
  // If you need an initializer
  init(id: UUID = UUID(), name: String, time: Int, category: String, img_url: String? = nil) {
    self.id = id
    self.name = name
    self.time = time
    self.category = category
    self.img_url = img_url
  }
}

struct SearchRecipeView: View {
  var selectedIngredients: [String]
  @State private var recommendedRecipes: [Recipe] = []
  @State private var isLoading: Bool = false
  @State private var errorMessage: String? = nil
  
  let openAiSite = "https://api.openai.com/v1/chat/completions"
  let openAiKey = Bundle.main.OpenAiKey
  
  var body: some View {
    NavigationStack {
      VStack(alignment: .leading, spacing: 12) {
        headerView
        if isLoading {
          Text("로딩 중...")
            .frame(maxHeight: .infinity)
        } else if let errorMessage = errorMessage {
          Text("Error: \(errorMessage)")
            .foregroundColor(.red)
        } else {
          recommendedRecipesView
        }
      }
      .padding(.bottom, 62)
      .background(Color.white)
      .navigationBarHidden(true) // 네비게이션 바 표시
      .onAppear {
        fetchRecommendedRecipes()
      }
    }
  }
  
  private var headerView: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 8) {
        Text("오늘 뭐먹지?")
          .font(.custom("Roboto", size: 20).bold())
          .lineSpacing(24)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
      }      .frame(maxWidth: .infinity)
    }
    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)
    .background(Color.white)
    .shadow(color: Color.black.opacity(0.12), radius: 6)
  }
  
  private var recommendedRecipesView: some View {
    VStack(spacing: 8) {
      Text("✩ 레시피를 골라주세요 ✩")
        .font(.custom("Roboto", size: 18).weight(.medium))
        .foregroundColor(.black)
        .padding(.bottom, 8)
      ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
          ForEach(recommendedRecipes) { recipe in
            recommendedRecipeRow(recipe: recipe)
          }
        }
        .padding(.horizontal, 12)
      }
      .frame(maxHeight: .infinity)
    }
    .padding(.horizontal, 12)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  private func recommendedRecipeRow(recipe: Recipe) -> some View {
    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
      HStack(spacing: 8) {
        VStack(spacing: 0) {
          ZStack {
            AsyncImage(url: URL(string: recipe.img_url!)) { image in
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 164, height: 164)
                .clipped()
            } placeholder: {
              Color.gray
                .frame(width: 164, height: 164)
            }
            
            VStack(spacing: 0) {
              Text(recipe.category)
                .font(.custom("Roboto", size: 12).weight(.medium))
                .foregroundColor(.black)
                .padding(4)
                .background(Color(red: 0, green: 0, blue: 0).opacity(0.05))
                .cornerRadius(6)
            }
            .offset(x: -57, y: -70)
          }
          VStack(alignment: .leading, spacing: 4) {
            Text(recipe.name)
              .font(.custom("Roboto", size: 12))
              .foregroundColor(.black)
            Text("\(recipe.time) 분 소요")
              .font(.custom("Roboto", size: 16).weight(.medium))
              .foregroundColor(.black)
          }
          .padding(8)
          .frame(maxWidth: .infinity, minHeight: 60)
        }
        .frame(maxWidth: .infinity)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .inset(by: 0.50)
            .stroke(Color(red: 0, green: 0, blue: 0).opacity(0.10), lineWidth: 0.50)
        )
      }
      .frame(maxWidth: .infinity)
    }
  }
  
  
  private func fetchRecommendedRecipes() {
    isLoading = true
    errorMessage = nil
    
    Task {
      do {
        let recipes = try await fetchRecipesFromAPI()
        recommendedRecipes = recipes
      } catch {
        errorMessage = error.localizedDescription
      }
      isLoading = false
    }
  }
  
  private func fetchRecipesFromAPI() async throws -> [Recipe] {
    //    var recipes:[Recipe] = []
    //    recipes.append(Recipe(name: "미역국", time: 15, category: "국", img_url: "https://www.foodsafetykorea.go.kr/uploadimg/20200309/20200309012227_1583727747787.JPG"))
    //    recipes.append(Recipe(name: "감자 볶음", time: 15, category: "반찬", img_url: "https://www.foodsafetykorea.go.kr/uploadimg/20200309/20200309012227_1583727747787.JPG"))
    //    recipes.append(Recipe(name: "소세지 야채볶음", time: 15, category: "반찬", img_url: "https://www.foodsafetykorea.go.kr/uploadimg/20200309/20200309012227_1583727747787.JPG"))
    let prompt = """
                  {
                    "name": "example_name",
                    "time": 15,
                    "category": "example_category"
                  }
                  
                  이 형식에 맞게 \(selectedIngredients.joined(separator: ", ")) 의 재료로 만들 수 있는 레시피들 5개 이상 10개 이하로 알려줘.
                  name에는 음식 이름을 넣어주고, time은 조리 시간, category에는 '국'이나 '반찬', '찌개' 등의 카테고리를 적어줘.
                  배열로 만들어 주는데 배열의 원소로 json으로 만들어줘.
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
      throw URLError(.badServerResponse)
    }
    
    let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    guard let choices = responseData?["choices"] as? [[String: Any]],
          let message = choices.first?["message"] as? [String: Any],
          let content = message["content"] as? String else {
      throw URLError(.cannotParseResponse)
    }
    
    // GPT-3.5-turbo의 응답 내용을 JSON으로 변환
    guard let jsonData = content.data(using: .utf8) else {
      throw URLError(.cannotParseResponse)
    }
    
    // JSON 데이터를 Recipe 배열로 디코딩
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    // 주어진 JSON 형식에 맞게 디코딩할 때 필요한 중간 구조체 생성
    struct RecipeJSON: Codable {
      let name: String
      let time: Int
      let category: String
    }
    
    // JSON 데이터를 중간 구조체로 디코딩
    let recipesJSON = try decoder.decode([RecipeJSON].self, from: jsonData)
    
    // 중간 구조체를 Recipe로 변환
    var recipes = recipesJSON.map { recipeJSON in
      Recipe(name: recipeJSON.name, time: recipeJSON.time, category: recipeJSON.category, img_url: "") // img_url은 비어있는 값으로 설정
    }
    
    
    //    for var recipe in recipes {
    //      // 데이터 가져오기
    //      let converted_name = recipe.name.replacingOccurrences(of: " ", with: "%20")
    //      let url = URL(string: "https://openapi.foodsafetykorea.go.kr/api/867ebc97b51e4dffa29f/COOKRCP01/json/1/2/RCP_NM=\(converted_name)")!
    //      let (data, _) = try await URLSession.shared.data(from: url)
    //
    //      // 응답 JSON 디코딩
    //      let decoder = JSONDecoder()
    //      let response = try decoder.decode([String: CookRcpResponse].self, from: data)
    //      print(response)
    //      // 응답에서 레시피 정보 추출
    //      if let row = response["COOKRCP01"]?.row {
    //        for recipeData in row {
    //          if let name = recipeData.RCP_NM,
    //             let imgUrlString = recipeData.ATT_FILE_NO_MAIN {
    //
    //            // 이미지 URL을 img_url에 설정한 후 Recipe 객체 생성
    //            recipe.name = name
    //            recipe.img_url = imgUrlString
    //
    //            // recommendedRecipes 배열 업데이트
    //            recipes.append(recipe)
    //          }
    //        }
    //      }
    //    }
    
    // 업데이트된 레시피 반환
    return recipes
  }
  
}

#Preview {
  SearchRecipeView(selectedIngredients: ["치킨", "브로콜리", "쌀"])
}

//struct CookRcpResponse: Codable {
//  let row: [CookRcpRow]?
//}
//
//struct CookRcpRow: Codable {
//  let RCP_NM: String?
//  let ATT_FILE_NO_MAIN: String?
//  // 필요한 다른 속성을 추가하세요
//}

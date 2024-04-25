import SwiftUI
import UIKit

/*
 Call categories stack for each subcategory
 This function will add the subcategory below the title of main category
 */
struct ExpenseCategoriesListView: View {
    @EnvironmentObject var viewModel: ViewModel
    var parentCategory: String
    var subcategories: [ExpenseCategory]
    
    var body: some View {
        Spacer()
        Text(parentCategory)
            .font(.title3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
        
            VStack {
            ForEach(subcategories.indices, id: \.self) { index in
                Button(action: {
                    // assign the selected subcategory
                    viewModel.selectedCategory = self.subcategories[index]
                    viewModel.isCategorySelection = false
                })
                {
                    HStack {
                        Image(systemName: subcategories[index].systemImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(subcategories[index].color))
                        
                        Text(subcategories[index].name)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                            .foregroundStyle(.black)
                    }
                    .foregroundColor(.primary)
                    .frame(height: 20)
                    .padding(10)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}


struct ExpenseCategoriesView: View {
    @Binding var showingCategorySelection: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                let selectedParentCategories: [String] = Array(Set(ExpenseCategories.allCategories.compactMap { $0.parentCategory }))
                ForEach(selectedParentCategories, id: \.self) { parentCategory in
                    let subcategories = ExpenseCategories.allCategories.filter { $0.parentCategory == parentCategory }
                    ExpenseCategoriesListView(parentCategory: parentCategory, subcategories: subcategories)
                        .padding(.bottom, 10)
                }
            }
            .navigationBarItems(leading: Button(action: {
                showingCategorySelection = false // Dismiss the full-screen modal
            }) {
                HStack {
                   Image(systemName: "chevron.left")
                       .aspectRatio(contentMode: .fit)
                       .foregroundColor(.primary)
                   Text("Back")
                       .font(.caption)
                       .foregroundColor(.primary)
               }
            })
        }
    }
}

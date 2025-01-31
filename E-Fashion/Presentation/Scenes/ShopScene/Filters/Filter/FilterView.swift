//
//  FilterViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//

import SwiftUI

struct FilterView: View {
    let viewModel: DefaultProductsCatalogViewModel
    
    @State private var minPrice: Double = 1
    @State private var maxPrice: Double = 500
    @State private var selectedColorId: Int? = nil
    @State private var selectedConditionId: Int? = nil
    @State private var selectedMaterialId: Int? = nil
    @State private var isMaterialPickerPresented = false
    
    var body: some View {
        ZStack {
            Color.customWhite
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                SUICustomHeaderView(title: "Filters")
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Price Range")
                                .font(.custom(CustomFonts.nutinoBlack, size: 20))
                                .padding(.bottom, 8)
                            HStack {
                                Text("$\(Int(minPrice))")
                                Spacer()
                                Text("$\(Int(maxPrice))")
                            }
                            
                            SUIPriceRangeSlider(
                                minPrice: $minPrice,
                                maxPrice: $maxPrice,
                                range: 1...500
                            )
                            .padding(.horizontal)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        
                        colorsView()
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        
                        materialsView()
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        
                        conditionsView()
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                .background(Color.customWhite)
                
                VStack {
                    buttons()
                        .padding(.vertical, 16)
                }
                .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isMaterialPickerPresented) {
            MaterialPickerView(selectedMaterialId: $selectedMaterialId)
        }
    }
    
    private func colorsView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Colors")
                .font(.custom(CustomFonts.nutinoBlack, size: 20))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                ForEach(ProductColor.allColors, id: \.self) { color in
                    ColorCircleView(
                        color: colorFromId(color.id),
                        isSelected: color.id == selectedColorId
                    )
                    .onTapGesture {
                        if selectedColorId == color.id {
                            selectedColorId = nil
                        } else {
                            selectedColorId = color.id
                        }
                    }
                }
            }
        }
    }
    
    private func materialsView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Material")
                .font(.custom(CustomFonts.nutinoBlack, size: 20))
            
            Button(action: {
                isMaterialPickerPresented = true
            }) {
                HStack {
                    Text(selectedMaterialId.flatMap { id in
                        ProductMaterial.allMaterials.first { $0.id == id }?.title
                    } ?? "Select Material")
                    .font(.custom(CustomFonts.nutinoRegular, size: 16))
                    .foregroundColor(selectedMaterialId == nil ? .gray : .black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1)
                )
            }
        }
    }
    
    private func conditionsView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Condition")
                .font(.custom(CustomFonts.nutinoBlack, size: 20))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(ProductCondition.allConditions, id: \.self) { condition in
                    ConditionButtonView(
                        title: condition.title,
                        description: condition.description,
                        isSelected: condition.id == selectedConditionId
                    )
                    .onTapGesture {
                        if selectedConditionId == condition.id {
                            selectedConditionId = nil
                        } else {
                            selectedConditionId = condition.id
                        }
                    }
                }
            }
        }
    }
    
    private func colorFromId(_ id: Int) -> Color {
        switch id {
        case 9: return .blue
        case 27: return Color(red: 0, green: 0, blue: 0.5)
        case 26: return Color(.systemBlue).opacity(0.7)
        case 1: return .black
        case 3: return .gray
        case 12: return .white
        case 15: return Color(red: 0.8, green: 0.4, blue: 1.0)
        case 16: return Color(red: 0.765, green: 0.69, blue: 0.569)
        case 23: return Color(red: 0.5, green: 0, blue: 0.13)
        case 28: return Color(red: 0, green: 0.39, blue: 0)
        case 29: return Color(red: 0.97, green: 0.85, blue: 0.37)
        case 30: return Color(red: 0.596, green: 1, blue: 0.596)
        case 8: return .yellow
        default: return .gray
        }
    }
    
    private func buttons() -> some View {
        HStack(spacing: 20) {
            Button {
                viewModel.dismissPresented()
            } label: {
                Text("Discard")
                    .font(Font.custom(CustomFonts.nutinoBold, size: 16))
                    .frame(width: 100)
                    .padding(.vertical, 12)
                    .background(.white)
                    .foregroundColor(.black)
                    .overlay(
                        Capsule()
                            .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .clipShape(Capsule())
            }
            .shadow(radius: 5)
            
            Button {
                let selectedColor = selectedColorId.flatMap { colorId in
                    ProductColor.allColors.first { $0.id == colorId }
                }.map { [$0] }
                
                let selectedMaterial = selectedMaterialId.flatMap { materialId in
                    ProductMaterial.allMaterials.first { $0.id == materialId }
                }.map { [$0] }
                
                let selectedCondition = selectedConditionId.flatMap { conditionId in
                    ProductCondition.allConditions.first { $0.id == conditionId }
                }.map { [$0] }
                
                viewModel.applyFilters(
                    minPrice: Int(minPrice),
                    maxPrice: Int(maxPrice),
                    selectedColors: selectedColor,
                    selectedMaterials: selectedMaterial,
                    selectedConditions: selectedCondition
                )
                
                viewModel.dismissPresented()
            } label: {
                Text("Apply")
                    .font(Font.custom(CustomFonts.nutinoBold, size: 16))
                    .frame(width: 100)
                    .padding(.vertical, 12)
                    .background(.accentRed)
                    .foregroundColor(.white)
                    .overlay(
                        Capsule()
                            .strokeBorder(Color.black.opacity(0.5), lineWidth: 1)
                    )
                    .clipShape(Capsule())
            }
            .shadow(radius: 5)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

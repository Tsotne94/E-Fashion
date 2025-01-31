//
//  MaterialPickerView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import SwiftUI

struct MaterialPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedMaterialId: Int?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(ProductMaterial.allMaterials, id: \.id) { material in
                    Button(action: {
                        selectedMaterialId = material.id
                        dismiss()
                    }) {
                        HStack {
                            Text(material.title)
                                .font(.custom(CustomFonts.nutinoRegular, size: 16))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            if material.id == selectedMaterialId {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentRed)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Material")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

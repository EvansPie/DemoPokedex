//
//  TagView.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import SwiftUI

struct TagView: View {
    
    let title: String
    let backgroundColor: Color?
    let textColor: Color?
    let isSelected: Bool
    let onTap: (() -> Void)?
    
    init(
        title: String,
        backgroundColor: Color? = nil, // We could also add a `selectedBackgroundColor` (or handle it externally by creating another `TagView`)
        textColor: Color? = nil, // We could also add a `selectedTextColor` (or handle it externally by creating another `TagView`)
        isSelected: Bool = false,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.isSelected = isSelected
        self.onTap = onTap
    }
    
    var body: some View {
        Text(title)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(backgroundColor ?? (isSelected ? Color.black.opacity(0.8) : Color.gray.opacity(0.2)))
            .foregroundColor(textColor ?? (isSelected ? .white : .black))
            .cornerRadius(16)
            .onTapGesture {
                onTap?()
            }
    }
}

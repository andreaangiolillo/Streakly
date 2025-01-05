import SwiftUI

struct IconSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedIcon: String
    @Binding var selectedColor: Color
    
    @State private var searchText = ""
    
    // Changed to array of tuples for consistent order
    let iconCategories: [(category: String, icons: [String])] = [
        ("Learning", [
            "book.fill",
            "books.vertical.fill",
            "text.book.closed.fill",
            "pencil",
            "highlighter",
            "newspaper.fill",
            "keyboard.fill",
            "lightbulb.fill",
            "graduationcap.fill"
        ]),
        ("Lifestyle", [
            "house.fill",
            "cart.fill",
            "dollarsign.circle.fill",
            "gift.fill",
            "person.2.fill",
            "phone.fill",
            "mail.fill",
            "music.note",
            "theatermasks.fill"
        ]),
        ("Fitness", [
            "figure.run",
            "figure.walk",
            "figure.hiking",
            "figure.dance",
            "figure.strengthtraining.functional",
            "dumbbell.fill",
            "figure.mind.and.body",
            "figure.boxing",
            "figure.basketball"
        ]),
        ("Health", [
            "heart.fill",
            "pills.fill",
            "cross.fill",
            "bed.double.fill",
            "lungs.fill",
            "brain.head.profile",
            "leaf.fill",
            "allergens",
            "wineglass.fill"
        ]),
        ("Productivity", [
            "checklist",
            "calendar",
            "clock.fill",
            "briefcase.fill",
            "folder.fill",
            "chart.bar.fill",
            "list.bullet",
            "target",
            "flag.fill"
        ])
    ]
    
    let colors: [(name: String, color: Color)] = [
        ("Blue", .blue),
        ("Purple", .purple),
        ("Pink", Color(red: 255/255, green: 105/255, blue: 180/255)),
        ("Red", Color(red: 255/255, green: 0/255, blue: 0/255)),
        ("Orange", .orange),
        ("Yellow", .yellow),
        ("Green", .green)
    ]
    
    var filteredCategories: [(String, [String])] {
        if searchText.isEmpty {
            return iconCategories
        } else {
            return iconCategories.compactMap { category, icons in
                let filteredIcons = icons.filter { $0.localizedCaseInsensitiveContains(searchText) }
                return filteredIcons.isEmpty ? nil : (category, filteredIcons)
            }
        }
    }
    
    // Rest of the view remains the same...
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Color Selection
                    VStack(alignment: .leading) {
                        Text("Select Color")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(colors, id: \.name) { colorOption in
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .fill(colorOption.color)
                                                .frame(width: 44, height: 44)
                                            
                                            if selectedColor == colorOption.color {
                                                Circle()
                                                    .strokeBorder(colorOption.color, lineWidth: 2)
                                                    .frame(width: 52, height: 52)
                                                    .background(
                                                        Circle()
                                                            .fill(Color(.systemBackground))
                                                            .frame(width: 50, height: 50)
                                                    )
                                            }
                                        }
                                        Text(colorOption.name)
                                            .font(.caption)
                                    }
                                    .onTapGesture {
                                        selectedColor = colorOption.color
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search icons", text: $searchText)
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Icon Categories
                    ForEach(filteredCategories, id: \.0) { category, icons in
                        VStack(alignment: .leading) {
                            Text(category)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVGrid(
                                columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 7),
                                spacing: 15
                            ) {
                                ForEach(icons, id: \.self) { icon in
                                    Button(action: {
                                        selectedIcon = icon
                                        dismiss()
                                    }) {
                                        Image(systemName: icon)
                                            .font(.title2)
                                            .frame(width: 44, height: 44)
                                            .foregroundColor(selectedColor)
                                            .background(
                                                Circle()
                                                    .fill(Color(.systemGray6))
                                            )
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedIcon == icon ? selectedColor : Color.clear, lineWidth: 2)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Choose Icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

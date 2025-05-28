//
//  EditGlassView.swift
//  GlugGlug
//
//  Created by Nur Fajar Sayyidul Ayyam on 07/04/25.
//

import SwiftUI

struct EditGlassView: View {
    
    @Binding var selectedIndex: Int
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var newAmount: String = ""
    @State private var newIcon: String = "cup.and.saucer.fill"
    
    @State private var showSnackbar = false
    @State private var snackbarMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add New Glass Option")) {
                    TextField("Amount (ml)", text: $newAmount)
                        .keyboardType(.numberPad)
                    Button("Add") {
                        if let amount = Int(newAmount) {
                            if homeViewModel.glassOptions.contains(where: { $0.amount == amount }) {
                                snackbarMessage = "Amount already exists!"
                                showSnackbar = true
                                return
                            } else if amount <= 100 {
                                snackbarMessage = "Amount must be greater than 100!"
                                showSnackbar = true
                                return
                            } else if amount > 2500 {
                                snackbarMessage = "Amount must be less than 2500!"
                                showSnackbar = true
                                return
                            }
                            
                            if (amount > 1700) {
                                newIcon = "takeoutbag.and.cup.and.straw.fill"
                            } else if (amount > 900) {
                                newIcon = "mug.fill"
                            } else {
                                newIcon = "cup.and.saucer.fill"
                            }
                            
                            homeViewModel.addGlass(icon: newIcon, amount: amount)
                            snackbarMessage = "Glass added!"
                            showSnackbar = true
                            newAmount = ""
                            newIcon = "mug.fill"
                        }
                    }
                }
                
                Section(header: Text("Existing Glass Options")) {
                    ForEach(homeViewModel.glassOptions.indices, id: \.self) { i in
                        HStack {
                            Image(systemName: homeViewModel.glassOptions[i].icon)
                            Text("\(homeViewModel.glassOptions[i].amount) ml")
                            Spacer()
                            if i > 0 {
                                Button(role: .destructive) {
                                    selectedIndex = selectedIndex == 0 ? 0 : selectedIndex - 1
                                    homeViewModel.removeGlass(at: i)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Glass Options")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .overlay(
                Group {
                    if showSnackbar {
                        VStack {
                            Spacer()
                            Text(snackbarMessage)
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.bottom, 40)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .onAppear {
                                    // Hide after 2 seconds
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showSnackbar = false
                                        }
                                    }
                                }
                        }
                    }
                }
            )
            .animation(.easeInOut, value: showSnackbar)
        }
    }
}

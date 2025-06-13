//
//  ContentView.swift
//  jungbo-silgi-2025
//
//  Created by DOMINIQUE on 6/13/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isHigh = false
    @State private var isMedium = false
    @State private var isLow = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                colors: [.blue.opacity(0.2), .purple.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Text("중요도 선택")
                    .font(.largeTitle.bold())

                VStack(alignment: .leading, spacing: 20) {
                    Toggle("상", isOn: $isHigh)
                        .toggleStyle(.checkbox)

                    Toggle("중", isOn: $isMedium)
                        .toggleStyle(.checkbox)

                    Toggle("하", isOn: $isLow)
                        .toggleStyle(.checkbox)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.thinMaterial)
                )

                Button(action: {
                    // 시작 동작 처리
                }) {
                    Text("시작")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding()
            .toolbar {
                NavigationLink("문제 등록") {
                    ExamQuestionRegistrationView()
                }
            }
        }
    }
}
}

#Preview {
    ContentView()
}

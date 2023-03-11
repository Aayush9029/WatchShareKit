//
//  ShareKeysView.swift
//  WatchShareKit
//
//  Created by Aayush Pokharel on 2023-03-10.
//

import SwiftUI

#if os(iOS)
public struct ShareKeys: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var phoneSender: PhoneSender

    public let data: Data?
    public let message: [String: Any]?

    public init(data: Data? = nil, message: [String: Any]? = nil) {
        self.data = data
        self.message = message
    }

    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary, .quaternary)
                        .font(.title)
                }
                .buttonStyle(.plain)
            }

            Text(phoneSender.sheetData.title)
                .font(.title)
                .foregroundStyle(.primary)

            Image(systemName: "key.fill")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 100)
                .foregroundStyle(.tertiary)
                .padding()

            Text(phoneSender.sheetData.detail)
                .multilineTextAlignment(.center)

            Spacer()
            Button {
                if let message {
                    phoneSender.sendString(message)
                    dismiss()
                }
                if let data {
                    phoneSender.sendData(data)
                }
            } label: {
                HStack {
                    Spacer()
                    Text(phoneSender.sheetData.button)
                    Spacer()
                }
                .padding()
                .background(.gray.opacity(0.25))
                .cornerRadius(16)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .presentationDetents([.medium])
    }
}

struct ShareKeysView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Light Mode")
                .sheet(isPresented: .constant(true)) {
                    Group {
                        if #available(iOS 16.4, *) {
                            ShareKeys()
                                .presentationCornerRadius(38)
                        } else {
                            ShareKeys()
                        }
                    }
                    .environmentObject(PhoneSender())
                    .preferredColorScheme(.light)
                }
        }

        VStack {
            Text("Dark Mode")
                .sheet(isPresented: .constant(true)) {
                    Group {
                        if #available(iOS 16.4, *) {
                            ShareKeys()
                                .presentationCornerRadius(38)
                        } else {
                            ShareKeys()
                        }
                    }
                    .environmentObject(PhoneSender())
                    .preferredColorScheme(.dark)
                }
        }
        .preferredColorScheme(.dark)
    }
}
#endif

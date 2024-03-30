//
//  TodayController.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 30/03/2024.
//
import Foundation

class TodayController: ObservableObject {
    @Published var dafYomiData: DafYomiData? = nil
    @Published var heText: [[String]] = [[]]

    func fetchDafYomi(completion: (() -> Void)? = nil) {
        Task {
            do {
                let data = try await SefariaClient.fetchTodaysDafYomi()
                DispatchQueue.main.async {
                    self.dafYomiData = data
                    completion?()
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func fetchText() {
        if dafYomiData == nil {
            return
        }
        Task {
            do {
                let text = try await SefariaClient.fetchText(ref: dafYomiData!.ref)
                DispatchQueue.main.async {
                    self.heText = text
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

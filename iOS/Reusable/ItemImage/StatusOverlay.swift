//
//  ProgressOverlay.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 04.10.23.
//

import SwiftUI
import SwiftData
import SPBase
import SPOffline
import SPOfflineExtended

struct StatusOverlay: View {
    let item: Item
    let entity: OfflineProgress
    let offlineTracker: ItemOfflineTracker?
    
    @MainActor
    init(item: PlayableItem) {
        self.item = item
        
        entity = OfflineManager.shared.requireProgressEntity(item: item)
        offlineTracker = item.offlineTracker
    }
    
    @State var progress: Double?
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width / 3
            
            HStack(alignment: .top) {
                Spacer()
                if entity.progress > 0 {
                    Triangle()
                        .frame(width: size, height: size)
                        .foregroundStyle(offlineTracker?.status == .downloaded ? Color.purple : Color.accentColor)
                        .reverseMask(alignment: .topTrailing) {
                            Group {
                                if entity.progress >= 1 {
                                    Image(systemName: "checkmark")
                                        .font(.caption)
                                } else {
                                    ZStack {
                                        Circle()
                                            .trim(from: CGFloat(entity.progress), to: 360 - CGFloat(entity.progress))
                                            .stroke(Color.black.opacity(0.4), lineWidth: 3)
                                        Circle()
                                            .trim(from: 0, to: CGFloat(entity.progress))
                                            .stroke(Color.black.opacity(0.85), lineWidth: 3)
                                    }
                                    .rotationEffect(.degrees(-90))
                                }
                            }
                            .frame(width: size / 3, height: size / 3)
                            .padding(size / 7)
                        }
                } else {
                    if offlineTracker?.status == .downloaded {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.ultraThickMaterial)
                            .padding(4)
                    }
                }
            }
        }
    }
}

// MARK: Progress image

struct ItemStatusImage: View {
    let item: PlayableItem
    
    var body: some View {
        ItemImage(image: item.image)
            .overlay {
                StatusOverlay(item: item)
            }
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

#Preview {
    ItemStatusImage(item: Audiobook.fixture)
}

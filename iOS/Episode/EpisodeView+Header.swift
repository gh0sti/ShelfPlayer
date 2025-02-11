//
//  EpisodeView+Header.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 08.10.23.
//

import SwiftUI
import SPBase

extension EpisodeView {
    struct Header: View {
        let episode: Episode
        var imageColors: Item.ImageColors
        
        @Binding var navigationBarVisible: Bool
        
        var body: some View {
            ZStack {
                FullscreenBackground(threshold: -300, backgroundColor: imageColors.background.opacity(0.9), navigationBarVisible: $navigationBarVisible)
                
                VStack {
                    ItemImage(image: episode.image)
                        .frame(width: 150)
                    
                    HStack(spacing: 0) {
                        if let formattedReleaseDate = episode.formattedReleaseDate {
                            Text(formattedReleaseDate)
                            Text(verbatim: " • ")
                        }
                        
                        Text(episode.duration.timeLeft(spaceConstrained: false, includeText: false))
                    }
                    .font(.caption.smallCaps())
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 5)
                    
                    VStack(spacing: 7) {
                        Text(episode.name)
                            .font(.title3)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        NavigationLink(destination: PodcastLoadView(podcastId: episode.podcastId)) {
                            HStack {
                                Text(episode.podcastName)
                                Image(systemName: "chevron.right.circle")
                            }
                            .lineLimit(1)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    PlayButton(item: episode)
                        .padding()
                        .padding(.bottom, 10)
                }
                .padding(.top, 100)
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity)
                .background {
                    LinearGradient(colors: [imageColors.background.opacity(0.9), .secondary.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                }
            }
        }
    }
}

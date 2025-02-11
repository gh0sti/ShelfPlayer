//
//  EpisodeContextMenuModifier.swift
//  iOS
//
//  Created by Rasmus Krämer on 22.11.23.
//

import SwiftUI
import SPBase
import SPOffline
import SPOfflineExtended

struct EpisodeContextMenuModifier: ViewModifier {
    let episode: Episode
    let offlineTracker: ItemOfflineTracker
    
    init(episode: Episode) {
        self.episode = episode
        offlineTracker = episode.offlineTracker
    }
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                NavigationLink(destination: EpisodeView(episode: episode)) {
                    Label("episode.view", systemImage: "waveform")
                }
                NavigationLink(destination: PodcastLoadView(podcastId: episode.podcastId)) {
                    Label("podcast.view", systemImage: "tray.full")
                }
                
                Divider()
                
                ProgressButton(item: episode)
                
                
            } preview: {
                VStack {
                    HStack {
                        ItemImage(image: episode.image)
                            .frame(height: 75)
                        
                        VStack(alignment: .leading) {
                            Group {
                                let durationText = Text(episode.duration.timeLeft(spaceConstrained: false, includeText: false))
                                
                                if let formattedReleaseDate = episode.formattedReleaseDate {
                                    Text(formattedReleaseDate)
                                    + Text(verbatim: " • ")
                                    + durationText
                                } else {
                                    durationText
                                }
                            }
                            .font(.caption.smallCaps())
                            .foregroundStyle(.secondary)
                            
                            Text(episode.name)
                                .font(.headline)
                            
                            Text(episode.podcastName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(episode.descriptionText ?? "description.unavailable")
                            .lineLimit(5)
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                }
                .padding(20)
                .frame(width: 400)
            }
    }
}

#Preview {
    Text(":)")
        .modifier(EpisodeContextMenuModifier(episode: Episode.fixture))
}

//
//  SearchView.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 14.10.23.
//

import SwiftUI
import SPBase

struct SearchView: View {
    @Environment(\.libraryId) var libraryId
    
    @State var query = ""
    @State var task: Task<(), Error>? = nil
    
    @State var audiobooks = [Audiobook]()
    @State var podcasts = [Podcast]()
    @State var authors = [Author]()
    @State var series = [Series]()
    
    @State var loading = false
    
    var body: some View {
        NavigationStack {
            Group {
                if audiobooks.isEmpty && podcasts.isEmpty && series.isEmpty && authors.isEmpty {
                    if loading {
                        LoadingView()
                    } else {
                        ContentUnavailableView("search.empty.title", systemImage: "magnifyingglass", description: Text("search.empty.description"))
                    }
                } else {
                    List {
                        if !audiobooks.isEmpty {
                            Section("section.audiobooks") {
                                AudiobookList(audiobooks: audiobooks)
                            }
                        }
                        if !podcasts.isEmpty {
                            Section("section.podcasts") {
                                PodcastList(podcasts: podcasts)
                            }
                        }
                        
                        if !series.isEmpty {
                            Section("section.series") {
                                SeriesList(series: series)
                            }
                        }
                        
                        if !authors.isEmpty {
                            Section("section.authors") {
                                
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("title.search")
            .searchable(text: $query)
            .modifier(NowPlayingBarSafeAreaModifier())
            .modifier(AccountSheetToolbarModifier())
            .onChange(of: query) {
                task?.cancel()
                task = Task.detached {
                    loading = true
                    (audiobooks, podcasts, authors, series) = try await AudiobookshelfClient.shared.getItems(query: query, libraryId: libraryId)
                    loading = false
                }
            }
        }
        .modifier(NowPlayingBarModifier())
        .tabItem {
            Label("tab.search", systemImage: "magnifyingglass")
        }
    }
}

#Preview {
    SearchView()
        .environment(\.libraryId, "4c5831b3-13e1-43e8-a1db-5a4e48929321")
}


#Preview {
    SearchView()
        .environment(\.libraryId, "368e36e5-22b2-4d74-8f17-c50fe6299adf")
}

import SwiftUI
import RealityKit
import RealityKitContent
import AVKit

struct Item: Identifiable {
    let id: Int
    let name: String
}

struct ContentView: View {
    let array = [
        Item(id: 1, name: "ローカル3DModel"),
        Item(id: 2, name: "リモート3dModel"),
        Item(id: 3, name: "Item 3")
    ]
    
    enum SampleItem: String, CaseIterable {
        case local3dModel
        case remote3dModel
        case hlsVideo
        
        var title: String {
            switch self {
            case .local3dModel: return "ローカル3DModel"
            case .remote3dModel: return "リモート3dModel"
            case .hlsVideo: return "HLS動画"
            }
        }
        
        var discription: String {
            switch self {
            case .local3dModel: return "ローカル3DModelを表示"
            case .remote3dModel: return "リモート3dModelを表示"
            case .hlsVideo: return "HLS動画を再生できる"
            }
        }
    }
    
    private let sampleItems: [SampleItem] = SampleItem.allCases
    
    var body: some View {
        NavigationSplitView {
            List(SampleItem.allCases, id: \.self) { item in
                switch item {
                case .hlsVideo:
                    NavigationLink(destination: VideoPlayerScreen()) {
                        VStack {
                            Text(item.title)
                        }
                    }
                case .local3dModel:
                    NavigationLink(
                        destination: Local3dModelScreen()
                    ) {
                        VStack {
                            Text(item.title)
                        }
                    }
                case .remote3dModel:
                    NavigationLink(
                        destination: Remote3dModelScreen()
                    ) {
                        VStack {
                            Text(item.title)
                        }
                    }
                }
            }
            .navigationTitle("Sidebar")
        } detail: {
            DetailView(item: array[0])
        }

    }
}

struct Local3dModelScreen: View {
    var body: some View {
        VStack {
            Text("ローカルにおいてる3Dモデルの表示")
            Model3D(
                named: "Scene",
                bundle: realityKitContentBundle
            )
            .padding(.bottom, 50)
        }
    }
}

struct Remote3dModelScreen: View {
    private let url = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/teapot/teapot.usdz")!
    
    var body: some View {
        VStack {
            Text("サーバー上の3Dモデルの表示")
            Model3D(url: url) { model in
                model
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            } placeholder: {
                ProgressView()
            }
        }
        .padding()
    }
}

struct VideoPlayerScreen: View {
    private let avplayer = AVPlayer(url: URL(string: "http://playgrounds-cdn.apple.com/assets/beach/index.m3u8")!)
    
    
    var body: some View {
        VideoPlayer(
            player: avplayer,
            videoOverlay: {
            Text("再生")
        })
        .onAppear() {
            avplayer.play()
        }
    }
}


struct DetailView: View {
    let item: Item
    @State var showingFullScreenCover = false

    var body: some View {
        VStack {
            Model3D(
                named: "Scene",
                bundle: realityKitContentBundle
            )
            .padding(.bottom, 50)

            
            Text("Hello, world!")
            
            Button(action: {
                showingFullScreenCover = true
            }) {
                Text("fullScreenCoverを表示")
            }
            .fullScreenCover(
                isPresented: $showingFullScreenCover,
                content: {
                    PopView()
            })
        }
        .navigationTitle(item.name)
        .padding()
    }
}

struct PopView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Button(action: {
                dismiss()
            }) {
                Text("閉じる")
            }
        }
        .navigationTitle("fullScreenCover表示中")
    }
}


#Preview {
    ContentView()
}

import SwiftUI

// 방금 iOS 진입점 — 비대면 월세 플랫폼. Bundle: com.banggeum.app
// v1 은 순수 SwiftUI mock (MockStore). 통합 시 Supabase 연결.
@main
struct BanggeumApp: App {
    @StateObject private var store = MockStore.shared

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .tint(BG.brand)
                .preferredColorScheme(.light)
        }
    }
}

// 네비게이션 목적지
enum Route: Hashable {
    case room(String)
    case host
    case hostNew
}

extension View {
    /// 각 탭 NavigationStack 에 공통 목적지 등록
    func banggeumDestinations() -> some View {
        navigationDestination(for: Route.self) { route in
            switch route {
            case .room(let id): RoomDetailView(roomId: id)
            case .host: HostView()
            case .hostNew: HostNewView()
            }
        }
    }
}

struct RootTabView: View {
    @State private var showLogin = true

    var body: some View {
        TabView {
            NavigationStack { ExploreView().banggeumDestinations() }
                .tabItem { Label("탐색", systemImage: "magnifyingglass") }
            NavigationStack { MapView().banggeumDestinations() }
                .tabItem { Label("지도", systemImage: "map") }
            NavigationStack { SavedView().banggeumDestinations() }
                .tabItem { Label("찜", systemImage: "heart") }
            NavigationStack { ReservationsView().banggeumDestinations() }
                .tabItem { Label("예약", systemImage: "calendar.badge.checkmark") }
            NavigationStack { ChatView().banggeumDestinations() }
                .tabItem { Label("채팅", systemImage: "bubble.left.and.bubble.right") }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView(onContinue: { showLogin = false })
        }
    }
}

import SwiftUI

struct SavedView: View {
    @EnvironmentObject var store: MockStore
    private var rooms: [Room] { store.favoriteRooms() }

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "찜한 방", subtitle: "\(rooms.count)개의 방을 저장했어요")
            if rooms.isEmpty {
                EmptyStateView(system: "heart", text: "아직 찜한 방이 없어요")
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(rooms) { RoomCard(room: $0) }
                    }
                    .padding(20)
                }
            }
        }
        .background(BG.sand)
        .navigationBarHidden(true)
    }
}

struct EmptyStateView: View {
    let system: String
    let text: String
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: system).font(.system(size: 26)).foregroundStyle(BG.mutedFg)
                .frame(width: 56, height: 56).background(BG.muted, in: Circle())
            Text(text).font(.system(size: 14)).foregroundStyle(BG.mutedFg)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

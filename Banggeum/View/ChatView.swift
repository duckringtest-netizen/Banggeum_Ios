import SwiftUI

struct ChatView: View {
    @EnvironmentObject var store: MockStore

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "채팅", subtitle: "전화 대신 채팅으로 — 답변은 AI가 거들어요")
            if store.chats.isEmpty {
                EmptyStateView(system: "bubble.left.and.bubble.right", text: "아직 대화가 없어요")
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(store.chats.enumerated()), id: \.element.id) { idx, c in
                            if idx > 0 { Divider().background(BG.border).padding(.leading, 80) }
                            row(c)
                        }
                    }
                    .cardStyle()
                    .padding(20)
                }
            }
        }
        .background(BG.sand)
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func row(_ c: Chat) -> some View {
        if let room = store.room(c.roomId) {
            let host = store.host(room)
            let isAuto = (c.lastMessage ?? "").hasPrefix("[자동응답]")
            HStack(spacing: 12) {
                RoomImage(url: room.photos[0]).frame(width: 52, height: 52).clipShape(RoundedRectangle(cornerRadius: 14))
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(host.name) 집주인").font(.system(size: 15, weight: .bold))
                    Text("\(room.region) · \(room.title)").font(.system(size: 13)).foregroundStyle(BG.mutedFg).lineLimit(1)
                    HStack(spacing: 4) {
                        if isAuto { Image(systemName: "sparkles").font(.system(size: 12)).foregroundStyle(BG.brand) }
                        Text((c.lastMessage ?? "").replacingOccurrences(of: "[자동응답] ", with: ""))
                            .font(.system(size: 13)).foregroundStyle(BG.ink.opacity(0.8)).lineLimit(1)
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(16)
        }
    }
}

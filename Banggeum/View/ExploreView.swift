import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var store: MockStore
    @State private var region = "전체"

    private var rooms: [Room] { store.listRooms(region: region) }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // 헤더
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("전화 없이 · 눈치 없이")
                            .font(.system(size: 13, weight: .medium)).foregroundStyle(BG.brand)
                        Text("오늘 방금 나온 방").font(.system(size: 24, weight: .heavy))
                    }
                    Spacer()
                    NavigationLink(value: Route.host) {
                        Image(systemName: "building.2")
                            .font(.system(size: 18)).foregroundStyle(BG.ink)
                            .frame(width: 40, height: 40).background(BG.card, in: Circle())
                            .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20).padding(.top, 8)

                // 지역 필터
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(["전체"] + REGIONS, id: \.self) { r in
                            RegionChip(label: r, active: region == r) { region = r }
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Text("\(region == "전체" ? "추천" : region) · 방 \(rooms.count)개")
                    .font(.system(size: 13)).foregroundStyle(BG.mutedFg)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)

                ForEach(rooms) { room in
                    RoomCard(room: room).padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 16)
        }
        .background(BG.sand)
        .navigationBarHidden(true)
    }
}

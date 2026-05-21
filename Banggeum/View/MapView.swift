import SwiftUI

// 기획서: "복잡한 지도" 지양 → 가격 핀 + 리스트의 간결한 탐색.
struct MapView: View {
    @EnvironmentObject var store: MockStore
    @State private var region = "전체"
    private var rooms: [Room] { store.listRooms(region: region) }

    var body: some View {
        VStack(spacing: 0) {
            // 지도 영역 (더미 — 통합 시 지도 SDK)
            ZStack {
                BG.brandSoft
                ForEach(Array(rooms.prefix(4).enumerated()), id: \.element.id) { i, r in
                    NavigationLink(value: Route.room(r.id)) {
                        Text("월 \(formatMoney(r.monthlyRent))")
                            .font(.system(size: 13, weight: .bold)).foregroundStyle(BG.brandFg)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(BG.brand, in: Capsule())
                    }
                    .buttonStyle(.plain)
                    .offset(x: CGFloat(-90 + i * 60), y: CGFloat(-50 + i * 36))
                }
                Text("지도는 통합 단계에서 연결돼요")
                    .font(.system(size: 12)).foregroundStyle(BG.mutedFg)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(BG.card.opacity(0.92), in: Capsule())
                    .frame(maxHeight: .infinity, alignment: .bottom).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).frame(height: 280).clipped()

            // 지역 필터
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["전체"] + REGIONS, id: \.self) { r in
                        RegionChip(label: r, active: region == r) { region = r }
                    }
                }.padding(.horizontal, 20)
            }
            .padding(.vertical, 12)

            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(rooms) { r in
                        NavigationLink(value: Route.room(r.id)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(r.title).font(.system(size: 15, weight: .bold)).foregroundStyle(BG.ink).lineLimit(1)
                                    HStack(spacing: 4) {
                                        Image(systemName: "mappin.and.ellipse").font(.system(size: 12))
                                        Text("\(r.region) · \(r.address)").font(.system(size: 12)).lineLimit(1)
                                    }.foregroundStyle(BG.mutedFg)
                                }
                                Spacer()
                                Text("월 \(formatMoney(r.monthlyRent))").font(.system(size: 14, weight: .bold)).foregroundStyle(BG.ink)
                            }
                            .padding(14).cardStyle(radius: 14)
                        }.buttonStyle(.plain)
                    }
                }.padding(.horizontal, 20)
            }
        }
        .background(BG.sand)
        .navigationBarHidden(true)
    }
}

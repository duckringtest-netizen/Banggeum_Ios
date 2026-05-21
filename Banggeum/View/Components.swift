import SwiftUI

// MARK: - 룸 사진 (AsyncImage + 모래색 placeholder)
struct RoomImage: View {
    let url: String
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .success(let image): image.resizable().scaledToFill()
            default: BG.muted
            }
        }
    }
}

// MARK: - 생활 배지
struct LifeBadgeView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(BG.ink.opacity(0.8))
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(BG.muted, in: Capsule())
    }
}

// MARK: - 신뢰 점수 + 인증 칩
struct TrustRowView: View {
    let score: Int
    let verified: [String]
    private let labels = ["identity": "본인인증", "school_email": "학교인증", "hospital_email": "병원인증",
                          "job": "직장인증", "account": "계좌인증", "ownership": "소유주인증"]
    var body: some View {
        HStack(spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.seal.fill").font(.system(size: 12))
                Text("신뢰 \(score)").font(.system(size: 13, weight: .semibold))
            }
            .foregroundStyle(BG.good)
            .padding(.horizontal, 10).padding(.vertical, 4)
            .background(BG.good.opacity(0.1), in: Capsule())

            ForEach(verified.prefix(2), id: \.self) { v in
                Text(labels[v] ?? v)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(BG.mutedFg)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(BG.muted, in: Capsule())
            }
        }
    }
}

// MARK: - 룸 카드 (탐색/찜 공용)
struct RoomCard: View {
    @EnvironmentObject var store: MockStore
    let room: Room

    var body: some View {
        NavigationLink(value: Route.room(room.id)) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    RoomImage(url: room.photos[0])
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipped()

                    Button {
                        store.toggleFavorite(room.id)
                    } label: {
                        Image(systemName: store.isFavorite(room.id) ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundStyle(store.isFavorite(room.id) ? BG.brand : .white)
                            .frame(width: 36, height: 36)
                            .background(.black.opacity(0.25), in: Circle())
                    }
                    .buttonStyle(.plain)
                    .padding(12)

                    if room.faq.shortTermOk {
                        Text("단기 가능")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(BG.ink)
                            .padding(.horizontal, 10).padding(.vertical, 4)
                            .background(BG.card.opacity(0.92), in: Capsule())
                            .padding(12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse").font(.system(size: 12))
                        Text("\(room.region) · \(room.roomType.label) · \(room.floor)층")
                    }
                    .font(.system(size: 13)).foregroundStyle(BG.mutedFg)

                    Text(room.title).font(.system(size: 16, weight: .bold)).foregroundStyle(BG.ink).lineLimit(1)
                    Text(priceLine(room)).font(.system(size: 15, weight: .semibold)).foregroundStyle(BG.ink)

                    HStack(spacing: 6) {
                        ForEach(room.badges.prefix(3), id: \.self) { LifeBadgeView(text: $0) }
                    }
                    .padding(.top, 2)
                }
                .padding(16)
            }
            .cardStyle()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 지역 필터 칩
struct RegionChip: View {
    let label: String
    let active: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(active ? BG.sand : BG.ink)
                .padding(.horizontal, 16).padding(.vertical, 9)
                .background(active ? BG.ink : BG.card, in: Capsule())
                .overlay(Capsule().stroke(BG.border, lineWidth: active ? 0 : 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 화면 헤더
struct ScreenHeader: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.system(size: 24, weight: .heavy))
            Text(subtitle).font(.system(size: 13)).foregroundStyle(BG.mutedFg)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20).padding(.top, 8).padding(.bottom, 4)
    }
}

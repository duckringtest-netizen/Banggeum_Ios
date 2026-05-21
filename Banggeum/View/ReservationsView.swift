import SwiftUI

struct ReservationsView: View {
    @EnvironmentObject var store: MockStore
    private var items: [Reservation] { store.reservations.filter { $0.tenantId == "u_me" } }

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "내 방문 예약", subtitle: "전화 없이 예약한 방문 일정")
            if items.isEmpty {
                EmptyStateView(system: "calendar", text: "예약한 방문이 없어요")
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(items) { rsv in
                            if let room = store.room(rsv.roomId) {
                                NavigationLink(value: Route.room(room.id)) {
                                    card(rsv, room)
                                }.buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .background(BG.sand)
        .navigationBarHidden(true)
    }

    private func card(_ rsv: Reservation, _ room: Room) -> some View {
        let host = store.host(room)
        return HStack(spacing: 14) {
            RoomImage(url: room.photos[0]).frame(width: 84, height: 84).clipShape(RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    statusChip(rsv.status)
                    Spacer()
                    Text(slotLabel(day: rsv.slotDay, hour: rsv.slotHour)).font(.system(size: 13, weight: .semibold))
                }
                Text(room.title).font(.system(size: 15, weight: .bold)).foregroundStyle(BG.ink).lineLimit(1)
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse").font(.system(size: 12))
                    Text("\(room.region) · \(host.name) 집주인").font(.system(size: 12))
                }.foregroundStyle(BG.mutedFg)
                if rsv.unmanned, let code = rsv.doorCode {
                    HStack(spacing: 4) {
                        Image(systemName: "key").font(.system(size: 12))
                        Text("무인 방문 · 도어락 \(code)").font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(BG.brand)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(BG.brandSoft, in: RoundedRectangle(cornerRadius: 8))
                }
            }
            Spacer(minLength: 0)
        }
        .padding(14).cardStyle()
    }

    private func statusChip(_ s: ReservationStatus) -> some View {
        let (bg, fg): (Color, Color) = {
            switch s {
            case .requested: return (BG.warn.opacity(0.15), BG.warn)
            case .approved: return (BG.good.opacity(0.15), BG.good)
            case .no_show: return (BG.brandSoft, BG.brand)
            default: return (BG.muted, BG.mutedFg)
            }
        }()
        return Text(s.label).font(.system(size: 12, weight: .semibold)).foregroundStyle(fg)
            .padding(.horizontal, 10).padding(.vertical, 3).background(bg, in: Capsule())
    }
}

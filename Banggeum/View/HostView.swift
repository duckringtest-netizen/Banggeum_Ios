import SwiftUI

struct HostView: View {
    @EnvironmentObject var store: MockStore

    private var myRooms: [Room] { store.rooms.filter { $0.hostId == "u_host2" } }
    private var pending: [Reservation] { store.reservations.filter { $0.status == .requested } }
    private var approvedCount: Int { store.reservations.filter { $0.status == .approved }.count }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 통계
                HStack(spacing: 12) {
                    stat("house.fill", "등록 매물", myRooms.count)
                    stat("tray.fill", "대기 예약", pending.count)
                    stat("calendar.badge.checkmark", "이번주 방문", approvedCount)
                }

                // 방문 예약 요청
                Text("방문 예약 요청").font(.system(size: 16, weight: .bold))
                if pending.isEmpty {
                    Text("대기 중인 요청이 없어요")
                        .font(.system(size: 14)).foregroundStyle(BG.mutedFg)
                        .frame(maxWidth: .infinity).padding(.vertical, 32)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(BG.border, lineWidth: 1))
                } else {
                    ForEach(pending) { rsv in
                        if let room = store.room(rsv.roomId) { requestCard(rsv, room) }
                    }
                }

                // 내 매물
                HStack {
                    Text("내 매물").font(.system(size: 16, weight: .bold))
                    Spacer()
                    NavigationLink(value: Route.hostNew) {
                        Text("+ 매물 등록").font(.system(size: 13, weight: .semibold)).foregroundStyle(BG.brand)
                    }.buttonStyle(.plain)
                }
                ForEach(myRooms) { r in
                    HStack(spacing: 12) {
                        RoomImage(url: r.photos[0]).frame(width: 52, height: 52).clipShape(RoundedRectangle(cornerRadius: 14))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(r.title).font(.system(size: 14, weight: .bold)).lineLimit(1)
                            Text(priceLine(r)).font(.system(size: 13)).foregroundStyle(BG.mutedFg)
                        }
                        Spacer(minLength: 0)
                        Text("공개중").font(.system(size: 12, weight: .semibold)).foregroundStyle(BG.good)
                            .padding(.horizontal, 10).padding(.vertical, 4).background(BG.good.opacity(0.15), in: Capsule())
                    }
                    .padding(12).cardStyle(radius: 14)
                }
            }
            .padding(20)
        }
        .background(BG.sand)
        .navigationTitle("집주인 홈")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: Route.hostNew) { Image(systemName: "plus") }
            }
        }
    }

    private func stat(_ icon: String, _ label: String, _ value: Int) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 20)).foregroundStyle(BG.brand)
            Text("\(value)").font(.system(size: 20, weight: .heavy))
            Text(label).font(.system(size: 12)).foregroundStyle(BG.mutedFg)
        }
        .frame(maxWidth: .infinity).padding(16).cardStyle()
    }

    private func requestCard(_ rsv: Reservation, _ room: Room) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                RoomImage(url: room.photos[0]).frame(width: 56, height: 56).clipShape(RoundedRectangle(cornerRadius: 14))
                VStack(alignment: .leading, spacing: 2) {
                    Text(room.title).font(.system(size: 15, weight: .bold)).lineLimit(1)
                    Text("희망 방문 · \(slotLabel(day: rsv.slotDay, hour: rsv.slotHour))").font(.system(size: 13)).foregroundStyle(BG.mutedFg)
                    if let memo = rsv.memo { Text("“\(memo)”").font(.system(size: 12)).foregroundStyle(BG.ink.opacity(0.7)) }
                }
                Spacer(minLength: 0)
            }
            HStack(spacing: 8) {
                Button { store.setReservationStatus(rsv.id, .rejected) } label: {
                    HStack(spacing: 4) { Image(systemName: "xmark"); Text("거절") }
                        .font(.system(size: 14, weight: .semibold)).foregroundStyle(BG.ink)
                        .frame(maxWidth: .infinity).frame(height: 44)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(BG.border, lineWidth: 1))
                }.buttonStyle(.plain)
                Button { store.setReservationStatus(rsv.id, .approved) } label: {
                    HStack(spacing: 4) { Image(systemName: "checkmark"); Text("승인") }
                        .font(.system(size: 14, weight: .semibold)).foregroundStyle(BG.brandFg)
                        .frame(maxWidth: .infinity).frame(height: 44)
                        .background(BG.brand, in: RoundedRectangle(cornerRadius: 12))
                }.buttonStyle(.plain)
            }
        }
        .padding(16).cardStyle()
    }
}

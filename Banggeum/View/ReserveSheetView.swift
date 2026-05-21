import SwiftUI

struct ReserveSheetView: View {
    @EnvironmentObject var store: MockStore
    @Environment(\.dismiss) private var dismiss
    let room: Room

    @State private var pickedId: String?
    @State private var unmanned = false
    @State private var done = false

    private var slots: [VisitSlot] { store.slots(of: room.id).filter { !$0.isBooked } }

    var body: some View {
        VStack(spacing: 0) {
            Capsule().fill(BG.border).frame(width: 40, height: 5).padding(.top, 10).padding(.bottom, 6)
            if done { successView } else { formView }
        }
        .padding(.horizontal, 20).padding(.bottom, 20)
        .background(BG.card)
    }

    private var formView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("방문 시간 선택").font(.system(size: 18, weight: .bold))
                Text("\(room.approvalMode == .auto ? "선택 즉시 자동 확정" : "집주인 승인 후 확정") · 전화 없이 예약")
                    .font(.system(size: 13)).foregroundStyle(BG.mutedFg).padding(.top, 4)

                VStack(spacing: 8) {
                    ForEach(slots) { s in
                        Button { pickedId = s.id } label: {
                            HStack {
                                Text(slotLabel(day: s.startDay, hour: s.hour)).font(.system(size: 15, weight: .semibold)).foregroundStyle(BG.ink)
                                Spacer()
                                if pickedId == s.id { Image(systemName: "checkmark").foregroundStyle(BG.brand) }
                            }
                            .padding(.horizontal, 16).padding(.vertical, 14)
                            .background(pickedId == s.id ? BG.brandSoft : BG.card, in: RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(pickedId == s.id ? BG.brand : BG.border, lineWidth: 1))
                        }.buttonStyle(.plain)
                    }
                }
                .padding(.top, 16)

                if room.unmannedOk {
                    Button { unmanned.toggle() } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "key").foregroundStyle(unmanned ? BG.brand : BG.mutedFg)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("무인 방문").font(.system(size: 15, weight: .semibold)).foregroundStyle(BG.ink)
                                Text("일회용 도어락 비밀번호로 혼자 둘러보기").font(.system(size: 12)).foregroundStyle(BG.mutedFg)
                            }
                            Spacer()
                            if unmanned { Image(systemName: "checkmark").foregroundStyle(BG.brand) }
                        }
                        .padding(16)
                        .background(unmanned ? BG.brandSoft : BG.card, in: RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(unmanned ? BG.brand : BG.border, lineWidth: 1))
                    }.buttonStyle(.plain).padding(.top, 12)
                }

                Button {
                    if let id = pickedId, let slot = slots.first(where: { $0.id == id }) {
                        store.addReservation(room: room, slot: slot, unmanned: unmanned)
                        done = true
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar.badge.checkmark")
                        Text(room.approvalMode == .auto ? "방문 확정하기" : "예약 요청 보내기").font(.system(size: 16, weight: .bold))
                    }
                    .foregroundStyle(pickedId == nil ? BG.mutedFg : BG.brandFg)
                    .frame(maxWidth: .infinity).frame(height: 52)
                    .background(pickedId == nil ? BG.muted : BG.brand, in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain).disabled(pickedId == nil).padding(.top, 20)
            }
        }
    }

    private var successView: some View {
        VStack(spacing: 0) {
            Image(systemName: "checkmark")
                .font(.system(size: 28, weight: .bold)).foregroundStyle(BG.good)
                .frame(width: 56, height: 56).background(BG.good.opacity(0.1), in: Circle())
                .padding(.top, 16)
            Text(room.approvalMode == .auto ? "방문이 확정됐어요" : "예약 요청을 보냈어요")
                .font(.system(size: 18, weight: .bold)).padding(.top, 16)
            Text(room.approvalMode == .auto
                 ? "전화 없이 바로 확정됐습니다. 방문 시간에 맞춰 알림을 보내드려요."
                 : "집주인이 확인하면 알림으로 알려드려요. 보통 1시간 이내 응답합니다.")
                .font(.system(size: 14)).foregroundStyle(BG.mutedFg)
                .multilineTextAlignment(.center).padding(.top, 6).padding(.horizontal, 8)
            Button { dismiss() } label: {
                Text("확인").font(.system(size: 16, weight: .bold)).foregroundStyle(BG.brandFg)
                    .frame(maxWidth: .infinity).frame(height: 52)
                    .background(BG.brand, in: RoundedRectangle(cornerRadius: 16))
            }.buttonStyle(.plain).padding(.top, 24)
        }
    }
}

import SwiftUI

// 바로 계약하기 — 사람 대면 없이 전자계약으로 "계약까지".
struct ContractSheetView: View {
    @Environment(\.dismiss) private var dismiss
    let room: Room

    @State private var term: Int
    @State private var agree = false
    @State private var done = false

    init(room: Room) {
        self.room = room
        _term = State(initialValue: room.faq.shortTermOk ? 1 : 12)
    }

    private var auto: Bool { room.approvalMode == .auto }

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
                HStack(spacing: 8) {
                    Text("바로 계약하기").font(.system(size: 18, weight: .bold))
                    HStack(spacing: 3) {
                        Image(systemName: "checkmark.shield.fill").font(.system(size: 10))
                        Text("비대면 전자계약").font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(BG.brand)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(BG.brandSoft, in: Capsule())
                }
                Text("전화·대면 없이 전자서명으로 계약까지 끝냅니다.")
                    .font(.system(size: 13)).foregroundStyle(BG.mutedFg).padding(.top, 4)

                // 계약 조건
                VStack(spacing: 8) {
                    condRow("보증금", "\(formatMoney(room.deposit))원")
                    condRow("월세", "\(formatMoney(room.monthlyRent))원")
                    condRow("관리비", room.maintenanceIncluded ? "월세에 포함" : "\(formatMoney(room.maintenanceFee))원/월")
                    condRow("입주 가능", room.faq.moveInDate)
                }
                .padding(16)
                .background(BG.muted.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
                .padding(.top, 16)

                // 계약 기간
                Text("계약 기간").font(.system(size: 13, weight: .medium)).padding(.top, 16)
                HStack(spacing: 8) {
                    ForEach([(1, "단기(1개월~)"), (6, "6개월"), (12, "1년")], id: \.0) { (m, label) in
                        Button { term = m } label: {
                            Text(label).font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(term == m ? BG.brand : BG.ink)
                                .frame(maxWidth: .infinity).padding(.vertical, 10)
                                .background(term == m ? BG.brandSoft : BG.card, in: RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(term == m ? BG.brand : BG.border, lineWidth: 1))
                        }.buttonStyle(.plain)
                    }
                }
                .padding(.top, 8)

                // 전자서명 동의
                Button { agree.toggle() } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "signature").foregroundStyle(agree ? BG.brand : BG.mutedFg)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("전자서명으로 계약에 동의").font(.system(size: 14, weight: .semibold)).foregroundStyle(BG.ink)
                            Text("본인인증 기반 전자계약 · 계약서 사본 보관").font(.system(size: 12)).foregroundStyle(BG.mutedFg)
                        }
                        Spacer()
                        if agree { Image(systemName: "checkmark").foregroundStyle(BG.brand) }
                    }
                    .padding(16)
                    .background(agree ? BG.brandSoft : BG.card, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(agree ? BG.brand : BG.border, lineWidth: 1))
                }.buttonStyle(.plain).padding(.top, 16)

                Button { done = true } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "signature")
                        Text(auto ? "전자서명하고 계약 체결" : "계약 신청하기").font(.system(size: 16, weight: .bold))
                    }
                    .foregroundStyle(agree ? BG.brandFg : BG.mutedFg)
                    .frame(maxWidth: .infinity).frame(height: 52)
                    .background(agree ? BG.brand : BG.muted, in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain).disabled(!agree).padding(.top, 20)

                Text("제출 시 표준 임대차계약 + 전자서명에 동의하게 됩니다")
                    .font(.system(size: 11.5)).foregroundStyle(BG.mutedFg)
                    .frame(maxWidth: .infinity).multilineTextAlignment(.center).padding(.top, 8)
            }
        }
    }

    private var successView: some View {
        VStack(spacing: 0) {
            Image(systemName: "checkmark")
                .font(.system(size: 28, weight: .bold)).foregroundStyle(BG.good)
                .frame(width: 56, height: 56).background(BG.good.opacity(0.1), in: Circle()).padding(.top, 16)
            Text(auto ? "전자계약이 체결됐어요" : "계약 신청을 보냈어요")
                .font(.system(size: 18, weight: .bold)).padding(.top, 16)
            Text(auto
                 ? "사람 만나지 않고 계약 완료! 전자계약서를 채팅·이메일로 보내드려요. 입주일에 맞춰 도어락 정보가 전달됩니다."
                 : "집주인이 전자서명하면 계약이 체결됩니다. 진행 상황은 알림으로 알려드려요. (보통 하루 이내)")
                .font(.system(size: 14)).foregroundStyle(BG.mutedFg)
                .multilineTextAlignment(.center).padding(.top, 6).padding(.horizontal, 8)
            Button { dismiss() } label: {
                Text("확인").font(.system(size: 16, weight: .bold)).foregroundStyle(BG.brandFg)
                    .frame(maxWidth: .infinity).frame(height: 52).background(BG.brand, in: RoundedRectangle(cornerRadius: 16))
            }.buttonStyle(.plain).padding(.top, 24)
        }
    }

    private func condRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 14)).foregroundStyle(BG.mutedFg)
            Spacer()
            Text(value).font(.system(size: 14, weight: .semibold)).foregroundStyle(BG.ink)
        }
    }
}

import SwiftUI

struct HostNewView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var region = "신촌"
    @State private var opts: Set<String> = ["세탁기", "냉장고"]
    @State private var life: Set<String> = ["채광 좋음"]
    @State private var slots: Set<String> = ["오후 6시"]
    @State private var autoApprove = true
    @State private var done = false
    @State private var title = ""

    private let OPTIONS = ["세탁기", "냉장고", "에어컨", "인덕션", "침대", "책상"]
    private let LIFE = ["채광 좋음", "조용함", "곰팡이 없음", "남향", "수압 좋음", "주차 가능"]
    private let SLOTS = ["오전 11시", "오후 2시", "오후 6시"]

    var body: some View {
        if done {
            doneView
        } else {
            form
        }
    }

    private var form: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                section("사진 · 영상") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            VStack(spacing: 4) {
                                Image(systemName: "camera").font(.system(size: 24)).foregroundStyle(BG.mutedFg)
                                Text("추가").font(.system(size: 12, weight: .medium)).foregroundStyle(BG.mutedFg)
                            }
                            .frame(width: 96, height: 96)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(BG.border, style: StrokeStyle(lineWidth: 2, dash: [5])))
                            ForEach(1...2, id: \.self) { i in
                                Text("사진 \(i)").font(.system(size: 12)).foregroundStyle(BG.mutedFg)
                                    .frame(width: 96, height: 96).background(BG.muted, in: RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                    hint("실제 방 사진일수록 신뢰 배지를 받기 쉬워요")
                }

                section("기본 정보") {
                    field("제목 (예: 신촌역 3분, 채광 좋은 원룸)", text: $title)
                    Text("지역").font(.system(size: 13)).foregroundStyle(BG.mutedFg)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8, alignment: .leading)], alignment: .leading, spacing: 8) {
                        ForEach(REGIONS, id: \.self) { item in
                            chip(item, active: region == item) { region = item }
                        }
                    }
                    HStack(spacing: 10) {
                        field("보증금 (만원)"); field("월세 (만원)")
                    }
                    HStack(spacing: 10) {
                        field("관리비 (만원)"); field("전용면적 (㎡)")
                    }
                }

                section("옵션") { multiChips(OPTIONS, sel: $opts) }

                section("생활 정보 체크리스트") {
                    hint("면적보다 중요해요. 솔직하게 체크할수록 방문 전환이 높아요.")
                    multiChips(LIFE, sel: $life)
                }

                section("방문 가능 시간") {
                    multiChips(SLOTS, sel: $slots)
                    Button { autoApprove.toggle() } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("예약 자동 승인").font(.system(size: 15, weight: .semibold)).foregroundStyle(BG.ink)
                                Text("전화·확인 없이 바로 방문 확정 — 응답 피로 감소").font(.system(size: 12)).foregroundStyle(BG.mutedFg)
                            }
                            Spacer()
                            Toggle("", isOn: $autoApprove).labelsHidden().tint(BG.brand)
                        }
                        .padding(16).cardStyle(radius: 16)
                    }.buttonStyle(.plain).padding(.top, 12)
                }
            }
            .padding(20)
        }
        .background(BG.sand)
        .navigationTitle("매물 등록")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button { done = true } label: {
                HStack(spacing: 8) { Image(systemName: "plus"); Text("매물 등록하기").font(.system(size: 16, weight: .bold)) }
                    .foregroundStyle(BG.brandFg).frame(maxWidth: .infinity).frame(height: 52)
                    .background(BG.brand, in: RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain).padding(20).background(BG.card)
        }
    }

    private var doneView: some View {
        VStack(spacing: 0) {
            Image(systemName: "checkmark").font(.system(size: 32, weight: .bold)).foregroundStyle(BG.good)
                .frame(width: 64, height: 64).background(BG.good.opacity(0.1), in: Circle())
            Text("매물이 등록됐어요").font(.system(size: 20, weight: .bold)).padding(.top, 16)
            Text("검토 후 공개됩니다. 방문 요청이 오면 알림으로 알려드려요.")
                .font(.system(size: 14)).foregroundStyle(BG.mutedFg).multilineTextAlignment(.center).padding(.top, 8)
            Button { dismiss() } label: {
                Text("집주인 홈으로").font(.system(size: 16, weight: .bold)).foregroundStyle(BG.brandFg)
                    .frame(maxWidth: .infinity).frame(height: 52).background(BG.brand, in: RoundedRectangle(cornerRadius: 16))
            }.buttonStyle(.plain).padding(.top, 24)
        }
        .padding(32).frame(maxWidth: .infinity, maxHeight: .infinity).background(BG.sand)
        .navigationBarHidden(true)
    }

    // MARK: builders
    @ViewBuilder private func section(_ title: String, @ViewBuilder _ content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.system(size: 16, weight: .bold))
            content()
        }
    }
    private func hint(_ t: String) -> some View { Text(t).font(.system(size: 12)).foregroundStyle(BG.mutedFg) }

    @State private var dummyText = ""
    private func field(_ placeholder: String, text: Binding<String>? = nil) -> some View {
        TextField(placeholder, text: text ?? $dummyText)
            .font(.system(size: 15)).padding(.horizontal, 16).frame(height: 48)
            .background(BG.card, in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(BG.border, lineWidth: 1))
    }

    private func multiChips(_ items: [String], sel: Binding<Set<String>>) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8, alignment: .leading)], alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                chip(item, active: sel.wrappedValue.contains(item)) {
                    if sel.wrappedValue.contains(item) { sel.wrappedValue.remove(item) } else { sel.wrappedValue.insert(item) }
                }
            }
        }
    }
    private func chip(_ label: String, active: Bool, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label).font(.system(size: 14, weight: .semibold)).foregroundStyle(active ? BG.brandFg : BG.ink)
                .padding(.horizontal, 16).padding(.vertical, 9)
                .background(active ? BG.brand : BG.card, in: Capsule())
                .overlay(Capsule().stroke(BG.border, lineWidth: active ? 0 : 1))
        }.buttonStyle(.plain)
    }
}

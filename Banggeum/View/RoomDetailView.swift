import SwiftUI

struct RoomDetailView: View {
    @EnvironmentObject var store: MockStore
    @Environment(\.dismiss) private var dismiss
    let roomId: String
    @State private var showReserve = false
    @State private var showContract = false

    var body: some View {
        guard let room = store.room(roomId) else {
            return AnyView(Text("방을 찾을 수 없어요").foregroundStyle(BG.mutedFg))
        }
        let host = store.host(room)

        return AnyView(
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 사진
                    ZStack(alignment: .top) {
                        RoomImage(url: room.photos[0])
                            .frame(maxWidth: .infinity).frame(height: 300).clipped()
                        HStack {
                            circleBtn("chevron.left") { dismiss() }
                            Spacer()
                            circleBtn(store.isFavorite(room.id) ? "heart.fill" : "heart",
                                      tint: store.isFavorite(room.id) ? BG.brand : .white) {
                                store.toggleFavorite(room.id)
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    VStack(alignment: .leading, spacing: 24) {
                        // 타이틀/가격
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(room.region) · \(room.roomType.label) · \(room.floor)층 · \(room.areaM2, specifier: "%.1f")㎡")
                                .font(.system(size: 13)).foregroundStyle(BG.mutedFg)
                            Text(room.title).font(.system(size: 21, weight: .heavy))
                            Text(priceLine(room)).font(.system(size: 19, weight: .bold))
                            Text(room.address).font(.system(size: 13)).foregroundStyle(BG.mutedFg)
                        }

                        // 배지
                        FlowChips(room.badges)

                        // 집주인 신뢰
                        HStack(spacing: 12) {
                            RoomImage(url: host.avatarUrl ?? "").frame(width: 44, height: 44).clipShape(Circle())
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(host.name) 집주인").font(.system(size: 15, weight: .bold))
                                TrustRowView(score: host.trustScore, verified: host.verified)
                            }
                            Spacer()
                        }
                        .padding(16).cardStyle()

                        // 실제 생활 정보
                        VStack(alignment: .leading, spacing: 12) {
                            Text("실제 생활 정보").font(.system(size: 16, weight: .bold))
                            let cells = lifeCells(room.lifeInfo)
                            VStack(spacing: 12) {
                                ForEach(Array(stride(from: 0, to: cells.count, by: 2)), id: \.self) { i in
                                    HStack(spacing: 12) {
                                        lifeCell(cells[i])
                                        if i + 1 < cells.count { lifeCell(cells[i + 1]) } else { Spacer() }
                                    }
                                }
                            }
                        }

                        // AI 자동응답 FAQ
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Text("자주 묻는 질문").font(.system(size: 16, weight: .bold))
                                HStack(spacing: 3) {
                                    Image(systemName: "sparkles").font(.system(size: 10))
                                    Text("AI 자동응답").font(.system(size: 11, weight: .semibold))
                                }
                                .foregroundStyle(BG.brand)
                                .padding(.horizontal, 8).padding(.vertical, 3)
                                .background(BG.brandSoft, in: Capsule())
                            }
                            VStack(spacing: 0) {
                                let faq = faqRows(room)
                                ForEach(faq.indices, id: \.self) { i in
                                    if i > 0 { Divider().background(BG.border) }
                                    HStack {
                                        Text(faq[i].0).font(.system(size: 14)).foregroundStyle(BG.mutedFg)
                                        Spacer()
                                        Text(faq[i].1).font(.system(size: 14, weight: .semibold))
                                    }
                                    .padding(16)
                                }
                            }
                            .cardStyle()
                        }

                        // 설명
                        VStack(alignment: .leading, spacing: 8) {
                            Text("집주인 소개").font(.system(size: 16, weight: .bold))
                            Text(room.description).font(.system(size: 15)).foregroundStyle(BG.ink.opacity(0.85)).lineSpacing(5)
                        }
                    }
                    .padding(20)
                }
            }
            .background(BG.sand)
            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 8) {
                    Button {
                        // 더미: 통합 시 해당 집주인과의 채팅으로 이동
                    } label: {
                        Image(systemName: "bubble.left").font(.system(size: 20)).foregroundStyle(BG.ink)
                            .frame(width: 52, height: 52)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(BG.border, lineWidth: 1))
                    }.buttonStyle(.plain)
                    Button {
                        showReserve = true
                    } label: {
                        Text("방문 예약")
                            .font(.system(size: 15, weight: .bold)).foregroundStyle(BG.ink)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(BG.border, lineWidth: 1))
                    }.buttonStyle(.plain)
                    Button {
                        showContract = true
                    } label: {
                        Text("바로 계약")
                            .font(.system(size: 15, weight: .bold)).foregroundStyle(BG.brandFg)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .background(BG.brand, in: RoundedRectangle(cornerRadius: 16))
                    }.buttonStyle(.plain)
                }
                .padding(.horizontal, 20).padding(.vertical, 12)
                .background(BG.card.shadow(.drop(color: .black.opacity(0.06), radius: 8, y: -2)))
            }
            .sheet(isPresented: $showReserve) {
                ReserveSheetView(room: room)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showContract) {
                ContractSheetView(room: room)
                    .presentationDetents([.large])
            }
        )
    }

    // MARK: helpers
    private func circleBtn(_ system: String, tint: Color = .white, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system).font(.system(size: 18)).foregroundStyle(tint)
                .frame(width: 40, height: 40).background(.black.opacity(0.3), in: Circle())
        }.buttonStyle(.plain)
    }

    private struct LifeCell { let icon: String; let label: String; let value: String }
    private func lifeCells(_ li: LifeInfo) -> [LifeCell] {
        let dir = ["S": "남향", "E": "동향", "W": "서향", "N": "북향"][li.windowDir] ?? "남향"
        return [
            LifeCell(icon: "sun.max", label: "채광", value: li.sunlight == "good" ? "잘 들어요" : (li.sunlight == "poor" ? "약해요" : "보통")),
            LifeCell(icon: "speaker.wave.2", label: "소음", value: li.noise == "quiet" ? "조용해요" : (li.noise == "loud" ? "있는 편" : "보통")),
            LifeCell(icon: "safari", label: "창 방향", value: dir),
            LifeCell(icon: "drop", label: "수압", value: li.waterPressure == "strong" ? "센 편" : (li.waterPressure == "weak" ? "약한 편" : "보통")),
            LifeCell(icon: "figure.walk", label: "역 도보", value: "\(li.walkMinToStation)분"),
            LifeCell(icon: "sparkles", label: "곰팡이", value: li.mold ? "확인 필요" : "없어요"),
        ]
    }
    private func lifeCell(_ c: LifeCell) -> some View {
        HStack(spacing: 12) {
            Image(systemName: c.icon).font(.system(size: 20)).foregroundStyle(BG.brand)
            VStack(alignment: .leading, spacing: 2) {
                Text(c.label).font(.system(size: 12)).foregroundStyle(BG.mutedFg)
                Text(c.value).font(.system(size: 14, weight: .semibold))
            }
            Spacer()
        }
        .padding(14).frame(maxWidth: .infinity).cardStyle(radius: 16)
    }
    private func faqRows(_ room: Room) -> [(String, String)] {
        let f = room.faq
        return [
            ("관리비 포함인가요?", f.maintenanceIncluded ? "네, 월세에 관리비(\(formatMoney(room.maintenanceFee))) 포함" : "별도 \(formatMoney(room.maintenanceFee))/월"),
            ("언제 입주 가능해요?", "\(f.moveInDate)부터"),
            ("반려동물 되나요?", f.petAllowed ? "가능해요" : "불가해요"),
            ("주차 되나요?", f.parking ? "가능해요" : "불가해요"),
            ("단기 계약 가능해요?", f.shortTermOk ? "가능해요" : "장기만 가능"),
        ]
    }
}

// MARK: - 배지 줄바꿈
struct FlowChips: View {
    let items: [String]
    init(_ items: [String]) { self.items = items }
    var body: some View {
        // 간단 2-3개 줄바꿈 — LazyVGrid adaptive
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8, alignment: .leading)], alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { LifeBadgeView(text: $0) }
        }
    }
}

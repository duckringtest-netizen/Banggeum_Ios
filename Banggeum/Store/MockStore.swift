import Foundation
import SwiftUI

// 방금 더미 저장소 — Web mock-data.ts / Android MockStore 와 동일 데이터.
// 통합 시 accessor 들을 Supabase 쿼리로 교체.
final class MockStore: ObservableObject {
    static let shared = MockStore()

    @Published var favorites: Set<String> = ["r1", "r7"]
    @Published var reservations: [Reservation] = [
        Reservation(id: "rsv1", roomId: "r3", tenantId: "u_me", slotDay: 1, slotHour: 14,
                    status: .approved, unmanned: true, doorCode: "4827", memo: nil),
        Reservation(id: "rsv2", roomId: "r5", tenantId: "u_me", slotDay: 2, slotHour: 18,
                    status: .requested, unmanned: false, doorCode: nil, memo: "퇴근 후 방문 희망합니다"),
    ]

    private func img(_ seed: String) -> String { "https://picsum.photos/seed/\(seed)/900/700" }

    let currentUser = User(id: "u_me", role: .tenant, name: "김방금",
                           avatarUrl: "https://picsum.photos/seed/avatar-me/200/200",
                           phone: "010-0000-0000", trustScore: 92, verified: ["identity", "school_email"])

    lazy var users: [User] = [
        currentUser,
        User(id: "u_host1", role: .landlord, name: "이성수", avatarUrl: img("avatar-host1"), phone: nil, trustScore: 88, verified: ["identity", "account", "ownership"]),
        User(id: "u_host2", role: .landlord, name: "박신촌", avatarUrl: img("avatar-host2"), phone: nil, trustScore: 96, verified: ["identity", "account", "ownership"]),
        User(id: "u_host3", role: .landlord, name: "최건대", avatarUrl: img("avatar-host3"), phone: nil, trustScore: 74, verified: ["identity", "account"]),
    ]

    lazy var rooms: [Room] = [
        Room(id: "r1", hostId: "u_host2", title: "신촌역 3분, 채광 좋은 깔끔 원룸", region: "신촌", address: "서울 서대문구 창천동",
             lat: 37.5559, lng: 126.9368, roomType: .oneroom, deposit: 5_000_000, monthlyRent: 550_000, maintenanceFee: 70_000,
             maintenanceIncluded: false, areaM2: 19.8, floor: 3, availableFromDays: 7,
             photos: [img("r1a"), img("r1b"), img("r1c")], status: .available,
             description: "햇빛 잘 드는 남향 원룸입니다. 풀옵션이고 역세권이라 출퇴근 편해요. 곰팡이/누수 없이 관리 잘 된 방입니다.",
             options: RoomOptions(washer: true, fridge: true, aircon: true, bed: true, desk: true, induction: true),
             lifeInfo: LifeInfo(sunlight: "good", noise: "quiet", mold: false, windowDir: "S", walkMinToStation: 3, walkMinToStore: 1, waterPressure: "strong"),
             faq: RoomFaq(maintenanceIncluded: false, moveInDate: "다음 주", petAllowed: false, shortTermOk: false, parking: false, floor: 3),
             approvalMode: .auto, unmannedOk: true),

        Room(id: "r2", hostId: "u_host1", title: "성수 카페거리 도보 5분, 분리형 원룸", region: "성수", address: "서울 성동구 성수동2가",
             lat: 37.5446, lng: 127.0559, roomType: .separated, deposit: 10_000_000, monthlyRent: 700_000, maintenanceFee: 100_000,
             maintenanceIncluded: true, areaM2: 26.4, floor: 5, availableFromDays: 14,
             photos: [img("r2a"), img("r2b"), img("r2c")], status: .available,
             description: "주방이 분리된 구조라 냄새 걱정 없어요. 관리비에 인터넷/수도 포함입니다. 신축이라 깨끗합니다.",
             options: RoomOptions(washer: true, fridge: true, aircon: true, bed: false, desk: false, induction: true),
             lifeInfo: LifeInfo(sunlight: "normal", noise: "quiet", mold: false, windowDir: "E", walkMinToStation: 5, walkMinToStore: 2, waterPressure: "strong"),
             faq: RoomFaq(maintenanceIncluded: true, moveInDate: "2주 후", petAllowed: true, shortTermOk: true, parking: true, floor: 5),
             approvalMode: .manual, unmannedOk: false),

        Room(id: "r3", hostId: "u_host3", title: "건대입구 오피스텔, 풀옵션 + 주차", region: "건대", address: "서울 광진구 화양동",
             lat: 37.5403, lng: 127.0701, roomType: .officetel, deposit: 20_000_000, monthlyRent: 800_000, maintenanceFee: 120_000,
             maintenanceIncluded: true, areaM2: 23.1, floor: 11, availableFromDays: 3,
             photos: [img("r3a"), img("r3b")], status: .available,
             description: "고층이라 뷰가 좋고 조용합니다. 주차 가능하고 보안 철저한 오피스텔입니다.",
             options: RoomOptions(washer: true, fridge: true, aircon: true, bed: true, desk: true, induction: true),
             lifeInfo: LifeInfo(sunlight: "good", noise: "quiet", mold: false, windowDir: "S", walkMinToStation: 4, walkMinToStore: 1, waterPressure: "normal"),
             faq: RoomFaq(maintenanceIncluded: true, moveInDate: "3일 후", petAllowed: false, shortTermOk: false, parking: true, floor: 11),
             approvalMode: .auto, unmannedOk: true),

        Room(id: "r4", hostId: "u_host2", title: "혜화역 도보 7분, 조용한 주택가 원룸", region: "혜화", address: "서울 종로구 명륜동",
             lat: 37.5826, lng: 126.9999, roomType: .oneroom, deposit: 3_000_000, monthlyRent: 480_000, maintenanceFee: 50_000,
             maintenanceIncluded: false, areaM2: 16.5, floor: 2, availableFromDays: 10,
             photos: [img("r4a"), img("r4b")], status: .available,
             description: "대학병원/대학교 가까운 조용한 주택가입니다. 혼자 살기 좋은 아담한 원룸이에요.",
             options: RoomOptions(washer: true, fridge: true, aircon: true, bed: true, desk: false, induction: false),
             lifeInfo: LifeInfo(sunlight: "normal", noise: "quiet", mold: false, windowDir: "W", walkMinToStation: 7, walkMinToStore: 3, waterPressure: "normal"),
             faq: RoomFaq(maintenanceIncluded: false, moveInDate: "10일 후", petAllowed: false, shortTermOk: true, parking: false, floor: 2),
             approvalMode: .manual, unmannedOk: false),

        Room(id: "r5", hostId: "u_host1", title: "서울대입구 신축 스튜디오", region: "서울대입구", address: "서울 관악구 봉천동",
             lat: 37.4813, lng: 126.9527, roomType: .studio, deposit: 8_000_000, monthlyRent: 600_000, maintenanceFee: 80_000,
             maintenanceIncluded: true, areaM2: 21.0, floor: 4, availableFromDays: 5,
             photos: [img("r5a"), img("r5b"), img("r5c")], status: .available,
             description: "신축이라 곰팡이 걱정 없고 채광 좋아요. 학생 많은 동네라 편의시설 풍부합니다.",
             options: RoomOptions(washer: true, fridge: true, aircon: true, bed: true, desk: true, induction: true),
             lifeInfo: LifeInfo(sunlight: "good", noise: "normal", mold: false, windowDir: "S", walkMinToStation: 6, walkMinToStore: 1, waterPressure: "strong"),
             faq: RoomFaq(maintenanceIncluded: true, moveInDate: "5일 후", petAllowed: false, shortTermOk: false, parking: false, floor: 4),
             approvalMode: .auto, unmannedOk: true),

        Room(id: "r6", hostId: "u_host3", title: "왕십리역 초역세권 투룸", region: "왕십리", address: "서울 성동구 행당동",
             lat: 37.5613, lng: 127.0379, roomType: .twroom, deposit: 15_000_000, monthlyRent: 900_000, maintenanceFee: 100_000,
             maintenanceIncluded: false, areaM2: 33.0, floor: 8, availableFromDays: 20,
             photos: [img("r6a"), img("r6b")], status: .available,
             description: "룸메이트와 살기 좋은 투룸입니다. 4개 노선 환승역이라 어디든 편해요.",
             options: RoomOptions(washer: true, fridge: true, aircon: true, bed: false, desk: false, induction: true),
             lifeInfo: LifeInfo(sunlight: "normal", noise: "normal", mold: false, windowDir: "E", walkMinToStation: 2, walkMinToStore: 2, waterPressure: "normal"),
             faq: RoomFaq(maintenanceIncluded: false, moveInDate: "20일 후", petAllowed: true, shortTermOk: false, parking: true, floor: 8),
             approvalMode: .manual, unmannedOk: false),

        Room(id: "r7", hostId: "u_host2", title: "강남 병원권 원룸, 간호사·레지던트 추천", region: "강남병원권", address: "서울 강남구 일원동",
             lat: 37.4894, lng: 127.0856, roomType: .oneroom, deposit: 10_000_000, monthlyRent: 750_000, maintenanceFee: 90_000,
             maintenanceIncluded: true, areaM2: 18.0, floor: 6, availableFromDays: 2,
             photos: [img("r7a"), img("r7b")], status: .available,
             description: "대형병원 도보권이라 교대 근무자에게 좋아요. 방음 잘 되고 낮에도 조용합니다.",
             options: RoomOptions(washer: true, fridge: true, aircon: true, bed: true, desk: true, induction: true),
             lifeInfo: LifeInfo(sunlight: "normal", noise: "quiet", mold: false, windowDir: "S", walkMinToStation: 8, walkMinToStore: 2, waterPressure: "strong"),
             faq: RoomFaq(maintenanceIncluded: true, moveInDate: "2일 후", petAllowed: false, shortTermOk: true, parking: false, floor: 6),
             approvalMode: .auto, unmannedOk: true),

        Room(id: "r8", hostId: "u_host1", title: "성수 한강뷰 오피스텔", region: "성수", address: "서울 성동구 성수동1가",
             lat: 37.5447, lng: 127.0411, roomType: .officetel, deposit: 30_000_000, monthlyRent: 1_100_000, maintenanceFee: 150_000,
             maintenanceIncluded: true, areaM2: 28.0, floor: 15, availableFromDays: 30,
             photos: [img("r8a"), img("r8b"), img("r8c")], status: .available,
             description: "고층 한강뷰 오피스텔입니다. 신축급 컨디션, 보안/주차 완비.",
             options: RoomOptions(washer: true, fridge: true, aircon: true, bed: true, desk: true, induction: true),
             lifeInfo: LifeInfo(sunlight: "good", noise: "quiet", mold: false, windowDir: "S", walkMinToStation: 9, walkMinToStore: 1, waterPressure: "strong"),
             faq: RoomFaq(maintenanceIncluded: true, moveInDate: "30일 후", petAllowed: true, shortTermOk: false, parking: true, floor: 15),
             approvalMode: .manual, unmannedOk: false),
    ]

    lazy var visitSlots: [VisitSlot] = rooms.enumerated().flatMap { (ri, room) -> [VisitSlot] in
        var out: [VisitSlot] = []
        for day in 1...3 {
            for hour in [11, 14, 18] {
                out.append(VisitSlot(id: "slot_\(room.id)_\(day)_\(hour)", roomId: room.id, startDay: day, hour: hour,
                                     isBooked: ri % 4 == 0 && day == 1 && hour == 11))
            }
        }
        return out
    }

    lazy var chats: [Chat] = [
        Chat(id: "c1", roomId: "r1", tenantId: "u_me", hostId: "u_host2", lastMessage: "네, 입주는 다음 주부터 가능합니다 :)"),
        Chat(id: "c2", roomId: "r3", tenantId: "u_me", hostId: "u_host3", lastMessage: "[자동응답] 주차 가능합니다. 관리비에 포함되어 있어요."),
    ]

    // MARK: - accessors
    func user(_ id: String) -> User { users.first { $0.id == id } ?? currentUser }
    func room(_ id: String) -> Room? { rooms.first { $0.id == id } }
    func host(_ room: Room) -> User { user(room.hostId) }
    func slots(of roomId: String) -> [VisitSlot] { visitSlots.filter { $0.roomId == roomId } }
    func listRooms(region: String) -> [Room] {
        rooms.filter { $0.status == .available && (region == "전체" || $0.region == region) }
    }
    func favoriteRooms() -> [Room] { rooms.filter { favorites.contains($0.id) } }

    // MARK: - mutations
    func toggleFavorite(_ roomId: String) {
        if favorites.contains(roomId) { favorites.remove(roomId) } else { favorites.insert(roomId) }
    }
    func isFavorite(_ roomId: String) -> Bool { favorites.contains(roomId) }

    func addReservation(room: Room, slot: VisitSlot, unmanned: Bool) {
        let auto = room.approvalMode == .auto
        let rsv = Reservation(
            id: "rsv_\(Int(Date().timeIntervalSince1970))",
            roomId: room.id, tenantId: "u_me", slotDay: slot.startDay, slotHour: slot.hour,
            status: auto ? .approved : .requested, unmanned: unmanned,
            doorCode: (unmanned && auto) ? String(format: "%04d", Int.random(in: 1000...9999)) : nil, memo: nil
        )
        reservations.insert(rsv, at: 0)
    }

    func setReservationStatus(_ id: String, _ status: ReservationStatus) {
        if let i = reservations.firstIndex(where: { $0.id == id }) {
            reservations[i].status = status
        }
    }
}

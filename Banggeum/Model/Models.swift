import Foundation

// 방금 데이터 모델 — Web types.ts + supabase/migrations/0001_init.sql 미러.
// v1 은 순수 mock. 통합 시 Codable + CodingKeys(snake_case) 추가 → Web/Android 와 1:1.

enum UserRole: String { case tenant, landlord }

enum RoomType: String {
    case oneroom, officetel, studio, separated, twroom
    var label: String {
        switch self {
        case .oneroom: return "원룸"
        case .officetel: return "오피스텔"
        case .studio: return "스튜디오"
        case .separated: return "분리형 원룸"
        case .twroom: return "투룸"
        }
    }
}

enum RoomStatus: String { case available, reserved, contracted, hidden }
enum ApprovalMode: String { case auto, manual }
enum MessageKind: String { case text, ai_auto }

enum ReservationStatus: String {
    case requested, approved, rejected, visited, no_show, cancelled
    var label: String {
        switch self {
        case .requested: return "승인 대기"
        case .approved: return "방문 확정"
        case .rejected: return "거절됨"
        case .visited: return "방문 완료"
        case .no_show: return "노쇼"
        case .cancelled: return "취소됨"
        }
    }
}

// 생활형 정보 (면적보다 중요 — 기획서 6-2)
struct LifeInfo {
    var sunlight: String = "normal"   // good | normal | poor
    var noise: String = "normal"      // quiet | normal | loud
    var mold: Bool = false
    var windowDir: String = "S"       // S | E | W | N
    var walkMinToStation: Int = 0
    var walkMinToStore: Int = 0
    var waterPressure: String = "normal" // strong | normal | weak
}

struct RoomOptions {
    var washer = false, fridge = false, aircon = false
    var bed = false, desk = false, induction = false
}

struct RoomFaq {
    var maintenanceIncluded = false
    var moveInDate = ""
    var petAllowed = false
    var shortTermOk = false
    var parking = false
    var floor = 1
}

struct User: Identifiable {
    let id: String
    let role: UserRole
    let name: String
    let avatarUrl: String?
    let phone: String?
    let trustScore: Int
    let verified: [String]   // identity / school_email / hospital_email / job / account / ownership
}

struct Room: Identifiable {
    let id: String
    let hostId: String
    let title: String
    let region: String
    let address: String
    let lat: Double
    let lng: Double
    let roomType: RoomType
    let deposit: Int
    let monthlyRent: Int
    let maintenanceFee: Int
    let maintenanceIncluded: Bool
    let areaM2: Double
    let floor: Int
    let availableFromDays: Int
    let photos: [String]
    let status: RoomStatus
    let description: String
    let options: RoomOptions
    let lifeInfo: LifeInfo
    let faq: RoomFaq
    let approvalMode: ApprovalMode
    let unmannedOk: Bool

    var badges: [String] { deriveBadges(self) }
}

struct VisitSlot: Identifiable {
    let id: String
    let roomId: String
    let startDay: Int
    let hour: Int
    let isBooked: Bool
}

struct Reservation: Identifiable {
    let id: String
    let roomId: String
    let tenantId: String
    let slotDay: Int
    let slotHour: Int
    var status: ReservationStatus
    let unmanned: Bool
    let doorCode: String?
    let memo: String?
}

struct Chat: Identifiable {
    let id: String
    let roomId: String
    let tenantId: String
    let hostId: String
    let lastMessage: String?
}

struct Message: Identifiable {
    let id: String
    let chatId: String
    let senderId: String
    let body: String
    let kind: MessageKind
}

// life_info → 표시 배지 (Web utils.ts / Android deriveBadges 동일 규칙)
func deriveBadges(_ room: Room) -> [String] {
    var b: [String] = []
    let li = room.lifeInfo
    if li.sunlight == "good" { b.append("☀️ 채광 좋음") }
    if li.noise == "quiet" { b.append("🔇 조용함") }
    if (1...5).contains(li.walkMinToStation) { b.append("🚶 역도보 \(li.walkMinToStation)분") }
    if room.options.washer { b.append("🧺 세탁기") }
    if !li.mold { b.append("🚫 곰팡이 없음") }
    if li.windowDir == "S" { b.append("🪟 남향") }
    if li.waterPressure == "strong" { b.append("🚿 수압 좋음") }
    return b
}

// 포맷터 (Web utils.ts / Android Format.kt 미러)
let REGIONS = ["신촌", "성수", "건대", "서울대입구", "혜화", "왕십리", "강남병원권"]

func formatMoney(_ won: Int) -> String {
    if won >= 100_000_000 {
        let eok = won / 100_000_000
        let man = (won % 100_000_000) / 10_000
        return man > 0 ? "\(eok)억 \(man.formatted())만" : "\(eok)억"
    }
    if won >= 10_000 { return "\((won / 10_000).formatted())만" }
    return "\(won.formatted())원"
}

func priceLine(_ room: Room) -> String {
    "보증금 \(formatMoney(room.deposit)) · 월 \(formatMoney(room.monthlyRent))"
}

func slotLabel(day: Int, hour: Int) -> String {
    let d: String
    switch day {
    case 0: d = "오늘"
    case 1: d = "내일"
    case 2: d = "모레"
    default: d = "\(day)일 뒤"
    }
    return "\(d) \(String(format: "%02d", hour)):00"
}

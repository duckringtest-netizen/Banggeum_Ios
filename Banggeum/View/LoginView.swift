import SwiftUI

struct LoginView: View {
    var onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("방금").font(.system(size: 14, weight: .semibold)).foregroundStyle(BG.brand)
                Text("전화 없이,\n부동산 없이,\n눈치 없이 방 구하기")
                    .font(.system(size: 28, weight: .heavy)).foregroundStyle(BG.ink)
                    .padding(.top, 8).lineSpacing(6)
                Text("대학가·병원 인근 월세를 비대면으로.\n방 탐색부터 방문 예약까지 조용하게.")
                    .font(.system(size: 15)).foregroundStyle(BG.mutedFg).padding(.top, 16).lineSpacing(4)

                VStack(spacing: 10) {
                    authRow("checkmark.shield.fill", "본인인증", "안전한 거래를 위한 기본 인증")
                    authRow("graduationcap.fill", "학교 이메일 인증", "대학생·대학원생 신뢰 배지")
                    authRow("cross.case.fill", "병원·직장 인증", "간호사·레지던트·인턴 우대")
                }
                .padding(.top, 40)
            }
            Spacer()
            VStack(spacing: 10) {
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Image(systemName: "iphone")
                        Text("휴대폰으로 시작하기").font(.system(size: 16, weight: .bold))
                    }
                    .foregroundStyle(BG.brandFg).frame(maxWidth: .infinity).frame(height: 52)
                    .background(BG.brand, in: RoundedRectangle(cornerRadius: 16))
                }.buttonStyle(.plain)
                Button(action: onContinue) {
                    Text("둘러보기 (로그인 없이)").font(.system(size: 16, weight: .semibold)).foregroundStyle(BG.ink)
                        .frame(maxWidth: .infinity).frame(height: 52)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(BG.border, lineWidth: 1))
                }.buttonStyle(.plain)
                Text("시작 시 이용약관 및 개인정보처리방침에 동의하게 됩니다")
                    .font(.system(size: 12)).foregroundStyle(BG.mutedFg).padding(.top, 2)
            }
        }
        .padding(.horizontal, 24).padding(.top, 48).padding(.bottom, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BG.sand)
    }

    private func authRow(_ icon: String, _ title: String, _ desc: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 20)).foregroundStyle(BG.brand)
                .frame(width: 40, height: 40).background(BG.brandSoft, in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 15, weight: .bold))
                Text(desc).font(.system(size: 13)).foregroundStyle(BG.mutedFg)
            }
            Spacer()
        }
        .padding(16).frame(maxWidth: .infinity).cardStyle()
    }
}

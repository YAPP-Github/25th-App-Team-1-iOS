import UIKit

public class R {
    public struct Image {
        public static let svgBtnAdd = UIImage(named: "svg_btn_add", in: .resources, compatibleWith: nil)
    }
    
    public enum AlarmSound: String, CaseIterable {
        case Ascending = "Ascending.caf"
        case Bell_Tower = "Bell_Tower.caf"
        case Blues = "Blues.caf"
        case Boing = "Boing.caf"
        case Crickets = "Crickets.caf"
        case Digital = "Digital.caf"
        case Doorbell = "Doorbell.caf"
        case Duck = "Duck.caf"
        case Harp = "Harp.caf"
        case Marimba = "Marimba.caf"
        case Motocycle = "Motocycle.caf"
        case Old_Car_Horn = "Old_Car_Horn.caf"
        case Old_Phone = "Old_Phone.caf"
        case Piano_Riff = "Piano_Riff.caf"
        case Pinball = "Pinball.caf"
        case Robot = "Robot.caf"
        case Strum = "Strum.caf"
        case Timba = "Timba.caf"
        case Trill = "Trill.caf"
        case Xylophone = "Xylophone.caf"
        
        public var title: String {
            switch self {
            case .Ascending:
                return "상승음"
            case .Bell_Tower:
                return "종탑 소리"
            case .Blues:
                return "블루스"
            case .Boing:
                return "공 튀기는 소리"
            case .Crickets:
                return "귀뚜라미 소리"
            case .Digital:
                return "기계음"
            case .Doorbell:
                return "초인종 소리"
            case .Duck:
                return "오리 소리"
            case .Harp:
                return "하프"
            case .Marimba:
                return "마림바"
            case .Motocycle:
                return "오토바이"
            case .Old_Car_Horn:
                return "구식 자동차 경적"
            case .Old_Phone:
                return "전화 벨소리"
            case .Piano_Riff:
                return "피아노 연주"
            case .Pinball:
                return "핀볼 소리"
            case .Robot:
                return "로보트 소리"
            case .Strum:
                return "기타"
            case .Timba:
                return "타악기"
            case .Trill:
                return "트릴"
            case .Xylophone:
                return "실로폰"
            }
        }
        
        public var alarm: URL? {
            Bundle.resources.url(forResource: rawValue, withExtension: nil)
        }
    }
    
    public struct GIF {
        public static let onboarding1 = Bundle.resources.url(forResource: "onboarding_1", withExtension: "gif")!
    }
    
    public struct Color {
        public static let submain = UIColor(hex: "#FDFE96")
        public static let main100 = UIColor(hex: "#FEFF65")
        public static let main90 = main100.withAlphaComponent(0.9)
        public static let main80 = main100.withAlphaComponent(0.8)
        public static let main70 = main100.withAlphaComponent(0.7)
        public static let main60 = main100.withAlphaComponent(0.6)
        public static let main50 = main100.withAlphaComponent(0.5)
        public static let main40 = main100.withAlphaComponent(0.4)
        public static let main30 = main100.withAlphaComponent(0.3)
        public static let main20 = main100.withAlphaComponent(0.2)
        public static let main10 = main100.withAlphaComponent(0.1)
        
        public static let white100 = UIColor(hex: "#FFFFFF")
        public static let white90 = white100.withAlphaComponent(0.9)
        public static let white80 = white100.withAlphaComponent(0.8)
        public static let white70 = white100.withAlphaComponent(0.7)
        public static let white60 = white100.withAlphaComponent(0.6)
        public static let white50 = white100.withAlphaComponent(0.5)
        public static let white40 = white100.withAlphaComponent(0.4)
        public static let white30 = white100.withAlphaComponent(0.3)
        public static let white20 = white100.withAlphaComponent(0.2)
        public static let white10 = white100.withAlphaComponent(0.1)
        public static let white5 = white100.withAlphaComponent(0.05)
        
        public static let gray50 = UIColor(hex: "#E6EDF8")
        public static let gray100 = UIColor(hex: "#D7E1EE")
        public static let gray200 = UIColor(hex: "#C8D3E3")
        public static let gray300 = UIColor(hex: "#A5B2C5")
        public static let gray400 = UIColor(hex: "#7B8696")
        public static let gray500 = UIColor(hex: "#5D6470")
        public static let gray600 = UIColor(hex: "#3D424B")
        public static let gray700 = UIColor(hex: "#2A2F38")
        public static let gray800 = UIColor(hex: "#1F2127")
        public static let gray900 = UIColor(hex: "#17191F")
        
        // Status
        public static let statusAlert = UIColor(hex: "#F2544A")
        public static let statusAlertPressed = UIColor(hex: "#E53D33")
        public static let statusAlert50 = statusAlert.withAlphaComponent(0.5)
        public static let statusAlert20 = statusAlert.withAlphaComponent(0.2)
        
        public static let statusSuccess = UIColor(hex: "#22C55E")
        public static let statusSuccess50 = statusSuccess.withAlphaComponent(0.5)
        
        // TXT
        public static let textPrimary = UIColor(hex: "#FFFFFF")
        public static let textPrimaryInvert = UIColor(hex: "#17191F")
        public static let textSecondary = UIColor(hex: "#E6EDF8")
        public static let textTertiary = UIColor(hex: "#A5B2C5")
        // disabled는 문의 후 추가 예정
        
        // Ico
        public static let icoPrimary = UIColor(hex: "#FFFFFF")
        public static let icoPrimaryInvert = UIColor(hex: "#17191F")
        public static let icoSecondary = UIColor(hex: "#A5B2C5")
        public static let icoTertiary = UIColor(hex: "#7B8696")
        public static let icoPlaceholder = UIColor(hex: "#5D6470")
        public static let icoDisabled = UIColor(hex: "#2A2F38")
        
        // BG
        public static let bg = UIColor(hex: "#17191F")
        public static let bgLight = UIColor(hex: "#E6EDF8")
        public static let bgBottomSheet = UIColor(hex: "#17191F")
        public static let bgModal = UIColor(hex: "#1F2127")
        public static let bgToast = UIColor(hex: "#3D424B")
        
        // Btn
        public static let btnPrimary = UIColor(hex: "#FEFF65")
        public static let btnSecondary = UIColor(hex: "#3D424B")
        public static let btnDisabled = UIColor(hex: "#2A2F38")
        
        // Line
        public static let line = UIColor(hex: "#2A2F38")
        
        // Letter
        public static let letterBlue2 = UIColor(hex: "#69A8F6")
        public static let letterBabyPink = UIColor(hex: "#E98C8C")
        public static let letterGreen = UIColor(hex: "#4DCC71")
        public static let letterPink = UIColor(hex: "#E682D7")
        
        // Etc
        public static let snoozeBackground = UIColor(hex: "#3D5372")
        
        public static func color(title: String) -> UIColor {
            switch title {
            case "빨강", "레드": return UIColor(hex: "#EF4444")
            case "분홍", "핑크": return UIColor.systemPink
            case "주황", "오렌지": return UIColor.orange
            case "노랑", "옐로우": return UIColor.yellow
            case "초록", "그린": return UIColor.green
            case "파랑", "블루": return UIColor.blue
            case "보라", "퍼플": return UIColor.purple
            case "갈색", "브라운": return UIColor.brown
            case "회색", "그레이": return UIColor.gray
            case "인디고": return UIColor.systemIndigo
            default: return R.Color.gray600
            }
        }
    }
    
    public enum Font: String, CaseIterable {
        case displaySemiBold
        case displayBold
        case title1Bold
        case title1Medium
        case title2Bold
        case title2SemiBold
        case title2Medium
        case title3SemiBold
        
        case heading1SemiBold
        case heading2SemiBold
        case headline1SemiBold
        case headline2SemiBold
        case headline2Medium
        
        case body1SemiBold
        case body1Medium
        case body1Regular
        case body2Medium
        case body2Regular
        
        case label1SemiBold
        case label1Medium
        case label2SemiBold
        case label2regular
        case caption1Regular
        case caption2Regular
        
        case ownglyphPHD_H0
        case ownglyphPHD_H1
        case ownglyphPHD_H2
        case ownglyphPHD_H3
        case ownglyphPHD_H4
        case ownglyphPHD_H5
        
        var size: CGFloat {
            switch self {
            case .displaySemiBold:
                return 56
            case .displayBold:
                return 48
            case .title1Bold:
                return 36
            case .title1Medium:
                return 36
            case .title2Bold:
                return 28
            case .title2SemiBold:
                return 28
            case .title2Medium:
                return 28
            case .title3SemiBold:
                return 24
            case .heading1SemiBold:
                return 22
            case .heading2SemiBold:
                return 20
            case .headline1SemiBold:
                return 18
            case .headline2SemiBold:
                return 17
            case .headline2Medium:
                return 17
            case .body1SemiBold:
                return 16
            case .body1Medium:
                return 16
            case .body1Regular:
                return 16
            case .body2Medium:
                return 15
            case .body2Regular:
                return 15
            case .label1SemiBold:
                return 14
            case .label1Medium:
                return 14
            case .label2SemiBold:
                return 13
            case .label2regular:
                return 13
            case .caption1Regular:
                return 12
            case .caption2Regular:
                return 11
            case .ownglyphPHD_H0:
                return 36
            case .ownglyphPHD_H1:
                return 28
            case .ownglyphPHD_H2:
                return 22
            case .ownglyphPHD_H3:
                return 20
            case .ownglyphPHD_H4:
                return 18
            case .ownglyphPHD_H5:
                return 16
            }
        }
        
        var lineHeight: CGFloat {
            switch self {
            case .displaySemiBold:
                return 1.286
            case .displayBold:
                return 1.3
            case .title1Bold:
                return 1.334
            case .title1Medium:
                return 1.334
            case .title2Bold:
                return 1.358
            case .title2SemiBold:
                return 1.358
            case .title2Medium:
                return 1.358
            case .title3SemiBold:
                return 1.334
            case .heading1SemiBold:
                return 1.364
            case .heading2SemiBold:
                return 1.4
            case .headline1SemiBold:
                return 1.445
            case .headline2SemiBold:
                return 1.412
            case .headline2Medium:
                return 1.412
            case .body1SemiBold:
                return 1.625
            case .body1Medium:
                return 1.5
            case .body1Regular:
                return 1.5
            case .body2Medium:
                return 1.429
            case .body2Regular:
                return 1.6
            case .label1SemiBold:
                return 1.429
            case .label1Medium:
                return 1.571
            case .label2SemiBold:
                return 1.385
            case .label2regular:
                return 1.385
            case .caption1Regular:
                return 1.334
            case .caption2Regular:
                return 1.273
            case .ownglyphPHD_H0:
                return 1.4
            case .ownglyphPHD_H1:
                return 1.4
            case .ownglyphPHD_H2:
                return 1.5
            case .ownglyphPHD_H3:
                return 1.5
            case .ownglyphPHD_H4:
                return 1.3
            case .ownglyphPHD_H5:
                return 1.3
            }
        }
        
        var letterSpacing: CGFloat {
            switch self {
            case .displaySemiBold:
                return -3.19
            case .displayBold:
                return -2.82
            case .title1Bold:
                return -2.7
            case .title1Medium:
                return -2.7
            case .title2Bold:
                return -2.36
            case .title2SemiBold:
                return -2.36
            case .title2Medium:
                return -2.36
            case .title3SemiBold:
                return -2.3
            case .heading1SemiBold:
                return -1.2
            case .heading2SemiBold:
                return -1.2
            case .headline1SemiBold:
                return -1.2
            case .headline2SemiBold:
                return -1
            case .headline2Medium:
                return -1
            case .body1SemiBold:
                return -1
            case .body1Medium:
                return -1
            case .body1Regular:
                return -1
            case .body2Medium:
                return -1
            case .body2Regular:
                return -1
            case .label1SemiBold:
                return -1
            case .label1Medium:
                return -1
            case .label2SemiBold:
                return -1
            case .label2regular:
                return -1
            case .caption1Regular:
                return -1
            case .caption2Regular:
                return -1
            case .ownglyphPHD_H0:
                return -1
            case .ownglyphPHD_H1:
                return -1
            case .ownglyphPHD_H2:
                return -1
            case .ownglyphPHD_H3:
                return -1
            case .ownglyphPHD_H4:
                return -1
            case .ownglyphPHD_H5:
                return -1
            }
        }
        
        public func toUIFont() -> UIFont? {
            switch self {
            case .displaySemiBold:
                return FeatureResourcesFontFamily.Pretendard.semiBold.font(size: size)
            case .displayBold:
                return FeatureResourcesFontFamily.Pretendard.bold.font(size: size)
            case .title1Bold:
                return FeatureResourcesFontFamily.Pretendard.bold.font(size: size)
            case .title1Medium:
                return FeatureResourcesFontFamily.Pretendard.medium.font(size: size)
            case .title2Bold:
                return FeatureResourcesFontFamily.Pretendard.bold.font(size: size)
            case .title2SemiBold:
                return FeatureResourcesFontFamily.Pretendard.semiBold.font(size: size)
            case .title2Medium:
                return FeatureResourcesFontFamily.Pretendard.medium.font(size: size)
            case .title3SemiBold:
                return FeatureResourcesFontFamily.Pretendard.semiBold.font(size: size)
            case .heading1SemiBold:
                return FeatureResourcesFontFamily.Pretendard.semiBold.font(size: size)
            case .heading2SemiBold:
                return FeatureResourcesFontFamily.Pretendard.semiBold.font(size: size)
            case .headline1SemiBold:
                return FeatureResourcesFontFamily.Pretendard.semiBold.font(size: size)
            case .headline2SemiBold:
                return FeatureResourcesFontFamily.Pretendard.semiBold.font(size: size)
            case .headline2Medium:
                return FeatureResourcesFontFamily.Pretendard.medium.font(size: size)
            case .body1SemiBold:
                return FeatureResourcesFontFamily.Pretendard.semiBold.font(size: size)
            case .body1Medium:
                return FeatureResourcesFontFamily.Pretendard.medium.font(size: size)
            case .body1Regular:
                return FeatureResourcesFontFamily.Pretendard.regular.font(size: size)
            case .body2Medium:
                return FeatureResourcesFontFamily.Pretendard.medium.font(size: size)
            case .body2Regular:
                return FeatureResourcesFontFamily.Pretendard.regular.font(size: size)
            case .label1SemiBold:
                return FeatureResourcesFontFamily.Pretendard.semiBold.font(size: size)
            case .label1Medium:
                return FeatureResourcesFontFamily.Pretendard.medium.font(size: size)
            case .label2SemiBold:
                return FeatureResourcesFontFamily.Pretendard.semiBold.font(size: size)
            case .label2regular:
                return FeatureResourcesFontFamily.Pretendard.regular.font(size: size)
            case .caption1Regular:
                return FeatureResourcesFontFamily.Pretendard.regular.font(size: size)
            case .caption2Regular:
                return FeatureResourcesFontFamily.Pretendard.regular.font(size: size)
            case .ownglyphPHD_H0:
                return FeatureResourcesFontFamily.OwnglyphPDH.regular.font(size: size)
            case .ownglyphPHD_H1:
                return FeatureResourcesFontFamily.OwnglyphPDH.regular.font(size: size)
            case .ownglyphPHD_H2:
                return FeatureResourcesFontFamily.OwnglyphPDH.regular.font(size: size)
            case .ownglyphPHD_H3:
                return FeatureResourcesFontFamily.OwnglyphPDH.regular.font(size: size)
            case .ownglyphPHD_H4:
                return FeatureResourcesFontFamily.OwnglyphPDH.regular.font(size: size)
            case .ownglyphPHD_H5:
                return FeatureResourcesFontFamily.OwnglyphPDH.regular.font(size: size)
            }
        }
    }
}

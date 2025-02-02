import UIKit

public class R {
    public struct Image {
        public static let svgBtnAdd = UIImage(named: "svg_btn_add", in: .resources, compatibleWith: nil)
    }
    
    public struct GIF {
        public static let onboarding1 = Bundle.resources.url(forResource: "onboarding_1", withExtension: "gif")!
    }
    
    public struct Sound {
        public static let alarm = Bundle.resources.url(forResource: "crowded_cafe", withExtension: "caf")!
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
            }
        }
    }
}


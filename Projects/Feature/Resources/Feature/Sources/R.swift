import UIKit

public class R {
    public struct Image {
        public static let svgBtnAdd = UIImage(named: "svg_btn_add", in: .resources, compatibleWith: nil)
    }
    
    public struct Sound {
        public static let alarm = Bundle.resources.url(forResource: "crowded_cafe", withExtension: "caf")!
    }
    
    public struct Color {
        static let main100 = UIColor(hex: "#FEFF65")
        static let main90 = main100.withAlphaComponent(90)
        static let main80 = main100.withAlphaComponent(80)
        static let main70 = main100.withAlphaComponent(70)
        static let main60 = main100.withAlphaComponent(60)
        static let main50 = main100.withAlphaComponent(50)
        static let main40 = main100.withAlphaComponent(40)
        static let main30 = main100.withAlphaComponent(30)
        static let main20 = main100.withAlphaComponent(20)
        static let main10 = main100.withAlphaComponent(10)
        
        static let white100 = UIColor(hex: "#FFFFFF")
        static let white90 = white100.withAlphaComponent(90)
        static let white80 = white100.withAlphaComponent(80)
        static let white70 = white100.withAlphaComponent(70)
        static let white60 = white100.withAlphaComponent(60)
        static let white50 = white100.withAlphaComponent(50)
        static let white40 = white100.withAlphaComponent(40)
        static let white30 = white100.withAlphaComponent(30)
        static let white20 = white100.withAlphaComponent(20)
        static let white10 = white100.withAlphaComponent(10)
        static let white5 = white100.withAlphaComponent(5)
        
        static let gray50 = UIColor(hex: "#E6EDF8")
        static let gray100 = UIColor(hex: "#D7E1EE")
        static let gray200 = UIColor(hex: "#C8D3E3")
        static let gray300 = UIColor(hex: "#A5B2C5")
        static let gray400 = UIColor(hex: "#7B8696")
        static let gray500 = UIColor(hex: "#5D6470")
        static let gray600 = UIColor(hex: "#3D424B")
        static let gray700 = UIColor(hex: "#2A2F38")
        static let gray800 = UIColor(hex: "#1F2127")
        static let gray900 = UIColor(hex: "#17191F")
        
        // Status
        static let statusAlert = UIColor(hex: "#F2544A")
        static let statusAlertPressed = UIColor(hex: "#E53D33")
        static let statusAlert50 = statusAlert.withAlphaComponent(50)
        static let statusAlert20 = statusAlert.withAlphaComponent(20)
        
        static let statusSuccess = UIColor(hex: "#22C55E")
        static let statusSuccess50 = statusSuccess.withAlphaComponent(50)
        
        // TXT
        static let textPrimary = UIColor(hex: "#FFFFFF")
        static let textPrimaryInvert = UIColor(hex: "#17191F")
        static let textSecondary = UIColor(hex: "#E6EDF8")
        static let textTertiary = UIColor(hex: "#A5B2C5")
        // disabled는 문의 후 추가 예정
        
        // Ico
        static let icoPrimary = UIColor(hex: "#FFFFFF")
        static let icoPrimaryInvert = UIColor(hex: "#17191F")
        static let icoSecondary = UIColor(hex: "#A5B2C5")
        static let icoTertiary = UIColor(hex: "#7B8696")
        static let icoPlaceholder = UIColor(hex: "#5D6470")
        static let icoDisabled = UIColor(hex: "#2A2F38")
        
        // BG
        static let bg = UIColor(hex: "#17191F")
        static let bgLight = UIColor(hex: "#E6EDF8")
        static let bgBottomSheet = UIColor(hex: "#17191F")
        static let bgModal = UIColor(hex: "#1F2127")
        static let bgToast = UIColor(hex: "#3D424B")
        
        // Btn
        static let btnPrimary = UIColor(hex: "#FEFF65")
        static let btnSecondary = UIColor(hex: "#3D424B")
        static let btnDisabled = UIColor(hex: "#2A2F38")
        
        // Line
        static let line = UIColor(hex: "#2A2F38")
    }
}

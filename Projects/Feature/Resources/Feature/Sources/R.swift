import UIKit

public class R {
    public struct Image {
        public static let svgBtnAdd = UIImage(named: "svg_btn_add", in: .resources, compatibleWith: nil)
    }
    
    public struct Sound {
        public static let alarm = Bundle.resources.url(forResource: "crowded_cafe", withExtension: "caf")!
    }
}

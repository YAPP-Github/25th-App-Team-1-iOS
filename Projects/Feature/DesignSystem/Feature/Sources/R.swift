import UIKit

public struct R {
    public class Image {
        public static let svgBtnAdd = UIImage(named: "svg_btn_add", in: Bundle(for: R.Image.self), compatibleWith: nil)
    }
    
    public class Sound {
        public static let alarm = Bundle(for: R.Sound.self).url(forResource: "crowded_cafe", withExtension: "caf")!
    }
}

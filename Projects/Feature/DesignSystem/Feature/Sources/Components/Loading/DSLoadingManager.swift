//
//  DSLoadingManager.swift
//  DesignSystem
//
//  Created by AI Assistant on 2/10/25.
//

import UIKit
import SnapKit

public final class DSLoadingManager {
    public static let shared = DSLoadingManager()
    
    private var loadingView: DSDefaultLoadingView?
    
    private init() {}
    
    public func show() {
        // 이미 로딩이 표시되고 있다면 무시
        guard loadingView == nil else { return }
        
        // 키윈도우 찾기
        guard let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        // 로딩뷰 생성 및 키윈도우에 직접 추가
        let loading = DSDefaultLoadingView()
        keyWindow.addSubview(loading)
        loading.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 참조 저장
        loadingView = loading
        
        // 애니메이션 시작
        loading.play()
    }
    
    public func hide() {
        guard let loading = loadingView else { return }
        
        // 애니메이션 정지
        loading.stop()
        
        // 뷰 제거
        loading.removeFromSuperview()
        
        // 참조 제거
        loadingView = nil
    }
}

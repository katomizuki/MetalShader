//
//  ContentView.swift
//  MetalShader
//
//  Created by ミズキ on 2022/12/01.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MetalShaderView().ignoresSafeArea(.all)
    }
}

struct MetalShaderView: UIViewRepresentable {
    typealias UIViewType = CustomMetalView
    
    func makeUIView(context: Context) -> CustomMetalView {
        let mtkView = CustomMetalView(frame: .zero, device: MTLCreateSystemDefaultDevice()!)
        return mtkView
    }
    
    func updateUIView(_ uiView: CustomMetalView, context: Context) {
    }
    
    func makeCoordinator() -> () {
        
    }
}

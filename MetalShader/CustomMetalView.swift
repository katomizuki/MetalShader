//
//  CustomMetalView.swift
//  MetalShader
//
//  Created by ミズキ on 2022/12/01.
//

import MetalKit

class CustomMetalView: MTKView {
    
    private let renderer = Renderer.shared
    private let semaphore = DispatchSemaphore(value: 1)
    private var commandQueue: MTLCommandQueue!
    private var pipelineState: MTLRenderPipelineState!
    private var volumeLevel: Float = 0.0
    private var touched = CGPoint(x: 0.0, y: 0.0)
    private let scaleFactor = UIScreen.main.scale
    private let startDate = Date()
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        self.delegate = self
        depthStencilPixelFormat = .invalid
        framebufferOnly = false
        commandQueue = renderer.device.makeCommandQueue()!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = renderer.vertexFunction
        pipelineDescriptor.fragmentFunction = renderer.fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try! renderer.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touched = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touched = touch.location(in: self)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomMetalView: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        renderer.updateResolution(width: Float(size.width), height: Float(size.height))
    }
    
    func draw(in view: MTKView) {
        semaphore.wait(timeout: .distantFuture)
        guard let renderPassDesicriptor = currentRenderPassDescriptor,
              let currentDrawable = currentDrawable,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDesicriptor) else {
            semaphore.signal()
            return
        }
        renderer.updateTime(Float(Date().timeIntervalSince(startDate)))
//        renderer.updateVolume(volumeLevel)
        renderer.updatetouchedPosition(x: Float(scaleFactor * touched.x), y: Float(scaleFactor * touched.y))

        renderEncoder.setRenderPipelineState(pipelineState)

        renderEncoder.setFragmentBuffer(renderer.resolutionBuffer, offset: 0, index: 0)
        renderEncoder.setFragmentBuffer(renderer.timeBuffer, offset: 0, index: 1)
        renderEncoder.setFragmentBuffer(renderer.volumeBuffer, offset: 0, index: 2)
        renderEncoder.setFragmentBuffer(renderer.touchedPositionBuffer, offset: 0, index: 3)
        
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        renderEncoder.endEncoding()

        commandBuffer.addScheduledHandler { [weak self] (_) in
          guard let self = self else { return }
         self.semaphore.signal()
        }

        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}


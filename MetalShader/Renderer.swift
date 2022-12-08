//
//  Renderer.swift
//  MetalShader
//
//  Created by ミズキ on 2022/12/01.
//

import Metal
import simd

typealias Acceleration = SIMD3<Float>

class Renderer {
    static let shared = Renderer()
    let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    var library: MTLLibrary!
    lazy var vertexFunction: MTLFunction = library.makeFunction(name: "vertex_main")!
    lazy var fragmentFunction: MTLFunction = library.makeFunction(name: "twoMetal")!
    
    var resolutionBuffer: MTLBuffer!
    var timeBuffer: MTLBuffer!
    var volumeBuffer: MTLBuffer!
    var accelerationBuffer: MTLBuffer!
    var touchedPositionBuffer: MTLBuffer!
    
    private init() {
        library = device.makeDefaultLibrary()
        setupBuffers()
    }
    
    func setupBuffers() {
        resolutionBuffer = device.makeBuffer(length: 2 * MemoryLayout<Float>.size, options: [])
        timeBuffer = device.makeBuffer(length: MemoryLayout<Float>.size, options: [])
        volumeBuffer = device.makeBuffer(length: MemoryLayout<Float>.size, options: [])
        accelerationBuffer = device.makeBuffer(length: MemoryLayout<Acceleration>.size, options: [])
        touchedPositionBuffer = device.makeBuffer(length: 2 * MemoryLayout<Float>.size, options: [])
    }
    
    func updateResolution(width: Float, height: Float) {
        memcpy(resolutionBuffer.contents(), [width, height], MemoryLayout<Float>.size * 2)
    }
    
    func updateTime(_ time: Float) {
       updateBuffer(time, timeBuffer)
    }
    
    func updateVolume(_ volume: Float) {
       updateBuffer(volume, volumeBuffer)
    }
    
    func updateAcceleration(_ acceleration: Acceleration) {
       updateBuffer(acceleration, accelerationBuffer)
    }
    
    func updatetouchedPosition(x: Float, y: Float) {
        memcpy(touchedPositionBuffer.contents(), [x,y], MemoryLayout<Float>.size * 2)
    }
    
    func updateBuffer<T>(_ data: T, _ buffer: MTLBuffer) {
        let pointer = buffer.contents()
        let value = pointer.bindMemory(to: T.self, capacity: 1)
        value[0] = data
    }
}

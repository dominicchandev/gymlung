//
//  CameraView.swift
//  GymLung
//
//  Created by Chan Tin Lok on 28/2/2026.
//

import SwiftUI
import AVFoundation
import UIKit

// MARK: - SwiftUI Camera Scanner View

struct CameraView: View {
    var onCapture: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss
    @StateObject private var camera = CameraModel()
    @State private var scanLineOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Camera preview
            CameraPreviewLayer(session: camera.session)
                .ignoresSafeArea()

            // Dark overlay with cutout
            scannerOverlay

            // UI controls
            VStack {
                // Top bar
                topBar
                Spacer()
                // Bottom bar
                bottomBar
            }
        }
        .onAppear {
            camera.configure()
        }
        .onDisappear {
            camera.stop()
        }
        .onChange(of: camera.capturedImage) { _, image in
            if let image {
                onCapture(image)
                dismiss()
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(.black.opacity(0.4)))
            }
            Spacer()
            Text("掃描食物")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            Button {
                camera.toggleFlash()
            } label: {
                Image(systemName: camera.flashOn ? "bolt.fill" : "bolt.slash.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(camera.flashOn ? .yellow : .white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(.black.opacity(0.4)))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    // MARK: - Scanner Overlay

    private var scannerOverlay: some View {
        GeometryReader { geo in
            let scanSize = geo.size.width - 60
            let scanRect = CGRect(
                x: 30,
                y: (geo.size.height - scanSize) / 2 - 40,
                width: scanSize,
                height: scanSize
            )

            // Dimmed area with cutout
            ZStack {
                // Semi-transparent overlay
                Rectangle()
                    .fill(.black.opacity(0.5))
                    .mask(
                        ZStack {
                            Rectangle()
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: scanRect.width, height: scanRect.height)
                                .position(
                                    x: scanRect.midX,
                                    y: scanRect.midY
                                )
                                .blendMode(.destinationOut)
                        }
                        .compositingGroup()
                    )

                // Corner brackets
                cornersView(rect: scanRect)

                // Scan line
                RoundedRectangle(cornerRadius: 1)
                    .fill(
                        LinearGradient(
                            colors: [Theme.neonGreen.opacity(0), Theme.neonGreen, Theme.neonGreen.opacity(0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: scanRect.width - 32, height: 2)
                    .shadow(color: Theme.neonGreen.opacity(0.6), radius: 8)
                    .position(x: scanRect.midX, y: scanRect.minY + 16 + scanLineOffset)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true)
                        ) {
                            scanLineOffset = scanRect.height - 32
                        }
                    }

                // Hint text
                Text("將食物放入框內")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .position(x: scanRect.midX, y: scanRect.maxY + 32)
            }
        }
        .ignoresSafeArea()
    }

    private func cornersView(rect: CGRect) -> some View {
        let length: CGFloat = 28
        let lineWidth: CGFloat = 3.5
        let color = Theme.neonGreen

        return ZStack {
            // Top-left
            CornerBracket(length: length, lineWidth: lineWidth, color: color)
                .position(x: rect.minX, y: rect.minY)

            // Top-right
            CornerBracket(length: length, lineWidth: lineWidth, color: color)
                .rotationEffect(.degrees(90))
                .position(x: rect.maxX, y: rect.minY)

            // Bottom-right
            CornerBracket(length: length, lineWidth: lineWidth, color: color)
                .rotationEffect(.degrees(180))
                .position(x: rect.maxX, y: rect.maxY)

            // Bottom-left
            CornerBracket(length: length, lineWidth: lineWidth, color: color)
                .rotationEffect(.degrees(270))
                .position(x: rect.minX, y: rect.maxY)
        }
    }

    // MARK: - Bottom Bar

    private var bottomBar: some View {
        VStack(spacing: 16) {
            // Capture button
            Button {
                camera.capture()
            } label: {
                ZStack {
                    Circle()
                        .stroke(.white, lineWidth: 4)
                        .frame(width: 72, height: 72)
                    Circle()
                        .fill(.white)
                        .frame(width: 60, height: 60)
                }
            }
        }
        .padding(.bottom, 40)
    }
}

// MARK: - Corner Bracket Shape

private struct CornerBracket: View {
    let length: CGFloat
    let lineWidth: CGFloat
    let color: Color

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: length))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: length, y: 0))
        }
        .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
        .frame(width: length, height: length)
        .shadow(color: color.opacity(0.5), radius: 6)
    }
}

// MARK: - Camera Model

@MainActor
final class CameraModel: NSObject, ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var flashOn = false

    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var device: AVCaptureDevice?

    func configure() {
        guard session.inputs.isEmpty else {
            session.startRunning()
            return
        }

        session.beginConfiguration()
        session.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            session.commitConfiguration()
            return
        }

        device = camera

        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(output) { session.addOutput(output) }

        session.commitConfiguration()

        Task.detached { [session] in
            session.startRunning()
        }
    }

    func stop() {
        Task.detached { [session] in
            session.stopRunning()
        }
    }

    func capture() {
        let settings = AVCapturePhotoSettings()
        if let device, device.hasTorch {
            settings.flashMode = flashOn ? .on : .off
        }
        output.capturePhoto(with: settings, delegate: self)
    }

    func toggleFlash() {
        flashOn.toggle()
    }
}

extension CameraModel: AVCapturePhotoCaptureDelegate {
    nonisolated func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        Task { @MainActor in
            self.capturedImage = image
        }
    }
}

// MARK: - Camera Preview (UIViewRepresentable)

struct CameraPreviewLayer: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(preview)
        context.coordinator.previewLayer = preview
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            context.coordinator.previewLayer?.frame = uiView.bounds
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
}

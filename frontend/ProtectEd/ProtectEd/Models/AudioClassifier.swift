import CoreML
import SoundAnalysis
import AVFoundation

class AudioClassifier: NSObject, SNResultsObserving, ObservableObject {
    private var analyzer: SNAudioStreamAnalyzer?
    private var inputFormat: AVAudioFormat?
    var audioEngine: AVAudioEngine?
    @Published var amplitude: Float = 0.0
    @Published var detectedSound: String = "Unknown"
    @Published var confidence: Double = 0.0

    override init() {
        super.init()
    }
    
    func start() {
        setupAudioEngine()
        setupAnalyzer()
    }
    
    
    func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else { return }

        inputFormat = audioEngine.inputNode.outputFormat(forBus: 0)

        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { buffer, time in
            self.analyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
        }

        do {
            try audioEngine.start()
        } catch {
            print("Audio engine could not start: \(error.localizedDescription)")
        }
    }

    func setupAnalyzer() {
        guard let inputFormat = inputFormat else { return }

        analyzer = SNAudioStreamAnalyzer(format: inputFormat)

        do {
            let mlModel = try Gunshot(configuration: MLModelConfiguration())
            let request = try SNClassifySoundRequest(mlModel: mlModel.model)
            try analyzer?.add(request, withObserver: self)
        } catch {
            print("Error setting up analyzer: \(error.localizedDescription)")
        }
    }

    // Update classification results and publish changes
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }
        if let bestClassification = result.classifications.first {
            DispatchQueue.main.async {
                self.detectedSound = bestClassification.identifier
                self.confidence = bestClassification.confidence
            }
            //print("Detected sound: \(bestClassification.identifier) with confidence: \(bestClassification.confidence)")
        }
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Failed with error: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("Request completed successfully!")
    }
    
    func stopListening() {
        // Remove the tap on the input node to stop receiving audio buffers
        audioEngine?.inputNode.removeTap(onBus: 0)
        
        // Stop the audio engine
        audioEngine?.stop()
        
        // Remove all requests from the analyzer and deinitialize it
        analyzer = nil
        
        // Optionally, reset the detected sound and confidence
        DispatchQueue.main.async {
            self.detectedSound = "Unknown"
            self.confidence = 0.0
        }
        
        print("Audio classification has been stopped.")
    }

}

//
//  ChatbotViewModel.swift
//  AcademyLifeFE
//
//  Created by SeYeong's MacBook on 12/11/24.
//

import SwiftUI
import Alamofire
import AVFoundation
import SVProgressHUD

class ChatbotViewModel: NSObject, ObservableObject {
    @Published var messages: [Message] = []
    @Published var isProcessing = false
    @Published var isRecording = false
    @Published var isPlaying = false
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    let azureOpenAIEndpoint = AppConfig.azureOpenAIDomain
    let azureOpenAIKey = AppConfig.apiKeyAzureOpenAI
    let azureSTTEndpoint = AppConfig.azureSTTDomain
    let azureTTSEndpoint = AppConfig.azureTTSDomain
    let azureSpeechKey = AppConfig.apiKeyAzureSpeechService
    
    private let audioFileName = "recording.wav"
    
    // 질문: STT 녹음하기
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        let audioFilename = FileManager.default.temporaryDirectory.appendingPathComponent(audioFileName)
     
        print(audioFilename)
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM), // WAV 포맷
            AVSampleRateKey: 16000,                   // 샘플 레이트: 16kHz
            AVNumberOfChannelsKey: 1,                 // 채널 수: 모노
            AVLinearPCMBitDepthKey: 16,               // 비트 깊이: 16비트
            AVLinearPCMIsBigEndianKey: false,         // 엔디안 설정: Little Endian
            AVLinearPCMIsFloatKey: false              // 정수 포맷
        ]
        
        do {
            SVProgressHUD.show()
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
           
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            isRecording = true
            
            SVProgressHUD.dismiss()
            print("Recording started")
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        isProcessing = true
        transcribeAudio()
    }
    
    // 음성파일을 업로드해 분석 및 텍스트로 변환
    func transcribeAudio() {
        SVProgressHUD.show()
        
        guard let audioURL = audioRecorder?.url else { return }
        let url = "https://\(azureSTTEndpoint)"
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": azureSpeechKey,
            "Content-Type": "audio/wav"
        ]
        
        AF.upload(audioURL, to: url, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: STTResponse.self) { response in
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let sttResponse):
                    if let text = sttResponse.DisplayText {
                        self.sendMessage(content: text)
                    }
                case .failure(let error):
                    print("STT Error: \(error.localizedDescription)")
                }
            }
    }
    
    // 챗봇 응답: TTS 음성 재생하기
    func convertTextToSpeech(text: String) {
        let url = "https://\(azureTTSEndpoint)"
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": azureSpeechKey,
            "Content-Type": "application/ssml+xml",
            "X-Microsoft-OutputFormat": "riff-16khz-16bit-mono-pcm"
        ]
        
        let ssml = """
        <speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='ko-KR'>
            <voice name='ko-KR-SunHiNeural'>\(text)</voice>
        </speak>
        """
        
        let audioFilename = FileManager.default.temporaryDirectory.appendingPathComponent("response.wav")
        
        AF.upload(ssml.data(using: .utf8)!, to: url, headers: headers)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        try data.write(to: audioFilename)
                        self.playAudio(from: audioFilename)
                    } catch {
                        print("TTS Audio Save Error: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("TTS Error: \(error.localizedDescription)")
                    
                }
            }
    }
    

    

    
    func playAudio(from url: URL) {
        SVProgressHUD.show()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            isPlaying = true
        } catch {
            print("Audio Playback Error: \(error.localizedDescription)")
        }
    }
    
    func stopAudio(){
        if isPlaying {
            audioPlayer?.stop()
            isPlaying = false
            isProcessing = false
        }
    }
    
    func sendMessage(content: String) {
        SVProgressHUD.show()
        
        let url = "https://\(azureOpenAIEndpoint)"
        let messages: [[String: String]] = [
            ["role": "user", "content": content]
        ]
        
        let params: Parameters = [
            "messages": messages,
            "max_tokens": 100
        ]
        let headers: HTTPHeaders = [
            "api-key": "\(azureOpenAIKey)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ChatbotRoot.self) { response in
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let root):
                    if let assistantMessage = root.choices.first?.message.content {
                        DispatchQueue.main.async {
                            self.messages.append(Message(role: "user", content: content))
                            self.messages.append(Message(role: "assistant", content: assistantMessage))
                            //                                    self.convertTextToSpeech(text: assistantMessage)
                        }
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    
}



extension ChatbotViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isProcessing = false
    }
}

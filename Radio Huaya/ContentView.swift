//
//  ContentView.swift
//  Radio Huaya
//
//  Created by Jose Cesar on 6/17/24.
//

import SwiftUI
import AVFoundation
import MediaPlayer


class AudioPlayer:ObservableObject{
    
    static let shared = AudioPlayer()
    
    var player: AVPlayer?
    
    func play()
    {
        player = AVPlayer(playerItem: AVPlayerItem(url: URL(string: "http://192.100.196.218:8000/xhfce?fbclid=IwAR2wYi1c4EdH1eMfv2cyr00fm58it0rlGF4PMkcNT5LXG2HC6YSSai2JIGM")!))
        player?.play()
        updateNowPlayingInfo()
    }
    
    func pause()
    {
        player?.pause()
        updateNowPlayingInfo()
    }
    
    private func updateNowPlayingInfo()
    {
        
        guard let player = player, let currentItem = player.currentItem else {return}
        
        let info: [String: Any] = [
            
            MPMediaItemPropertyTitle : "Radio Huaya",
            MPMediaItemPropertyArtist: "Radio Huaya",
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: CGSize(width:300, height: 300)){_ in UIImage(named:"radiohuaya")!},
            MPMediaItemPropertyAlbumTitle: "Radio Huaya",
            
            
            
        ]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
}


struct ContentView: View {
    
    
    @ObservedObject var player = AudioPlayer.shared
    
  
    //@State var player = AVPlayer(url: URL(string: "http://192.100.196.218:8000/xhfce?fbclid=IwAR2wYi1c4EdH1eMfv2cyr00fm58it0rlGF4PMkcNT5LXG2HC6YSSai2JIGM")!)
        
  
    @State var isPlayHidden = false
    @State var isPauseHidden = true
   
    

   
    
    var body: some View {
        
    
        
        VStack {
            
            
            Spacer()
            
            
            
            Image(.radiohuaya)
                .resizable()
                .padding(.bottom, 20.0)
                .imageScale(.small)
                .aspectRatio(contentMode: .fit)
                .frame(width: 500.0, height: 500.0)
                .foregroundStyle(.tint)
            
            
            if !isPlayHidden {
                
                Button("Escuchar", systemImage: "play", action:{
                    
                    //try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    //try! AVAudioSession.sharedInstance().setActive(true)
                    
                    player.play()
                   // player.isMuted=false
                    isPauseHidden=false
                    isPlayHidden=true
                    
                    
                })
                    .labelStyle(.titleAndIcon).buttonStyle(.borderedProminent)
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
            }
            
            if !isPauseHidden {
                
                Button("Pausar", systemImage: "pause", action:{
                    
                    //player.isMuted=true
                    
                    //player.pause()
                    player.pause()
                
                    
                    isPauseHidden=true
                    isPlayHidden=false
                    
                    
                    
                })
                .labelStyle(.titleAndIcon).buttonStyle(.borderedProminent)
                .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                
            }
        
            Spacer()
            
        }
        .background(.white)
        .frame(
           
         
            maxHeight: .infinity
         
          )
        .onAppear{
            
            do{
                try AVAudioSession.sharedInstance().setCategory(.playback,mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                setupRemoteControls()
            }
            catch{
                print("Error at initialize Background Audio Session")
            }
        }
       
    }
    
    private func setupRemoteControls()
    {
        let commands = MPRemoteCommandCenter.shared()
        
        commands.pauseCommand.addTarget{_ in
            
            player.pause()
            return.success
            
        }
        commands.playCommand.addTarget{_ in
                                       player.play()
                                       return.success
                                       }
    }
}

#Preview {
    ContentView()
}

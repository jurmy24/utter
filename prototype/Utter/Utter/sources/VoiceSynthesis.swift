//
//  VoiceSynthesis.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-23.
//

//import Foundation
//import AWSCore
//import AWSMobileClientXCF
//import AVFoundation
//import AWSPolly

//// Region of Amazon Polly.
//let AwsRegion = AWSRegionType.EUCentral1
// 
//// Cognito pool ID. Pool needs to be unauthenticated pool with
//// Amazon Polly permissions.
////let CognitoIdentityPoolId = "YourCognitoIdentityPoolId"
// 
//// Initialize the Amazon Cognito credentials provider.
////let credentialProvider = AWSCognitoCredentialsProvider(regionType: AwsRegion, identityPoolId: CognitoIdentityPoolId)
//
//// Create an audio player
//var soundPlayer = AVPlayer()
//
//// Use the configuration as default
//AWSServiceManager.default().defaultServiceConfiguration = configuration
//
//// Get all the voices (no parameters specified in input) from Amazon Polly
//// This creates an async task.
//let task = AWSPolly.default().describeVoices(AWSPollyDescribeVoicesInput())
// 
//// When the request is done, asynchronously do the following block
//// (we ignore all the errors, but in a real-world scenario they need
//// to be handled)
//task.continue(successBlock: { (awsTask: AWSTask) -> Any? in
//      // awsTask.result is an instance of AWSPollyDescribeVoicesOutput in
//      // case of the "describeVoices" method
//      let voices = (awsTask.result! as AWSPollyDescribeVoicesOutput).voices
// 
//      return nil
//})
//
//// First, Amazon Polly requires an input, which we need to prepare.
//// Again, we ignore the errors, however this should be handled in
//// real applications. Here we are using the URL Builder Request,
//// since in order to make the synthesis quicker we will pass the
//// presigned URL to the system audio player.
//let input = AWSPollySynthesizeSpeechURLBuilderRequest()
//
//// Text to synthesize
//input.text = "Sample text"
//
//// We expect the output in MP3 format
//input.outputFormat = AWSPollyOutputFormat.mp3
//
//// Choose the voice ID
//input.voiceId = AWSPollyVoiceId.joanna
//
//// Create an task to synthesize speech using the given synthesis input
//let builder = AWSPollySynthesizeSpeechURLBuilder.default().getPreSignedURL(input)
//
//// Request the URL for synthesis result
//builder.continueOnSuccessWith(block: { (awsTask: AWSTask<NSURL>) -> Any? in
//    // The result of getPresignedURL task is NSURL.
//    // Again, we ignore the errors in the example.
//    let url = awsTask.result!
//
//    // Try playing the data using the system AVAudioPlayer
//    self.audioPlayer.replaceCurrentItem(with: AVPlayerItem(url: url as URL))
//    self.audioPlayer.play()
//
//    return nil
//})

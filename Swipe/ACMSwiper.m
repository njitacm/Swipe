//
//  ACMSwiper.m
//  Swipe
//
//  Created by Grant Butler on 8/24/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMSwiper.h"
#import <AudioToolbox/AudioToolbox.h>
#import <SSToolkit/UIApplication+SSToolkitAdditions.h>
#include "mslib.h"

#define IS_ONE(a, b) (abs(a - b) < abs(a - (b * 2)))

static const int kLastReadLength = 4410;
static const int kNumberBuffers = 3;

@implementation ACMSwiper {
	AudioStreamBasicDescription mDataFormat;
	AudioQueueRef mQueue;
	AudioQueueBufferRef mBuffers[kNumberBuffers];
	UInt32 bufferByteSize;
	SInt64 mCurrentPacket;
	BOOL isRecording;
	
	NSMutableData *dataBuffer;
	
	
	BOOL noiseDetected;
	NSTimeInterval swipeOffset;

//	ACMAudioInputStream *inputStream;
//	
//	short zerolvl;
//	short posthres, negthres, delta;
//	uint8_t lastRead[kLastReadLength];
//	
//	AVAudioRecorder *_recorder;
}

static void HandleInputBuffer(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc) {
	@autoreleasepool {
		ACMSwiper *inputStream = (__bridge ACMSwiper *)aqData;
		
		[inputStream->dataBuffer appendData:[NSData dataWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize]];
		
//		if() {
//			
//		}
		
		if(inputStream->isRecording) {
			AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
		}
	}
}

void DeriveBufferSize(AudioQueueRef audioQueue, AudioStreamBasicDescription ASBDescription, Float64 seconds, UInt32 *outBufferSize) {
    static const int maxBufferSize = 0x50000;
	
    int maxPacketSize = ASBDescription.mBytesPerPacket;
    if (maxPacketSize == 0) {
        UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
        AudioQueueGetProperty(audioQueue, kAudioQueueProperty_MaximumOutputPacketSize, &maxPacketSize, &maxVBRPacketSize);
    }
	
    Float64 numBytesForTime = ASBDescription.mSampleRate * maxPacketSize * seconds;
    *outBufferSize = (UInt32)(numBytesForTime < maxBufferSize ? numBytesForTime : maxBufferSize);
}

- (id)init {
	if((self = [super init])) {
//		inputStream = [[ACMAudioInputStream alloc] init];
		
//		NSURL *fileURL = [[[UIApplication sharedApplication] documentsDirectoryURL] URLByAppendingPathComponent:@"card.wav"];
//		
//		_recorder = [AVAudioRecorder alloc];
//		
//		NSError *error = nil;
//		
//		if(![_recorder initWithURL:fileURL settings:@{
//					 AVFormatIDKey: @(kAudioFormatLinearPCM),
//				   AVSampleRateKey: @44100.0,
//			 AVNumberOfChannelsKey: @1,
//		 AVLinearPCMIsBigEndianKey: @(NO),
//			 AVLinearPCMIsFloatKey: @(NO),
//	   AVLinearPCMIsNonInterleaved: @(YES),
//			AVLinearPCMBitDepthKey: @16
//			 } error:&error]) {
//			NSLog(@"%@", error);
//			
//			_recorder = nil;
//			
//			return nil;
//		}
//		
//		_recorder.delegate = self;
//		_recorder.meteringEnabled = YES;
		
		mDataFormat.mFormatID = kAudioFormatLinearPCM;
		mDataFormat.mSampleRate = 44100.0;
		mDataFormat.mChannelsPerFrame = 1;
		mDataFormat.mBitsPerChannel = 16;
		mDataFormat.mBytesPerFrame = mDataFormat.mChannelsPerFrame * sizeof(SInt16);
		mDataFormat.mBytesPerPacket = mDataFormat.mBytesPerFrame;
		mDataFormat.mFramesPerPacket = 1;
		mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
		
		AudioQueueNewInput(&mDataFormat, HandleInputBuffer, (__bridge void *)self, NULL, kCFRunLoopCommonModes, 0, &mQueue);
		
		UInt32 dataFormatSize = sizeof(mDataFormat);
		AudioQueueGetProperty(mQueue, kAudioQueueProperty_StreamDescription, &mDataFormat, &dataFormatSize);
		
		UInt32 meteringEnabled = 1;
		AudioQueueSetProperty(mQueue, kAudioQueueProperty_EnableLevelMetering, &meteringEnabled, sizeof(meteringEnabled));
		
		DeriveBufferSize(mQueue, mDataFormat, 0.5, &bufferByteSize);
		
		for (int i = 0; i < kNumberBuffers; ++i) {
			AudioQueueAllocateBuffer(mQueue, bufferByteSize, &mBuffers[i]);
			
			AudioQueueEnqueueBuffer(mQueue, mBuffers[i], 0, NULL);
		}
		
		dataBuffer = [[NSMutableData alloc] init];
	}
	
	return self;
}

//- (void)processAudioData {
//	@autoreleasepool {
//		BOOL trackDetected = NO;
//		int inNoiseLevel = 0;
//		NSMutableData *dataBuffer = [[NSMutableData alloc] init];
//		int min = 65535; int max = -65535; int quartersecs = 0;
//		
//		[inputStream.inputStream read:lastRead maxLength:kLastReadLength];
//		
//		while(true) {
//			if(![inputStream.inputStream hasBytesAvailable]) {
//				[NSThread sleepForTimeInterval:0.1];
//				
//				continue;
//			}
//			
//			uint8_t buf[22050];
//			
//			NSInteger bytesRead = [inputStream.inputStream read:buf maxLength:sizeof(buf)];
//			
//			SInt16 *bytes = (SInt16 *)buf;
//			NSInteger length = bytesRead / sizeof(SInt16);
//			
//			for(int i = 0; i < length; i++) {
//				SInt16 val = bytes[i];
//				
//				if((!trackDetected && val > posthres) || (!trackDetected && val < negthres)) {
//					trackDetected = YES;
//					
//					min = 65535; max = -65535; quartersecs = 0;
//					
//					if(i < kLastReadLength) {
//						
//					} else {
//						
//					}
//				}
//			}
//		}
//	}
//}

//- (void)processSwipe {
//	SInt16 *rawPCMData = (SInt16 *)[pcmData bytes];
//	NSUInteger length = [pcmData length] / sizeof(SInt16);
//
//	for(int i = 0; i < length; i++) {
//		rawPCMData[i] -= normOffset;
//	}
//	
//	msData *ms = ms_create(rawPCMData, length);
//	
//	ms_set_peakThreshold(ms, silenceThreshold);
//	
//	ms_peaks_find(ms);
//	
//	ms_peaks_filter_group(ms);
//	
//	ms_decode_peaks(ms);
//	ms_decode_bits(ms);
//	
//	const char *tmpStr = ms_get_charStream(ms);
//	
//	if(tmpStr) {
//		NSString *charValue = [NSString stringWithUTF8String:tmpStr];
//		
//		NSLog(@"%@", charValue);
//	}
//	
//	ms = ms_free(ms);
//	
//	[pcmData setLength:0];
//}

- (void)monitorLevels {
	@autoreleasepool {
		do {
//			[_recorder updateMeters];
//			
//			float level = [_recorder averagePowerForChannel:0];
//			
//			if(level < -50) {
//				if(noiseDetected) {
//					[self stop];
//					
//					break;
//				}
//			} else {
//				if(!noiseDetected) {
//					swipeOffset = [_recorder currentTime];
//				}
//				
//				noiseDetected = YES;
//			}
//		} while([_recorder isRecording]);
			AudioQueueLevelMeterState state;
			UInt32 size = sizeof(state);
			AudioQueueGetProperty(mQueue , kAudioQueueProperty_CurrentLevelMeter, &state, &size);
			
			if(state.mAveragePower > 0.001) {
				if(noiseDetected) {
					[self stop];
					
					break;
				}
			} else {
				if(!noiseDetected) {
					noiseDetected = YES;
				}
			}
			
			NSLog(@"%f", state.mAveragePower);
		} while(isRecording);
	}
}

- (void)start {
	isRecording = YES;
	
	UInt32 category = kAudioSessionCategory_PlayAndRecord;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
	
	AudioSessionSetActive(true);
	
	AudioQueueStart(mQueue, NULL);
	
//	[inputStream start];
//	
//	[self performSelectorInBackground:@selector(processAudioData) withObject:nil];
//	
//	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//	
//	[[AVAudioSession sharedInstance] setActive:YES error:nil];
//	
//	[_recorder record];
//
	[self performSelectorInBackground:@selector(monitorLevels) withObject:nil];
}

- (void)stop {
//	[inputStream stop];
//	
//	[_recorder stop];
	
	isRecording = NO;
	
	AudioQueueStop(mQueue, true);
	
	AudioSessionSetActive(false);
	
	[self processSwipe];
}

//- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
//	if(!flag) {
//		return;
//	}
//	
//	NSData *rawData = [NSData dataWithContentsOfURL:recorder.url];
//	NSRange location = [rawData rangeOfData:[@"data" dataUsingEncoding:NSUTF8StringEncoding] options:0 range:NSMakeRange(0, [rawData length])];
//	NSInteger dataStartIndex = NSMaxRange(location) + sizeof(UInt32) + (44100.0 * (swipeOffset - 0.2) * sizeof(SInt16));
//	
//	NSData *pcmData = [rawData subdataWithRange:NSMakeRange(dataStartIndex, [rawData length] - dataStartIndex)];
	
- (void)processSwipe {
	SInt16 *data = (SInt16 *)[dataBuffer bytes];
	NSInteger dataLength = [dataBuffer length] / sizeof(SInt16);
	
//	[pcmData writeToURL:recorder.url atomically:YES];
	
//	AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:recorder.url options:@{
//			AVURLAssetPreferPreciseDurationAndTimingKey: @(YES)
//						 }];
//	
//	NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeAudio];
//	
//	if(![tracks count]) {
//		return;
//	}
//	
//	AVAssetTrack *track = [tracks objectAtIndex:0];
//	
//	AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:nil];
//	
//	CMTime startTime = CMTimeMakeWithSeconds(swipeOffset - 0.5, 1);
//	
//	reader.timeRange = CMTimeRangeMake(startTime, kCMTimePositiveInfinity);
//	
//	AVAssetReaderTrackOutput *trackReader = [[AVAssetReaderTrackOutput alloc] initWithTrack:track outputSettings:nil];
//	
//	if([reader canAddOutput:trackReader]) {
//		[reader addOutput:trackReader];
//	} else {
//		NSLog(@"Could not add output.");
//		
//		return;
//	}
//	
//	if(![reader startReading]) {
//		NSLog(@"Could not start reading.");
//		
//		return;
//	}
//	
//	NSMutableData *pcmData = [[NSMutableData alloc] init];
//	
//	while(reader.status == AVAssetReaderStatusReading) {
//		CMSampleBufferRef sampleBuffer = [trackReader copyNextSampleBuffer];
//		
//		if(sampleBuffer == NULL) {
//			break;
//		}
//		
//		CMBlockBufferRef buffer = CMSampleBufferGetDataBuffer(sampleBuffer);
//		
//		size_t lengthAtOffset;
//		size_t totalLength;
//		char *data;
//		
//		if(CMBlockBufferGetDataPointer(buffer, 0, &lengthAtOffset, &totalLength, &data)) {
//			break;
//		}
//		
//		[pcmData appendBytes:data length:totalLength];
//		
////		AudioBufferList bufferList;
////		CMBlockBufferRef blockBuffer;
////		
////		CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, NULL, &bufferList, sizeof(bufferList), NULL, NULL, kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, &blockBuffer);
////		
////		for(int i = 0; i < bufferList.mNumberBuffers; i++) {
////			AudioBuffer buffer = bufferList.mBuffers[i];
////			
////			[pcmData appendBytes:buffer.mData length:buffer.mDataByteSize];
////		}
////		
////		CFRelease(blockBuffer);
//		CFRelease(sampleBuffer);
//	}
	
	// most of this code adapted from https://github.com/brandonlw/magstripereader/blob/master/src/com/brandonlw/magstripe/CardDataParser.java
	
	double QUIET_THRESHOLD_FACTOR = 0.4;
	NSMutableString *result = [[NSMutableString alloc] init];
	
	short maxValue = 0;
	for(int i = 0; i < dataLength; i++) {
		if(abs(data[i]) > maxValue) {
			maxValue = (short)abs(data[i]);
		}
	}
	
	int startIndex = 0;
	for(int i = 0; i < dataLength; i++) {
		if(abs(data[i]) > maxValue * QUIET_THRESHOLD_FACTOR) {
			startIndex = i;
			break;
		}
	}
	
	double FACTOR1 = 0.8;
	double FACTOR2 = 0.3;
	double peakThreshold = maxValue * FACTOR2;
	int sign = data[startIndex] >= 0 ? -1 : 1;
	int oldIndex = 0;
	int oldValue = 0;
	NSMutableArray *distances = [NSMutableArray array];
	
	while(startIndex < dataLength) {
		int myValue = 0;
		int myIndex = 0;
		
		while((data[startIndex] * sign) > peakThreshold) {
			if((data[startIndex] * sign) > myValue) {
				myValue = abs(data[startIndex]);
				myIndex = startIndex;
			}
			
			startIndex++;
			
			if(startIndex >= dataLength) {
				break;
			}
		}
		
		if(myValue != 0) {
			if(oldValue != 0) {
				[distances addObject:[NSNumber numberWithInt:myIndex - oldIndex]];
			}
			
			oldValue = myValue;
			oldIndex = myIndex;
			
			sign *= -1;
			peakThreshold = abs(myValue) * FACTOR1;
		}
		
		startIndex++;
	}
	
	if([distances count] > 4) {
		int baselineZeroFrequency = ([[distances objectAtIndex:0] intValue] + [[distances objectAtIndex:1] intValue] + [[distances objectAtIndex:2] intValue] + [[distances objectAtIndex:3] intValue]) / 4;
		
		int index = 4;
		NSMutableArray *bits = [NSMutableArray array];
		
		while(index < [distances count]) {
			int proximityToZero = abs([[distances objectAtIndex:index] intValue] - baselineZeroFrequency);
			int proximityToOne = abs([[distances objectAtIndex:index] intValue] - (baselineZeroFrequency / 2));
			
			if(proximityToOne < proximityToZero) {
				[bits addObject:[NSNumber numberWithChar:1]];
				
				baselineZeroFrequency = [[distances objectAtIndex:index] intValue] * 2;
				
				index++;
			} else {
				[bits addObject:[NSNumber numberWithChar:0]];
				
				baselineZeroFrequency = [[distances objectAtIndex:index] intValue];
			}
			
			index++;
		}
		
		BOOL found = NO;
		int start = 0;
		
		while(start < [bits count] - 3) {
			if([[bits objectAtIndex:start + 0] charValue] == 1 && [[bits objectAtIndex:start + 1] charValue] == 1 && [[bits objectAtIndex:start + 2] charValue] == 0 && [[bits objectAtIndex:start + 3] charValue] == 1) {
				found = YES;
				break;
			}
			
			start++;
		}
		
		if(!found) {
			NSLog(@"Start sentinel not found.");
			
			return;
		} else {
			while(start < [bits count] && (start + 5) < [bits count]) {
				char n = (char)(0x30 + [[bits objectAtIndex:start + 0] charValue] + ([[bits objectAtIndex:start + 1] charValue] * 2) + ([[bits objectAtIndex:start + 2] charValue] * 4) + ([[bits objectAtIndex:start + 3] charValue] * 8));
				
				[result appendFormat:@"%c", n];
				
				if(([[bits objectAtIndex:start + 0] charValue] + [[bits objectAtIndex:start + 1] charValue] + [[bits objectAtIndex:start + 2] charValue] + [[bits objectAtIndex:start + 3] charValue] + [[bits objectAtIndex:start + 4] charValue]) % 2 != 1) {
					NSLog(@"Parity bit check failed on last character read.");
					
					return;
				}
				
				if(n == '?') {
					break;
				}
				
				start += 5;
			}
			
			start += 5;
			
			if([bits count] < start + 5) {
				NSLog(@"Not enough data for LRC check.");
				
				return;
			} else {
				char n = (char)(0x30 + [[bits objectAtIndex:start + 0] charValue] + ([[bits objectAtIndex:start + 1] charValue] * 2) + ([[bits objectAtIndex:start + 2] charValue] * 4) + ([[bits objectAtIndex:start + 3] charValue] * 8));
				
				if(([[bits objectAtIndex:start + 0] charValue] + [[bits objectAtIndex:start + 1] charValue] + [[bits objectAtIndex:start + 2] charValue] + [[bits objectAtIndex:start + 3] charValue] + [[bits objectAtIndex:start + 4] charValue]) % 2 != 1) {
					NSLog(@"LRC parity bit check failed.");
					
					return;
				} else {
					int chars[4];
					
					for(int i = 0; i < [result length]; i++) {
						chars[0] = chars[0] + (([result characterAtIndex:i] >> 3) & 0x01) % 2;
						chars[1] = chars[1] + (([result characterAtIndex:i] >> 2) & 0x01) % 2;
						chars[2] = chars[2] + (([result characterAtIndex:i] >> 1) & 0x01) % 2;
						chars[3] = chars[3] + ([result characterAtIndex:i] & 0x01) % 2;
					}
					
					if(chars[3] != (n & 0x01) || chars[2] != ((n >> 1) & 0x01) || chars[1] != ((n >> 2) & 0x01) || chars[0] != ((n >> 3) & 0x01)) {
						NSLog(@"LRC is invalid.");
						
						return;
					}
				}
			}
		}
	}
	
//	// most of this code adapted from https://github.com/sshipman/RhombusLib/blob/master/src/me/cosmodro/app/rhombus/decoder/AudioDecoder.java
//	
//	int silenceLevel = 500;
//	int minLevel = silenceLevel;
//	double minLevelCoeff = 0.5;
//	
//	short lastval = 0;
//	short val = 0;
//	int peakcount = 0;
//	int peaksum = 0;
//	int peaktemp = 0; //value to store highest peak value between zero crossings
//	BOOL hitmin = NO;
//	
//	for(int i = 0, len = [pcmData length] / sizeof(SInt16); i < len; i++) {
//		[pcmData getBytes:&val range:NSMakeRange(i * sizeof(SInt16), sizeof(SInt16))];
//		
//		if(val > 0 && lastval <= 0) {
//			peaktemp = 0;
//			hitmin = NO;
//		} else if(val < 0 && lastval >= 0 && hitmin) {
//			peaksum += peaktemp;
//			peakcount++;
//		}
//		
//		if((val > 0) && (lastval > val) && (lastval > silenceLevel) && (val > peaktemp)) {
//			hitmin = YES;
//			peaktemp = val;
//		}
//		
//		lastval = val;
//	}
//	
//	if(peakcount > 0) {
//		minLevel = floor((peaksum / peakcount) * minLevelCoeff);
//	} else {
//		minLevel = silenceLevel;
//	}
//	
//	NSMutableArray *bitSet = [[NSMutableArray alloc] init];
//	int resultBitCount = 0;
//	int lastSign = -1;
//	int lasti = 0;
//	short dp;
//	int first = 0;
//	int oneinterval = -1; //interval between transitions for a 1 bit.  There are two transitions per 1 bit, 1 per 0.
//	//so if interval is around 15, then if the space between transitions is 17, 15, that's a 1.  but if that was 32, that'd be 0.
//	//the pattern starts with a self-clocking set of 0s.  We'll discard the first few, just because.
//	int introDiscard = 1;
//	int discardCount = 0;
//	BOOL needHalfOne = NO; //if the last interval was the first half of a 1, the next better be the second half
//	int expectedParityBit = 1; //invert every 1 bit.  parity bit should make number of 1s in group odd.
//	
//	for(int i = 0, len = [pcmData length] / sizeof(SInt16); i < len; i++) {
//		[pcmData getBytes:&dp range:NSMakeRange(i * sizeof(SInt16), sizeof(SInt16))];
//		
//		if((dp * lastSign) < 0 && (abs(dp) > minLevel)) {
//			if(first == 0) {
//				first = i;
//			} else if(discardCount < introDiscard) {
//				discardCount++;
//			} else {
//				int sinceLast = i - lasti;
//				
//				if(oneinterval == -1) {
//					oneinterval = sinceLast / 2;
//				} else {
//					BOOL oz = IS_ONE(sinceLast, oneinterval);
//					
//					if(oz) {
//						oneinterval = sinceLast;
//						
//						if(needHalfOne) {
//							expectedParityBit = 1 - expectedParityBit;
//							
//							[bitSet insertObject:@(YES) atIndex:resultBitCount];
//							resultBitCount++;
//							needHalfOne = NO;
//						} else {
//							needHalfOne = YES;
//						}
//					} else {
//						oneinterval = sinceLast / 2;
//						
//						if(needHalfOne) {
//							break;
//						} else {
//							[bitSet insertObject:@(NO) atIndex:resultBitCount];
//							resultBitCount++;
//						}
//					}
//				}
//			}
//			
//			lasti = i;
//			lastSign *= -1;
//		}
//	}
//	
//	NSUInteger first1 = [bitSet indexOfObject:@(YES)];
//	
//	if(first1 == NSNotFound) {
//		NSLog(@"bad swipe");
//		
//		return;
//	}
//	
//	int sentinel = 0;
//	int exp = 0;
//	int i = first1;
//	
//	for (; i < first1 + 4; i++) {
//		if([[bitSet objectAtIndex:i] boolValue]) {
//			sentinel += 1 << exp;
//		}
//		
//		exp++;
//	}
//	
//	if(sentinel == 11) {
//		
//	} else {
//		for (; i < first1 + 6; i++) {
//			if([[bitSet objectAtIndex:i] boolValue]) {
//				sentinel += 1 << exp;
//			}
//			
//			exp++;
//		}
//		
//		if(sentinel == 5) {
//			
//		} else {
//			NSLog(@"bad swipe");
//			
//			return;
//		}
//	}
//
//	float thresh = 100.0 / 33.0;
//	float silence = max / thresh;
//	
//	int peak = 0;
//	int ppeak = 0;
//	
//	SInt16 *rawPCMData = (SInt16 *)[pcmData bytes];
//	NSUInteger length = [pcmData length] / sizeof(SInt16);
//
////	for(int i = 0; i < length; i++) {
////		rawPCMData[i] -= normOffset;
////	}
//
//	msData *ms = ms_create(rawPCMData, length);
//
////	ms_set_peakThreshold(ms, silenceThreshold);
//
//	ms_peaks_find(ms);
//
//	ms_peaks_filter_group(ms);
//
//	ms_decode_peaks(ms);
//	
//	if(!ms_decode_bits(ms)) {
//		NSLog(@"possible bad swipe");
//	}
//
//	const char *tmpStr = ms_get_charStream(ms);
//
//	if(tmpStr) {
//		NSString *charValue = [NSString stringWithUTF8String:tmpStr];
//
//		NSLog(@"%@", charValue);
//	}
//
//	ms = ms_free(ms);
//	
//	[[AVAudioSession sharedInstance] setActive:NO error:nil];
}

@end

//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<assets_audio_player/AssetsAudioPlayerPlugin.h>)
#import <assets_audio_player/AssetsAudioPlayerPlugin.h>
#else
@import assets_audio_player;
#endif

#if __has_include(<assets_audio_player_web/AssetsAudioPlayerWebPlugin.h>)
#import <assets_audio_player_web/AssetsAudioPlayerWebPlugin.h>
#else
@import assets_audio_player_web;
#endif

#if __has_include(<on_audio_query/OnAudioQueryPlugin.h>)
#import <on_audio_query/OnAudioQueryPlugin.h>
#else
@import on_audio_query;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

#if __has_include(<shared_preferences/FLTSharedPreferencesPlugin.h>)
#import <shared_preferences/FLTSharedPreferencesPlugin.h>
#else
@import shared_preferences;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AssetsAudioPlayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"AssetsAudioPlayerPlugin"]];
  [AssetsAudioPlayerWebPlugin registerWithRegistrar:[registry registrarForPlugin:@"AssetsAudioPlayerWebPlugin"]];
  [OnAudioQueryPlugin registerWithRegistrar:[registry registrarForPlugin:@"OnAudioQueryPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
}

@end

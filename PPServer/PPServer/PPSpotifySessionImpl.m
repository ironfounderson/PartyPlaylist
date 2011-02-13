//
//  PPSpotifySession.m
//  PPServer
//
//  Created by Robert Höglund on 2/11/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPSpotifySessionImpl.h"


extern const uint8_t g_appkey[];
extern const size_t g_appkey_size;

NSError *makeError(sp_error code) {
    NSDictionary *userInfo =
    [NSDictionary dictionaryWithObject:[NSString stringWithUTF8String:sp_error_message(code)] 
                                forKey:NSLocalizedDescriptionKey];
	NSError *err = [NSError errorWithDomain:@"com.spotify" 
                                       code:code 
                                   userInfo:userInfo];
	return err;
}

@interface PPSpotifySessionImpl()
- (void)processEvents;
@property (readonly) audio_fifo_t *audiofifo;
@end

#pragma mark -
#pragma mark Callbacks

static PPSpotifySessionImpl *sessobj(sp_session *session) {
	return (PPSpotifySessionImpl *)sp_session_userdata(session);
}

static void logged_in(sp_session *session, sp_error error) {
	NSObject<PPSpotifySessionDelegate> *delegate = sessobj(session).delegate;
	NSError *err = SP_ERROR_OK == error ? nil : makeError(error);
    if (err) {
        if([delegate respondsToSelector:@selector(session:loginFailedWithError:)]) {
            [delegate session:sessobj(session) loginFailedWithError:err];
        }
    }
    else {
        if([delegate respondsToSelector:@selector(sessionLoggedIn:)]) {
            [delegate sessionLoggedIn:sessobj(session)];
        }
        
    }
}

static void logged_out(sp_session *session) {
	NSObject<PPSpotifySessionDelegate> *delegate = sessobj(session).delegate;
	if([delegate respondsToSelector:@selector(sessionLoggedOut:)]) {
		[delegate sessionLoggedOut:sessobj(session)];
    }
}

static void metadata_updated(sp_session *session) {
	NSObject<PPSpotifySessionDelegate> *delegate = sessobj(session).delegate;
	if([delegate respondsToSelector:@selector(sessionUpdatedMetadata:)])
		[delegate sessionUpdatedMetadata:sessobj(session)];
}

static void connection_error(sp_session *session, sp_error error) {
	NSObject<PPSpotifySessionDelegate> *delegate = sessobj(session).delegate;
	NSError *err = SP_ERROR_OK == error ? nil : makeError(error);
	if([delegate respondsToSelector:@selector(session:connectionError:)]) {
		[delegate session:sessobj(session) connectionError:err];
    }
}

static void message_to_user(sp_session *session, const char *message) {
	NSObject<PPSpotifySessionDelegate> *delegate = sessobj(session).delegate;
	NSString *msg = [NSString stringWithUTF8String:message];
	if([delegate respondsToSelector:@selector(session:hasMessageToUser:)]) {
		[delegate session:sessobj(session) hasMessageToUser:msg];
    }
}

static void notify_main_thread(sp_session *session) {
	[sessobj(session) performSelectorOnMainThread:@selector(processEvents) 
                                       withObject:nil 
                                    waitUntilDone:NO];
}


static int music_delivery(sp_session *sess, const sp_audioformat *format,
                          const void *frames, int num_frames) {
	audio_fifo_t *af = sessobj(sess).audiofifo;
	audio_fifo_data_t *afd = NULL;
	size_t s;
    
	if (num_frames == 0)
		return 0; // Audio discontinuity, do nothing
    
	pthread_mutex_lock(&af->mutex);
    
	// Buffer one second of audio 
	if (af->qlen > format->sample_rate) {
		pthread_mutex_unlock(&af->mutex);
        
		return 0;
	}
    
	s = num_frames * sizeof(int16_t) * format->channels;
    
	afd = malloc(sizeof(audio_fifo_data_t) + s);
	memcpy(afd->samples, frames, s);
    
	afd->nsamples = num_frames;
    
	afd->rate = format->sample_rate;
	afd->channels = format->channels;
    
	TAILQ_INSERT_TAIL(&af->q, afd, link);
	af->qlen += num_frames;
    
	pthread_cond_signal(&af->cond);
	pthread_mutex_unlock(&af->mutex);
    
	return num_frames;
}

static void play_token_lost(sp_session *session) {
	NSObject<PPSpotifySessionDelegate> *delegate = sessobj(session).delegate;
	if([delegate respondsToSelector:@selector(sessionLostPlayToken:)]) {
		[delegate sessionLostPlayToken:sessobj(session)];
    }
}

static void log_message(sp_session *session, const char *message) {
	NSObject<PPSpotifySessionDelegate> *delegate = sessobj(session).delegate;
	//NSString *msg = [[NSString alloc] initWithUTF8String:message];
	if([delegate respondsToSelector:@selector(session:logged:)]) {
        /*
         [sessobj(session) performSelectorOnMainThread:@selector(tellDelegateThatSessionLogged:)
         withObject:msg 
         waitUntilDone:NO];
         */
    }
	
}

static void end_of_track(sp_session *session)
{
	NSObject<PPSpotifySessionDelegate> *delegate = sessobj(session).delegate;
	if([delegate respondsToSelector:@selector(sessionEndedPlayingTrack:)]) {
		[delegate performSelectorOnMainThread:@selector(sessionEndedPlayingTrack:)
								   withObject:sessobj(session)
								waitUntilDone:NO];
    }
}

static void streaming_error(sp_session *session, sp_error error) {
	NSObject<PPSpotifySessionDelegate> *delegate = sessobj(session).delegate;
	NSError *err = SP_ERROR_OK == error ? nil : makeError(error);
	if([delegate respondsToSelector:@selector(session:streamingError:)])
		[delegate session:sessobj(session) streamingError:err];
}

static void userinfo_updated(sp_session *session) {
	NSObject<PPSpotifySessionDelegate> *delegate = sessobj(session).delegate;
	if([delegate respondsToSelector:@selector(sessionUpdatedUserinfo:)])
		[delegate sessionUpdatedUserinfo:sessobj(session)];
}

@implementation PPSpotifySessionImpl

@synthesize delegate = delegate_;

- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (sp_session *)session {
    return session_;
}

- (BOOL)createSession:(NSError **)error {
    audio_init(&audiofifo);
    
    NSArray *cachesDirs = 
    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSArray *supportDirs = 
    NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	cachesDir_ = [[cachesDirs objectAtIndex:0] retain];
	supportDir_ = [[supportDirs objectAtIndex:0] retain];
    
    NSLog(@"%@\n%@", cachesDir_, supportDir_);
	
	callbacks_ = (sp_session_callbacks) {
		.logged_in = logged_in,
		.logged_out = logged_out,
		.metadata_updated = metadata_updated,
		.connection_error = connection_error,
		.message_to_user = message_to_user,
		.notify_main_thread = notify_main_thread,
		.music_delivery = music_delivery,
		.play_token_lost = play_token_lost,
		.log_message = log_message,
		.end_of_track = end_of_track,
		.streaming_error = streaming_error,
		.userinfo_updated = userinfo_updated,
	};
	
	config_ = (sp_session_config){
		.api_version = SPOTIFY_API_VERSION,
		.cache_location = [cachesDir_ UTF8String],
		.settings_location = [supportDir_ UTF8String],
		.application_key = g_appkey,
		.application_key_size = g_appkey_size,
		.user_agent = [[[NSProcessInfo processInfo] processName] UTF8String],
		.callbacks = &callbacks_,
		.userdata = self,
	};
	
	sp_error sperror = sp_session_create(&config_, &session_);
	
	if (SP_ERROR_OK != sperror) {
		if(error) {
            *error = makeError(sperror);       
        }
        return NO;
	}
    
    [self processEvents];
    
    return YES;
}

- (BOOL)loginUser:(NSString*)user password:(NSString*)passwd error:(NSError**)err {
	sp_error sperror = sp_session_login(session_, [user UTF8String], [passwd UTF8String]);
	if(SP_ERROR_OK != sperror) {
		if(err) {
            *err = makeError(sperror);   
        }
		return NO;
	}
	return YES;
}

- (void)logout {
    sp_session_logout(session_);
}

- (void)processEvents {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
	int msTilNext = 0;
	while(msTilNext == 0) {
		sp_session_process_events(session_, &msTilNext);
    }
	
	NSTimeInterval secsTilNext = msTilNext/1000.;
	[self performSelector:_cmd withObject:nil afterDelay:secsTilNext];
}

-(audio_fifo_t*)audiofifo; {
	return &audiofifo;
}

- (void)dealloc {
    [cachesDir_ release];
    [supportDir_ release];
    [super dealloc];
}

@end
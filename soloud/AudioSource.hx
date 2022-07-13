package soloud;

enum abstract AudioSourceAttenuationModels(Int) from Int to Int {

    /**
     * No attenuation
     */
    var NO_ATTENUATION = 0;

    /**
     * Inverse distance attenuation model
     */
    var INVERSE_DISTANCE = 1;

    /**
     * Linear distance attenuation model
     */
    var LINEAR_DISTANCE = 2;

    /**
     * Exponential distance attenuation model
     */
    var EXPONENTIAL_DISTANCE = 3;

}

@:native('SoLoud::AudioCollider')
extern class AudioCollider {

    function collide(aSoloud:Soloud, aAudioInstance3dData:AudioSourceInstance3dData, aUserData:cpp.Int32):cpp.Float32;

}

@:native('SoLoud::AudioAttenuator')
extern class AudioAttenuator {

    function attenuate(aDistance:cpp.Float32, aMinDistance:cpp.Float32, aMaxDistance:cpp.Float32, aRolloffFactor:cpp.Float32):cpp.Float32;

}

@:native('SoLoud::AudioSourceInstance3dData')
extern class AudioSourceInstance3dData {

    inline static function create():AudioSourceInstance3dData {
        return untyped __cpp__('new SoLoud::AudioSourceInstance3dData()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

    /**
     * Set settings from audiosource
     */
    inline function init(aSource:AudioSource):Void
        _init(AudioSourceRef.fromAudioSource(aSource));
    @:native('init')
    private function _init(aSource:AudioSourceRef):Void;

    /**
     * 3d position
     */
    var m3dPosition:cpp.Pointer<cpp.Float32>;

    /**
     * 3d velocity
     */
    var m3dVelocity:cpp.Pointer<cpp.Float32>;

    /**
     * 3d min distance
     */
    var m3dMinDistance:cpp.Float32;

    /**
     * 3d max distance
     */
    var m3dMaxDistance:cpp.Float32;

    /**
     * 3d attenuation rolloff factor
     */
    var m3dAttenuationRolloff:cpp.Float32;

    /**
     * 3d attenuation model
     */
    var m3dAttenuationModel:cpp.UInt32;

    /**
     * 3d doppler factor
     */
    var m3dDopplerFactor:cpp.Float32;

    /**
     * Pointer to a custom audio collider object
     */
    var mCollider:AudioCollider;

    /**
     * Pointer to a custom audio attenuator object
     */
    var mAttenuator:AudioAttenuator;

    /**
     * User data related to audio collider
     */
    var mColliderData:cpp.Int32;


    /**
     * Doppler sample rate multiplier
     */
    var mDopplerValue:cpp.Float32;

    /**
     * Overall 3d volume
     */
    var m3dVolume:cpp.Float32;

    /**
     * Channel volume
     */
    var mChannelVolume:cpp.Pointer<cpp.Float32>;

    /**
     * Copy of flags
     */
    var mFlags:AudioSourceFlags;

    /**
     * Latest handle for this voice
     */
    var mHandle:Soloud.Handle;

}

enum abstract AudioSourceInstanceFlags(cpp.UInt32) from cpp.UInt32 to cpp.UInt32 {

    /**
     * This audio instance loops (if supported)
     */
    var LOOPING = 1;

    /**
     * This audio instance is protected - won't get stopped if we run out of voices
     */
    var PROTECTED = 2;

    /**
     * This audio instance is paused
     */
    var PAUSED = 4;

    /**
     * This audio instance is affected by 3d processing
     */
    var PROCESS_3D = 8;

    /**
     * This audio instance has listener-relative 3d coordinates
     */
    var LISTENER_RELATIVE = 16;

    /**
     * Currently inaudible
     */
    var INAUDIBLE = 32;

    /**
     * If inaudible, should be killed (default = don't kill kill)
     */
    var INAUDIBLE_KILL = 64;

    /**
     * If inaudible, should still be ticked (default = pause)
     */
    var INAUDIBLE_TICK = 128;

    function toString() {

        var result = new StringBuf();
        var count = 0;

        if (this & LOOPING == LOOPING) {
            if (count++ > 0)
                result.add(' | ');
            result.add('LOOPING');
        }

        if (this & PROTECTED == PROTECTED) {
            if (count++ > 0)
                result.add(' | ');
            result.add('PROTECTED');
        }

        if (this & PAUSED == PAUSED) {
            if (count++ > 0)
                result.add(' | ');
            result.add('PAUSED');
        }

        if (this & PROCESS_3D == PROCESS_3D) {
            if (count++ > 0)
                result.add(' | ');
            result.add('PROCESS_3D');
        }

        if (this & LISTENER_RELATIVE == LISTENER_RELATIVE) {
            if (count++ > 0)
                result.add(' | ');
            result.add('LISTENER_RELATIVE');
        }

        if (this & INAUDIBLE == INAUDIBLE) {
            if (count++ > 0)
                result.add(' | ');
            result.add('INAUDIBLE');
        }

        if (this & INAUDIBLE_KILL == INAUDIBLE_KILL) {
            if (count++ > 0)
                result.add(' | ');
            result.add('INAUDIBLE_KILL');
        }

        if (this & INAUDIBLE_TICK == INAUDIBLE_TICK) {
            if (count++ > 0)
                result.add(' | ');
            result.add('INAUDIBLE_TICK');
        }

        return result.toString();

    }

}

@:native("SoLoud::AudioSourceInstance*")
extern class AudioSourceInstance {

    inline static function create():AudioSourceInstance {
        return untyped __cpp__('new SoLoud::AudioSourceInstance()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

    /**
     * Play index; used to identify instances from handles
     */
    var mPlayIndex:cpp.UInt32;

    /**
     * Loop count
     */
    var mLoopCount:cpp.UInt32;

    /**
     * Flags; see AudioSourceInstance::FLAGS
     */
    var mFlags:cpp.UInt32;

    /**
     * Pan value, for getPan()
     */
    var mPan:cpp.Float32;

    /**
     * Volume for each channel (panning)
     */
    var mChannelVolume:cpp.Pointer<cpp.Float32>;

    /**
     * Set volume
     */
    var mSetVolume:cpp.Float32;

    /**
     * Overall volume overall = set * 3d
     */
    var mOverallVolume:cpp.Float32;

    /**
     * Base samplerate; samplerate = base samplerate * relative play speed
     */
    var mBaseSamplerate:cpp.Float32;

    /**
     * Samplerate; samplerate = base samplerate * relative play speed
     */
    var mSamplerate:cpp.Float32;

    /**
     * Number of channels this audio source produces
     */
    var mChannels:cpp.UInt32;

    /**
     * Relative play speed; samplerate = base samplerate * relative play speed
     */
    var mSetRelativePlaySpeed:cpp.Float32;

    /**
     * Overall relative plays peed; overall = set * 3d
     */
    var mOverallRelativePlaySpeed:cpp.Float32;

    /**
     * How long this stream has played, in seconds.
     */
    var mStreamTime:Soloud.Time;

    /**
     * Position of this stream, in seconds.
     */
    var mStreamPosition:Soloud.Time;

    /**
     * Fader for the audio panning
     */
    var mPanFader:Fader;

    /**
     * Fader for the audio volume
     */
    var mVolumeFader:Fader;

    /**
     * Fader for the relative play speed
     */
    var mRelativePlaySpeedFader:Fader;

    /**
     * Fader used to schedule pausing of the stream
     */
    var mPauseScheduler:Fader;

    /**
     * Fader used to schedule stopping of the stream
     */
    var mStopScheduler:Fader;

    /**
     * Affected by some fader
     */
    var mActiveFader:cpp.Int32;

    /**
     * Current channel volumes, used to ramp the volume changes to avoid clicks
     */
    var mCurrentChannelVolume:cpp.Pointer<cpp.Float32>;

    /**
     * ID of the sound source that generated this instance
     */
    var mAudioSourceID:cpp.UInt32;

    /**
     * Handle of the bus this audio instance is playing on. 0 for root.
     */
    var mBusHandle:cpp.UInt32;

    /**
     * Filter pointer
     */
    var mFilter:cpp.Pointer<Filter.FilterInstance>;

    /**
     * Initialize instance. Mostly internal use.
     */
    inline function init(aSource:AudioSource, aPlayIndex:cpp.Int32):Void {
        _init(AudioSourceRef.fromAudioSource(aSource), aPlayIndex);
    }
    @:native('init')
    private function _init(aSource:AudioSourceRef, aPlayIndex:cpp.Int32):Void;

    /**
     * Buffers for the resampler
     */
    var mResampleData:cpp.Pointer<Soloud.AlignedFloatBuffer>;

    /**
     * Sub-sample playhead; 16.16 fixed point
     */
    var mSrcOffset:cpp.UInt32;

    /**
     * Samples left over from earlier pass
     */
    var mLeftoverSamples:cpp.UInt32;

    /**
     * Number of samples to delay streaming
     */
    var mDelaySamples:cpp.UInt32;

    /**
     * When looping, start playing from this time
     */
    var mLoopPoint:Soloud.Time;


    /**
     * Get N samples from the stream to the buffer. Report samples written.
     */
    function getAudio(aBuffer:cpp.Pointer<cpp.Float32>, aSamplesToRead:cpp.UInt32, aBufferSize:cpp.UInt32):cpp.UInt32;

    /**
     * Has the stream ended?
     */
    function hasEnded():Bool;

    /**
     * Seek to certain place in the stream. Base implementation is generic "tape" seek (and slow).
     */
    function seek(aSeconds:Soloud.Time, mScratch:cpp.Pointer<cpp.Float32>, mScratchSize:cpp.UInt32):Soloud.Result;

    /**
     * Rewind stream. Base implementation returns NOT_IMPLEMENTED, meaning it can't rewind.
     */
    function rewind():Soloud.Result;

    /**
     * Get information. Returns 0 by default.
     */
    function getInfo(aInfoKey:cpp.UInt32):cpp.Float32;

}

@:noCompletion
@:native("SoLoud::AudioSource&")
extern class AudioSourceRef {

    inline public static function fromAudioSource(audioSource:AudioSource):AudioSourceRef
        return untyped __cpp__('*{0}', audioSource);

}

enum abstract AudioSourceFlags(cpp.UInt32) from cpp.UInt32 to cpp.UInt32 {

    /**
     * The instances from this audio source should loop
     */
    var SHOULD_LOOP = 1;

    /**
     * Only one instance of this audio source should play at the same time
     */
    var SINGLE_INSTANCE = 2;

    /**
     * Visualization data gathering enabled. Only for busses.
     */
    var VISUALIZATION_DATA = 4;

    /**
     * Audio instances created from this source are affected by 3d processing
     */
    var PROCESS_3D = 8;

    /**
     * Audio instances created from this source have listener-relative 3d coordinates
     */
    var LISTENER_RELATIVE = 16;

    /**
     * Delay start of sound by the distance from listener
     */
    var DISTANCE_DELAY = 32;

    /**
     * If inaudible, should be killed (default)
     */
    var INAUDIBLE_KILL = 64;

    /**
     * If inaudible, should still be ticked (default = pause)
     */
    var INAUDIBLE_TICK = 128;

    function toString() {

        var result = new StringBuf();
        var count = 0;

        if (this & SHOULD_LOOP == SHOULD_LOOP) {
            if (count++ > 0)
                result.add(' | ');
            result.add('SHOULD_LOOP');
        }

        if (this & SINGLE_INSTANCE == SINGLE_INSTANCE) {
            if (count++ > 0)
                result.add(' | ');
            result.add('SINGLE_INSTANCE');
        }

        if (this & VISUALIZATION_DATA == VISUALIZATION_DATA) {
            if (count++ > 0)
                result.add(' | ');
            result.add('VISUALIZATION_DATA');
        }

        if (this & PROCESS_3D == PROCESS_3D) {
            if (count++ > 0)
                result.add(' | ');
            result.add('PROCESS_3D');
        }

        if (this & LISTENER_RELATIVE == LISTENER_RELATIVE) {
            if (count++ > 0)
                result.add(' | ');
            result.add('LISTENER_RELATIVE');
        }

        if (this & DISTANCE_DELAY == DISTANCE_DELAY) {
            if (count++ > 0)
                result.add(' | ');
            result.add('DISTANCE_DELAY');
        }

        if (this & INAUDIBLE_KILL == INAUDIBLE_KILL) {
            if (count++ > 0)
                result.add(' | ');
            result.add('INAUDIBLE_KILL');
        }

        if (this & INAUDIBLE_TICK == INAUDIBLE_TICK) {
            if (count++ > 0)
                result.add(' | ');
            result.add('INAUDIBLE_TICK');
        }

    }

}

/**
 * Base class for audio sources
 */
@:native("SoLoud::AudioSource*")
@:include('linc_soloud.h')
extern class AudioSource {

    inline static function create():AudioSource {
        return untyped __cpp__('new SoLoud::AudioSource()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

    /**
     * Flags. See AudioSource::FLAGS
     */
    var mFlags:AudioSourceFlags;

    /**
     * Base sample rate, used to initialize instances
     */
    var mBaseSamplerate:cpp.Float32;

    /**
     * Default volume for created instances
     */
    var mVolume:cpp.Float32;

    /**
     * Number of channels this audio source produces
     */
    var mChannels:cpp.UInt32;

    /**
     * Sound source ID. Assigned by SoLoud the first time it's played.
     */
    var mAudioSourceID:cpp.UInt32;

    /**
     * 3d min distance
     */
    var m3dMinDistance:cpp.Float32;

    /**
     * 3d max distance
     */
    var m3dMaxDistance:cpp.Float32;

    /**
     * 3d attenuation rolloff factor
     */
    var m3dAttenuationRolloff:cpp.Float32;

    /**
     * 3d attenuation model
     */
    var m3dAttenuationModel:cpp.UInt32;

    /**
     * 3d doppler factor
     */
    var m3dDopplerFactor:cpp.Float32;

    /**
     * Filter pointer
     */
    var mFilter:cpp.Pointer<Filter>;

    /**
     * Pointer to the Soloud object. Needed to stop all instances in dtor.
     */
    var mSoloud:Soloud;

    /**
     * Pointer to a custom audio collider object
     */
    var mCollider:AudioCollider;

    /**
     * Pointer to custom attenuator object
     */
    var mAttenuator:AudioAttenuator;

    /**
     * User data related to audio collider
     */
    var mColliderData:cpp.Int32;

    /**
     * When looping, start playing from this time
     */
    var mLoopPoint:Soloud.Time;


    /**
     * Set default volume for instances
     */
    function setVolume(aVolume:cpp.Float32):Void;

    /**
     * Set the looping of the instances created from this audio source
     */
    function setLooping(aLoop:Bool):Void;

    /**
     * Set whether only one instance of this sound should ever be playing at the same time
     */
    function setSingleInstance(aSingleInstance:Bool):Void;


    /**
     * Set the minimum and maximum distances for 3d audio source (closer to min distance = max vol)
     */
    function set3dMinMaxDistance(aMinDistance:cpp.Float32, aMaxDistance:cpp.Float32):Void;

    /**
     * Set attenuation model and rolloff factor for 3d audio source
     */
    function set3dAttenuation(aAttenuationModel:cpp.UInt32, aAttenuationRolloffFactor:cpp.Float32):Void;

    /**
     * Set doppler factor to reduce or enhance doppler effect, default = 1.0
     */
    function set3dDopplerFactor(aDopplerFactor:cpp.Float32):Void;

    /**
     * Set the coordinates for this audio source to be relative to listener's coordinates.
     */
    function set3dListenerRelative(aListenerRelative:Bool):Void;

    /**
     * Enable delaying the start of the sound based on the distance.
     */
    function set3dDistanceDelay(aDistanceDelay:Bool):Void;


    /**
     * Set a custom 3d audio collider. Set to NULL to disable.
     */
    function set3dCollider(aCollider:AudioCollider, aUserData:cpp.Int32 = 0):Void;

    /**
     * Set a custom attenuator. Set to NULL to disable.
     */
    function set3dAttenuator(aAttenuator:AudioAttenuator):Void;

    /**
     * Set behavior for inaudible sounds
     */
    function setInaudibleBehavior(aMustTick:Bool, aKill:Bool):Void;


    /**
     * Set time to jump to when looping
     */
    function setLoopPoint(aLoopPoint:Soloud.Time):Void;

    /**
     * Get current loop point value
     */
    function getLoopPoint():Soloud.Time;

    /**
     * Set filter. Set to NULL to clear the filter.
     */
    function setFilter(aFilterId:cpp.UInt32, aFilter:Filter):Void;


    /**
     * Create instance from the audio source. Called from within Soloud class.
     */
    function createInstance():AudioSourceInstance;

    /**
     * Stop all instances of this audio source
     */
    function stop():Void;

}

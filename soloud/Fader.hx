package soloud;

/**
 * Helper class to process faders
 */
@:native("SoLoud::Fader*")
@:include('linc_soloud.h')
extern class Fader {

    /**
     * Value to fade from
     */
    var mFrom:cpp.Float32;

    /**
     * Value to fade to
     */
    var mTo:cpp.Float32;

    /**
     * Delta between from and to
     */
    var mDelta:cpp.Float32;

    /**
     * Total time to fade
     */
    var mTime:Soloud.Time;

    /**
     * Time fading started
     */
    var mStartTime:Soloud.Time;

    /**
     * Time fading will end
     */
    var mEndTime:Soloud.Time;

    /**
     * Current value. Used in case time rolls over.
     */
    var mCurrent:cpp.Float32;

    /**
     * Active flag; 0 means disabled, 1 is active, 2 is LFO, -1 means was active, but stopped
     */
    var mActive:cpp.Int32;

    inline static function create():Fader {
        return untyped __cpp__('new SoLoud::Fader()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

    /**
     * Set up LFO
     */
    function setLFO(aFrom:cpp.Float32, aTo:cpp.Float32, aTime:Soloud.Time, aStartTime:Soloud.Time):Void;

    /**
     * Set up fader
     */
    function set(aFrom:cpp.Float32, aTo:cpp.Float32, aTime:Soloud.Time, aStartTime:Soloud.Time):Void;

    /**
     * Get the current fading value
     */
    function get(aCurrentTime:Soloud.Time):cpp.Float32;

}

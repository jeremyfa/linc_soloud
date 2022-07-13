package soloud;

@:keep
@:native("SoLoud::WavStream*")
@:include('linc_soloud.h')
extern class WavStream extends AudioSource {

    var mFiletype:cpp.Int32;

    var mFilename:cpp.ConstCharStar;

    var mSampleCount:cpp.UInt32;

    inline static function create():WavStream {
        return untyped __cpp__('new SoLoud::WavStream()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

    function load(aFilename:cpp.ConstCharStar):Soloud.Result;

    function loadMem(aData:cpp.Pointer<cpp.UInt8>, aDataLen:cpp.UInt32, aCopy:Bool = false, aTakeOwnership:Bool = true):Soloud.Result;

    function loadToMem(aFilename:cpp.ConstCharStar):Soloud.Result;

    function getLength():Soloud.Time;

}

package soloud;

enum abstract FilterParamType(cpp.UInt32) from cpp.UInt32 to cpp.UInt32 {

    var FLOAT_PARAM = 0;

    var INT_PARAM = 1;

    var BOOL_PARAM = 2;

    function toString() {

        var paramType:FilterParamType = this;
        return switch paramType {
            case FLOAT_PARAM: 'FLOAT_PARAM';
            case INT_PARAM: 'INT_PARAM';
            case BOOL_PARAM: 'BOOL_PARAM';
            case _: '' + this;
        }

    }

}

/**
 * Base class for filter instances
 */
@:native("SoLoud::FilterInstance*")
extern class FilterInstance {

    var mNumParams:cpp.UInt32;

    var mParamChanged:cpp.UInt32;

    var mParam:cpp.Pointer<cpp.Float32>;

    var mParamFader:Fader;

    inline static function create():FilterInstance {
        return untyped __cpp__('new SoLoud::FilterInstance()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

    function initParams(aNumParams:cpp.Int32):Soloud.Result;

    function updateParams(aTime:Soloud.Time):Void;

    function filter(aBuffer:cpp.Pointer<cpp.Float32>, aSamples:cpp.UInt32, aChannels:cpp.UInt32, aSamplerate:cpp.Float32, aTime:Soloud.Time):Void;

    function filterChannel(aBuffer:cpp.Float32, aSamples:cpp.UInt32, aSamplerate:cpp.Float32, aTime:Soloud.Time, aChannel:cpp.UInt32, aChannels:cpp.UInt32):Void;

    function getFilterParameter(aAttributeId:cpp.UInt32):cpp.Float32;

    function setFilterParameter(aAttributeId:cpp.UInt32, aValue:cpp.Float32):Void;

    function fadeFilterParameter(aAttributeId:cpp.UInt32, aTo:cpp.Float32, aTime:Soloud.Time, aStartTime:Soloud.Time):Void;

    function oscillateFilterParameter(aAttributeId:cpp.UInt32, aFrom:cpp.Float32, aTo:cpp.Float32, aTime:Soloud.Time, aStartTime:Soloud.Time):Void;

}

/**
 * Base class for audio sources
 */
@:native("SoLoud::Filter*")
@:include('linc_soloud.h')
extern class Filter {

    inline static function create():Filter {
        return untyped __cpp__('new SoLoud::Filter()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

    function getParamCount():Int;

    function getParamName(aParamIndex:cpp.UInt32):cpp.ConstCharStar;

    function getParamType(aParamIndex:cpp.UInt32):cpp.UInt32;

    function getParamMax(aParamIndex:cpp.UInt32):cpp.Float32;

    function getParamMin(aParamIndex:cpp.UInt32):cpp.Float32;

    function createInstance():FilterInstance;

}

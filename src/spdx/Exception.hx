// SPDX-License-Identifier: Zlib
package spdx;

/**
    Information about an exception to a license.
**/
#if !macro
@:build(spdx._internal.DataBuilder.generateExceptions())
#end
final class Exception {

    /**
        Full name of the exception.
    **/
    public final name: String;
    
    /**
        An identifier.
    **/
    public final id: String;
    
    /**
        Is this exception discouraged from use?
    **/
    public final isDeprecated: Bool;
    
    /**
        Creates a new license exception object.
    **/
    @:allow(spdx._internal.DataBuilder)
    private function new(name: String, id: String, isDeprecated: Bool) {
        this.name = name;
        this.id = id;
        this.isDeprecated = isDeprecated;
    }
}

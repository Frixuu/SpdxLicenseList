package spdx;

/**
    Information about a license.
**/
abstract class License {

    /**
        Full name of the license found in the license text.
    **/
    public var name(default, null): String;
    
    /**
        A short-form identifier.
        Typically an abbreviation based on a common short name.
    **/
    public var id(default, null): String;
    
    /**
        Is this license's identifier discouraged from use?

        (Typically this is because there is a clearer way to describe
        the license's exceptions or exact version.)
    **/
    public var isDeprecated(default, null): Bool;
    
    /**
        Is the license considered compliant with the Open Source Definition
        by the Open Source Initiative (OSI)?
    **/
    public var isOsiApproved(default, null): Bool;
    
    /**
        Is the license listed as free by the Free Software Foundation (FSF)?
    **/
    public var isFsfLibre(default, null): Bool;
}

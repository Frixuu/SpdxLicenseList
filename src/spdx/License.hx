// SPDX-License-Identifier: Zlib
package spdx;

/**
    Information about a license.
**/
final class License {

    /**
        Full name of the license found in the license text.
    **/
    public final name: String;

    /**
        A short-form identifier.
        Typically an abbreviation based on a common short name.
    **/
    public final id: String;

    /**
        Is this license's identifier discouraged from use?

        (Typically this is because there is a clearer way to describe
        the license's exceptions or exact version.)
    **/
    public final isDeprecated: Bool;

    /**
        Is the license considered compliant with the Open Source Definition
        by the Open Source Initiative (OSI)?
    **/
    public final isOsiApproved: Bool;

    /**
        Is the license listed as free by the Free Software Foundation (FSF)?
    **/
    public final isFsfLibre: Bool;

    /**
        Creates a new license object.
    **/
    @:allow(spdx.Licenses)
    private function new(
        name: String,
        id: String,
        isDeprecated: Bool,
        isOsiApproved: Bool,
        isFsfLibre: Bool
    ) {
        this.name = name;
        this.id = id;
        this.isDeprecated = isDeprecated;
        this.isOsiApproved = isOsiApproved;
        this.isFsfLibre = isFsfLibre;
    }

    /**
        Tries to return the license with the given name.
        @param name The name of the license.
        @return The license with the given name, or `null` if no such license exists.
    **/
    public static function tryFromName(name: String): Null<License> {
        return spdx.Licenses.ALL_BY_NAME.get(name);
    }

    /**
        Tries to return the license with the given ID.
        @param id The ID of the license.
        @return The license with the given ID, or `null` if no such license exists.
    **/
    public static function tryFromId(id: String): Null<License> {
        return spdx.Licenses.ALL_BY_ID.get(id);
    }
}

// SPDX-License-Identifier: Zlib
package;

import utest.Assert;
import utest.Test;

class MitTest extends Test {

    public function test__Object_exists() {
        Assert.notNull(spdx.Licenses.MIT);
    }

    public function test__License_has_correct_fields() {
        final license = spdx.Licenses.MIT;
        Assert.equals("MIT License", license.name);
        Assert.equals("MIT", license.id);
        Assert.isFalse(license.isDeprecated);
        Assert.isTrue(license.isOsiApproved);
        Assert.isTrue(license.isFsfLibre);
    }
}

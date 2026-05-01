// SPDX-License-Identifier: Zlib
package;

import spdx.License;
import utest.Assert;
import utest.Test;

class MitTest extends Test {

    public function test__Object_exists() {
        Assert.notNull(spdx.Licenses.MIT);
        Assert.isTrue(Std.is(spdx.Licenses.MIT, License));
    }

    public function test__License_has_correct_fields() {
        final license = spdx.Licenses.MIT;
        Assert.equals("MIT License", license.name);
        Assert.equals("MIT", license.id);
        Assert.isFalse(license.isDeprecated);
        Assert.isTrue(license.isOsiApproved);
        Assert.isTrue(license.isFsfLibre);
    }

    public function test__License_can_be_retrieved_by_name() {
        Assert.equals(spdx.Licenses.MIT, License.tryFromName("MIT License"));
    }

    public function test__License_can_be_retrieved_by_ID() {
        Assert.equals(spdx.Licenses.MIT, License.tryFromId("MIT"));
    }

    public function test__License_is_in_all_array() {
        Assert.contains(spdx.Licenses.MIT, cast spdx.Licenses.ALL);
    }
}

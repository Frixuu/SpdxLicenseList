// SPDX-License-Identifier: Zlib
package;

import spdx.License;
import utest.Assert;
import utest.Test;

class MitTest extends Test {

    public function test__Object_exists() {
        Assert.notNull(License.MIT);
        Assert.isTrue(Std.is(License.MIT, License));
    }
    
    public function test__License_has_correct_fields() {
        final license = License.MIT;
        Assert.equals("MIT License", license.name);
        Assert.equals("MIT", license.id);
        Assert.isFalse(license.isDeprecated);
        Assert.isTrue(license.isOsiApproved);
        Assert.isTrue(license.isFsfLibre);
    }
    
    public function test__License_can_be_retrieved_by_name() {
        Assert.equals(License.MIT, License.getByName("MIT License"));
    }
    
    public function test__License_can_be_retrieved_by_ID() {
        Assert.equals(License.MIT, License.getById("MIT"));
    }
    
    public function test__License_is_in_all_array() {
        Assert.contains(License.MIT, cast License.ALL);
    }
}

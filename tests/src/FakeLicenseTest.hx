// SPDX-License-Identifier: Zlib
package;

import spdx.License;
import utest.Assert;
import utest.Test;

class FakeLicenseTest extends Test {

    public function test__License_cannot_be_retrieved_by_name() {
        Assert.isNull(License.getByName("Fake license"));
    }

    public function test__License_cannot_be_retrieved_by_ID() {
        Assert.isNull(License.getById("FAKE"));
    }
}

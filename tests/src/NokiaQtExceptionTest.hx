// SPDX-License-Identifier: Zlib
package;

import spdx.Exception;
import utest.Assert;
import utest.Test;

@:haxe.warning("-WDeprecated")
class NokiaQtExceptionTest extends Test {

    public function test__Object_exists() {
        Assert.notNull(Exception.NOKIA_QT_LGPL_EXCEPTION_1_1);
        Assert.isTrue(Std.isOfType(Exception.NOKIA_QT_LGPL_EXCEPTION_1_1, Exception));
    }
    
    public function test__Exception_has_correct_fields() {
        final exception = Exception.NOKIA_QT_LGPL_EXCEPTION_1_1;
        Assert.equals("Nokia Qt LGPL exception 1.1", exception.name);
        Assert.equals("Nokia-Qt-exception-1.1", exception.id);
        Assert.isTrue(exception.isDeprecated);
    }
    
    public function test__Exception_can_be_retrieved_by_name() {
        Assert.equals(
            Exception.NOKIA_QT_LGPL_EXCEPTION_1_1,
            Exception.getByName("Nokia Qt LGPL exception 1.1")
        );
    }
    
    public function test__Exception_can_be_retrieved_by_ID() {
        Assert.equals(
            Exception.NOKIA_QT_LGPL_EXCEPTION_1_1,
            Exception.getById("Nokia-Qt-exception-1.1")
        );
        Assert.equals(
            Exception.NOKIA_QT_LGPL_EXCEPTION_1_1,
            Exception.getById("NOKIA-QT-EXCEPTION-1.1")
        );
        Assert.equals(
            Exception.NOKIA_QT_LGPL_EXCEPTION_1_1,
            Exception.getById("nokia-qt-exception-1.1")
        );
    }
    
    public function test__Exception_is_in_all_array() {
        Assert.contains(Exception.NOKIA_QT_LGPL_EXCEPTION_1_1, cast Exception.ALL);
    }
}

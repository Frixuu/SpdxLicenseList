// SPDX-License-Identifier: Zlib
package expressions;

import spdx.Exception;
import spdx.Expression.And;
import spdx.Expression.Or;
import spdx.Expression.Simple;
import spdx.Expression.With;
import spdx.License;
import utest.Assert;
import utest.Test;

using spdx.ExpressionTools;

class ExpressionParseTest extends Test {

    public function test__Simple_expressions_are_correctly_parsed() {
        Assert.same(Simple(Defined(License.MIT, false)), ExpressionTools.parse("MIT"));
        Assert.same(Simple(Defined(License.CDDL_1_0, true)), ExpressionTools.parse("CDDL-1.0+"));
        Assert.same(Simple(Ref(null, "23")), ExpressionTools.parse("LicenseRef-23"));
        Assert.same(
            Simple(Ref("spdx-tool-1.2", "MIT-Style-2")),
            ExpressionTools.parse("DocumentRef-spdx-tool-1.2:LicenseRef-MIT-Style-2")
        );
    }

    public function test__Invalid_identifiers_are_rejected() {
        Assert.isNull(ExpressionTools.parse("LicenseRef-67+"));
        Assert.isNull(ExpressionTools.parse("67676767"));
    }

    public function test__Compound_expressions_are_correctly_parsed() {
        Assert.same(
            Or(
                Or(Simple(Defined(License.MIT, false)), Simple(Defined(License.APACHE_2_0, false))),
                Simple(Defined(License.GPL_2_0_ONLY, false))
            ),
            ExpressionTools.parse("MIT Or apache-2.0 or GPL-2.0-only")
        );
        Assert.same(
            And(
                Simple(Defined(License.MIT, false)),
                Or(
                    Simple(Defined(License.LGPL_2_1_OR_LATER, false)),
                    Simple(Defined(License.BSD_3_CLAUSE, false))
                )
            ),
            ExpressionTools.parse("MIT AND (LGPL-2.1-or-later OR BSD-3-Clause)")
        );
        Assert.same(
            Or(Simple(Defined(License.MIT, false)), Simple(Defined(License.ISC, false))),
            ExpressionTools.parse("(mit) or (isc)")
        );
        Assert.same(
            With(Defined(License.GPL_2_0_OR_LATER, false), Defined(Exception.AUTOCONF_2_0)),
            ExpressionTools.parse("GPL-2.0-or-later WITH Autoconf-exception-2.0")
        );
    }
}

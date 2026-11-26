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
        Assert.same(Simple(Listed(License.MIT, false)), ExpressionTools.parse("MIT"));
        Assert.same(Simple(Listed(License.CDDL_1_0, true)), ExpressionTools.parse("CDDL-1.0+"));
        Assert.same(Simple(Custom(null, "23")), ExpressionTools.parse("LicenseRef-23"));
        Assert.same(
            Simple(Custom("spdx-tool-1.2", "MIT-Style-2")),
            ExpressionTools.parse("DocumentRef-spdx-tool-1.2:LicenseRef-MIT-Style-2")
        );
    }
    
    public function test__Compound_expressions_are_correctly_parsed() {
        Assert.same(
            Or(
                Or(Simple(Listed(License.MIT, false)), Simple(Listed(License.APACHE_2_0, false))),
                Simple(Listed(License.GPL_2_0_ONLY, false))
            ),
            ExpressionTools.parse("MIT Or apache-2.0 or GPL-2.0-only")
        );
        Assert.same(
            And(
                Simple(Listed(License.MIT, false)),
                Or(
                    Simple(Listed(License.LGPL_2_1_OR_LATER, false)),
                    Simple(Listed(License.BSD_3_CLAUSE, false))
                )
            ),
            ExpressionTools.parse("MIT AND (LGPL-2.1-or-later OR BSD-3-Clause)")
        );
        Assert.same(
            Or(Simple(Listed(License.MIT, false)), Simple(Listed(License.ISC, false))),
            ExpressionTools.parse("(mit) or (isc)")
        );
        Assert.same(
            With(Listed(License.GPL_2_0_OR_LATER, false), Listed(Exception.AUTOCONF_2_0)),
            ExpressionTools.parse("GPL-2.0-or-later WITH Autoconf-exception-2.0")
        );
        Assert.same(
            With(Listed(License.GPL_2_0_OR_LATER, false), Custom(null, "custom")),
            ExpressionTools.parse("GPL-2.0-or-later WITH AdditionRef-custom")
        );
    }
    
    public function test__Invalid_expressions_are_rejected() {
        Assert.isNull(ExpressionTools.parse("LicenseRef-"));
        Assert.isNull(ExpressionTools.parse("LicenseRef-67+"));
        Assert.isNull(ExpressionTools.parse("cool-LicenseRef-foo"));
        Assert.isNull(ExpressionTools.parse("67676767"));
        Assert.isNull(ExpressionTools.parse("DocumentRef-ąęóść:LicenseRef-foo"));
        Assert.isNull(ExpressionTools.parse("LicenseRef-😎"));
        Assert.isNull(ExpressionTools.parse("(("));
        Assert.isNull(ExpressionTools.parse(")"));
        Assert.isNull(ExpressionTools.parse("()"));
        Assert.isNull(ExpressionTools.parse("MIT AND+"));
        Assert.isNull(ExpressionTools.parse("MIT WITH DocumentRef-👻:AdditionRef-yo"));
        Assert.isNull(ExpressionTools.parse("MIT WITH AdditionRef-привет"));
        Assert.isNull(ExpressionTools.parse("GPL-2.0-or-later WITH DocumentRef-custom"));
    }
}

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

class ExpressionStringifyTest extends Test {

    public function test__Simple_expressions_are_correctly_stringified() {
        Assert.same("MIT", Simple(Listed(License.MIT, false)).stringify());
        Assert.same("CDDL-1.0+", Simple(Listed(License.CDDL_1_0, true)).stringify());
        Assert.same("LicenseRef-23", Simple(Custom(null, "23")).stringify());
        Assert.same(
            "DocumentRef-spdx-tool-1.2:LicenseRef-MIT-Style-2",
            Simple(Custom("spdx-tool-1.2", "MIT-Style-2")).stringify()
        );
    }
    
    public function test__Or_expressions_are_correctly_stringified() {
        Assert.same(
            "MIT OR LGPL-2.1-only",
            Or(
                Simple(Listed(License.MIT, false)),
                Simple(Listed(License.LGPL_2_1_ONLY, false))
            ).stringify()
        );
        Assert.same(
            "MIT OR LGPL-2.1-only OR BSD-3-Clause",
            Or(
                Simple(Listed(License.MIT, false)),
                Or(
                    Simple(Listed(License.LGPL_2_1_ONLY, false)),
                    Simple(Listed(License.BSD_3_CLAUSE, false))
                )
            ).stringify()
        );
        Assert.same(
            "MIT OR LGPL-2.1-only OR BSD-3-Clause",
            Or(
                Or(
                    Simple(Listed(License.MIT, false)),
                    Simple(Listed(License.LGPL_2_1_ONLY, false))
                ),
                Simple(Listed(License.BSD_3_CLAUSE, false))
            ).stringify()
        );
    }
    
    public function test__And_expressions_are_correctly_stringified() {
        Assert.same(
            "MIT AND LGPL-2.1-only",
            And(
                Simple(Listed(License.MIT, false)),
                Simple(Listed(License.LGPL_2_1_ONLY, false))
            ).stringify()
        );
        Assert.same(
            "MIT AND LGPL-2.1-only AND BSD-3-Clause",
            And(
                Simple(Listed(License.MIT, false)),
                And(
                    Simple(Listed(License.LGPL_2_1_ONLY, false)),
                    Simple(Listed(License.BSD_3_CLAUSE, false))
                )
            ).stringify()
        );
        Assert.same(
            "MIT AND LGPL-2.1-only AND BSD-3-Clause",
            And(
                And(
                    Simple(Listed(License.MIT, false)),
                    Simple(Listed(License.LGPL_2_1_ONLY, false))
                ),
                Simple(Listed(License.BSD_3_CLAUSE, false))
            ).stringify()
        );
    }
    
    public function test__With_expressions_are_correctly_stringified() {
        Assert.same(
            "GPL-2.0-or-later WITH Bison-exception-2.2",
            With(Listed(License.GPL_2_0_OR_LATER, false), Listed(Exception.BISON_2_2)).stringify()
        );
        Assert.same(
            "GPL-2.0-or-later WITH AdditionRef-custom",
            With(Listed(License.GPL_2_0_OR_LATER, false), Custom(null, "custom")).stringify()
        );
        Assert.same(
            "GPL-2.0-or-later WITH DocumentRef-foo:AdditionRef-bar",
            With(Listed(License.GPL_2_0_OR_LATER, false), Custom("foo", "bar")).stringify()
        );
    }
    
    public function test__Mixed_operators_are_correctly_stringified() {
        Assert.same(
            "LGPL-2.1-only OR BSD-3-Clause AND MIT",
            Or(
                Simple(Listed(License.LGPL_2_1_ONLY, false)),
                And(Simple(Listed(License.BSD_3_CLAUSE, false)), Simple(Listed(License.MIT, false)))
            ).stringify()
        );
        Assert.same(
            "MIT AND (LGPL-2.1-or-later OR BSD-3-Clause)",
            And(
                Simple(Listed(License.MIT, false)),
                Or(
                    Simple(Listed(License.LGPL_2_1_OR_LATER, false)),
                    Simple(Listed(License.BSD_3_CLAUSE, false))
                )
            ).stringify()
        );
    }
}

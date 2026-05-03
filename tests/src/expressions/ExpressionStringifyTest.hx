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
        Assert.same("MIT", Simple(Defined(License.MIT, false)).stringify());
        Assert.same("CDDL-1.0+", Simple(Defined(License.CDDL_1_0, true)).stringify());
        Assert.same("LicenseRef-23", Simple(Ref(null, "23")).stringify());
        Assert.same(
            "DocumentRef-spdx-tool-1.2:LicenseRef-MIT-Style-2",
            Simple(Ref("spdx-tool-1.2", "MIT-Style-2")).stringify()
        );
    }

    public function test__Or_expressions_are_correctly_stringified() {
        Assert.same(
            "MIT OR LGPL-2.1-only",
            Or(
                Simple(Defined(License.MIT, false)),
                Simple(Defined(License.LGPL_2_1_ONLY, false))
            ).stringify()
        );
        Assert.same(
            "MIT OR LGPL-2.1-only OR BSD-3-Clause",
            Or(
                Simple(Defined(License.MIT, false)),
                Or(
                    Simple(Defined(License.LGPL_2_1_ONLY, false)),
                    Simple(Defined(License.BSD_3_CLAUSE, false))
                )
            ).stringify()
        );
        Assert.same(
            "MIT OR LGPL-2.1-only OR BSD-3-Clause",
            Or(
                Or(
                    Simple(Defined(License.MIT, false)),
                    Simple(Defined(License.LGPL_2_1_ONLY, false))
                ),
                Simple(Defined(License.BSD_3_CLAUSE, false)),
            ).stringify()
        );
    }

    public function test__And_expressions_are_correctly_stringified() {
        Assert.same(
            "MIT AND LGPL-2.1-only",
            And(
                Simple(Defined(License.MIT, false)),
                Simple(Defined(License.LGPL_2_1_ONLY, false))
            ).stringify()
        );
        Assert.same(
            "MIT AND LGPL-2.1-only AND BSD-3-Clause",
            And(
                Simple(Defined(License.MIT, false)),
                And(
                    Simple(Defined(License.LGPL_2_1_ONLY, false)),
                    Simple(Defined(License.BSD_3_CLAUSE, false))
                )
            ).stringify()
        );
        Assert.same(
            "MIT AND LGPL-2.1-only AND BSD-3-Clause",
            And(
                And(
                    Simple(Defined(License.MIT, false)),
                    Simple(Defined(License.LGPL_2_1_ONLY, false))
                ),
                Simple(Defined(License.BSD_3_CLAUSE, false)),
            ).stringify()
        );
    }

    public function test__With_expressions_are_correctly_stringified() {
        Assert.same(
            "GPL-2.0-or-later WITH Bison-exception-2.2",
            With(Defined(License.GPL_2_0_OR_LATER, false), Defined(Exception.BISON_2_2)).stringify()
        );
    }

    public function test__Mixed_operators_are_correctly_stringified() {
        Assert.same(
            "LGPL-2.1-only OR BSD-3-Clause AND MIT",
            Or(
                Simple(Defined(License.LGPL_2_1_ONLY, false)),
                And(
                    Simple(Defined(License.BSD_3_CLAUSE, false)),
                    Simple(Defined(License.MIT, false))
                )
            ).stringify()
        );
        Assert.same(
            "MIT AND (LGPL-2.1-or-later OR BSD-3-Clause)",
            And(
                Simple(Defined(License.MIT, false)),
                Or(
                    Simple(Defined(License.LGPL_2_1_OR_LATER, false)),
                    Simple(Defined(License.BSD_3_CLAUSE, false))
                )
            ).stringify()
        );
    }
}

// SPDX-License-Identifier: Zlib
package;

import utest.Runner;
import utest.ui.Report;

final class TestSuiteMain {

    private static function main() {

        final runner = new Runner();

        runner.addCase(new MitTest());

        Report.create(runner);
        runner.run();
    }
}

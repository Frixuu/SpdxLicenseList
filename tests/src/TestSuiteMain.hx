// SPDX-License-Identifier: Zlib
package;

import utest.Runner;
import utest.ui.Report;

final class TestSuiteMain {

    private static function main() {
    
        final runner = new Runner();
        
        runner.addCase(new MitTest());
        runner.addCase(new FakeLicenseTest());
        runner.addCase(new NokiaQtExceptionTest());
        
        runner.addCase(new expressions.ExpressionStringifyTest());
        
        Report.create(runner);
        runner.run();
    }
}

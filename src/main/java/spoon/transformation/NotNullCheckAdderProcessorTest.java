package spoon.transformation;

import org.junit.Test;
import spoon.Launcher;

public class NotNullCheckAdderProcessorTest {
	@Test
	public void testCompileSourceCodeAfterProcessSourceCodeWithNotNullCheckAdderProcessor() throws Exception {
		final String[] args = {
				"-i", "src/test/resources/src/",
				"-o", "target/spooned/",
				"-p", "fr.inria.gforge.spoon.transformation.notnullcheck.NotNullCheckAdderProcessor",
				"--compile"
		};

		final Launcher launcher = new Launcher();
		launcher.setArgs(args);
		launcher.run();
	}
}

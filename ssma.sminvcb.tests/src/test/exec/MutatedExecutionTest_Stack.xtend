package test.exec

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import ssma.sminvcb.execution.SminvcbDslExecutor

import static org.junit.Assert.*
import org.junit.BeforeClass
import ssma.sminvcb.sminvcbDsl.SminvcbModel
import org.junit.Before
import ssma.sminvcb.tests.BothLanguagesInjectorProvider
import ssma.sminvcb.tests.SminvcbParserUtil

import exa.stack.app.Stack1

/**
 * Test the execution of the stack-example.
 */
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(BothLanguagesInjectorProvider))
class MutatedExecutionTest_Stack extends SminvcbParserUtil {

	@Inject
	var SminvcbDslExecutor executor

	// always the same for all tests
	var SminvcbModel model

	val inp = " events push push pop pop push pop"


	@Test def void checkStack_Concrete() {
		val inp2 = stackcb_concrete + inp
		model = parseComposedModel(stackspec_concrete, inp2)
		try {
			executor.processModel(model)

		} catch (RuntimeException e) {
			// do nothing is it stems from mutation
			if (e.getClass().simpleName.equals("RuntimeException")) {
				// do nothing
			} else {
				throw e
			}
		}
	}


	@Test def void checkStack_Abstract() {
		val inp2 = stackcb_abstract + inp
		model = parseComposedModel(stackspec_abstract, inp2)
		try {
			executor.processModel(model)

		} catch (RuntimeException e) {
			// do nothing is it stems from mutation
			if (e.getClass().simpleName.equals("RuntimeException")) {
				// do nothing
			} else {
				throw e
			}
		}
	}

}

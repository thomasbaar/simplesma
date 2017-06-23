package ssma.sminvcb.tests

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

/**
 * Test the execution of the stack-example.
 */
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(BothLanguagesInjectorProvider))
class ExecutionTest_Stack extends SminvcbParserUtil {

	@Inject
	var SminvcbDslExecutor executor

	// always the same for all tests
	var SminvcbModel model

	@Before
	def void setUp() {
	}
	
	val inp = " events push push pop pop push pop"
	


	@Test def void checkStack_Concrete() {
		val inp2 = stackcb_concrete + inp
		model = parseComposedModel(stackspec_concrete, inp2)
		executor.processModel(model)
	}

	@Test def void checkStack_Abstract() {
		val inp2 = stackcb_abstract + inp
		model = parseComposedModel(stackspec_abstract, inp2)
		executor.processModel(model)
	}


}
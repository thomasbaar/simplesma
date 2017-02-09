package ssma.sminvcb.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import ssma.sminvcb.execution.SminvcbDslExecutor

import static org.junit.Assert.*

/**
 * Test the execution of the stack-example.
 */
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(BothLanguagesInjectorProvider))
class ExecutionTest_Stack extends SminvcbParserUtil{
	
	@Inject
	var SminvcbDslExecutor executor
	
	
	@Test def void checkNotNull() {
		val inp2 = stackcb + " events push push pop pop push pop"
		val model = parseComposedModel(stack, inp2)
		assertNotNull(model)
	}
	
	
	@Test def void checkExecution() {
		val inp2 = stackcb + " events push push pop pop push pop"
		val model = parseComposedModel(stack, inp2)
		executor.processModel(model)
	}
	
	
	
}
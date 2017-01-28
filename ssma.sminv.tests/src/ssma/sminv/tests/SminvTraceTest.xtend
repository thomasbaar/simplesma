package ssma.sminv.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.simulation.domain.Trace

import static org.junit.Assert.*
import org.junit.Before
import ssma.sminv.sminvDsl.Event

import static extension ssma.sminv.util.SminvDslUtil_Static.*
import ssma.sminv.sminvDsl.Var
import ssma.sminv.simulation.domain.Trace.ITraceListener

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SminvDslInjectorProvider))
class SminvTraceTest {

	@Inject extension ParseHelper<SminvModel>
	@Inject extension ValidationTestHelper

	val input1 = '''vars x y z 
	               states start a b c d
	               events e1 e2 e3 
	               transitions  
	               		start => a / x=1; 
	               		a => b e1 /y=z + x + 25;
	               		a => b e2;
	               		b => c e3 [y < 10] / z = 3;
	               		b => d e3 [y >= 10]/ z = 4;
	              '''

	var SminvModel model1
	var Event ev1_e1
	var Event ev1_e2
	var Event ev1_e3
	var Var v1_x
	var Var v1_y
	var Var v1_z
	var Trace trace1

	// executes before every test-method
	@Before
	def void initAttributes() {
		println
		println
		model1 = input1.parse

		ev1_e1 = model1.events.get(0)
		ev1_e2 = model1.events.get(1)
		ev1_e3 = model1.events.get(2)

		v1_x = model1.vars.get(0)
		v1_y = model1.vars.get(1)
		v1_z = model1.vars.get(2)
		trace1 = new Trace(
			model1,
			new MyTraceListener()
		)

	}

	@Test def void checkModel() {
		model1.assertNoErrors
		assertTrue(trace1.states.size == 2)
		val binding_a = trace1.lastBinding
		assertSame(1, binding_a.getVal(v1_x))
	}

	// e1 -> e3
	@Test def void seq1() {

		trace1.occurred(ev1_e1)
		assertTrue(trace1.states.size == 3)
		val binding_b = trace1.lastBinding
		assertSame(1, binding_b.getVal(v1_x))
		assertSame(26, binding_b.getVal(v1_y))

		trace1.occurred(ev1_e3)
		assertTrue(trace1.states.size == 4)
		val binding_d = trace1.lastBinding
		assertSame(1, binding_d.getVal(v1_x))
		assertSame(26, binding_d.getVal(v1_y))
		assertSame(4, binding_d.getVal(v1_z))
	}

	// e2 -> e3
	@Test def void seq2() {

		trace1.occurred(ev1_e2)
		assertTrue(trace1.states.size == 3)
		val binding_b = trace1.lastBinding
		assertSame(1, binding_b.getVal(v1_x))
		assertSame(0, binding_b.getVal(v1_y))

		trace1.occurred(ev1_e3)
		assertTrue(trace1.states.size == 4)
		val binding_c = trace1.lastBinding
		assertSame(1, binding_c.getVal(v1_x))
		assertSame(0, binding_c.getVal(v1_y))
		assertSame(3, binding_c.getVal(v1_z))
	}

	// e2 -> e2 -> e1 -> e3
	@Test def void seqUnexpected() {

		trace1.occurred(ev1_e2)
		assertTrue(trace1.states.size == 3)
		val binding_b = trace1.lastBinding
		assertSame(1, binding_b.getVal(v1_x))
		assertSame(0, binding_b.getVal(v1_y))

		trace1.occurred(ev1_e2) // rejected
		assertTrue(trace1.states.size == 3)

		trace1.occurred(ev1_e1) // rejected
		assertTrue(trace1.states.size == 3)

		trace1.occurred(ev1_e3)
		assertTrue(trace1.states.size == 4)
		val binding_c = trace1.lastBinding
		assertSame(1, binding_c.getVal(v1_x))
		assertSame(0, binding_c.getVal(v1_y))
		assertSame(3, binding_c.getVal(v1_z))
	}

	static class MyTraceListener implements ITraceListener {

		override info(String s) {
			println("INFO: " + s)
		}

		override warn(String s) {
			println("WARN: " + s)
		}

		override error(String s) {
			println("ERROR: " + s)
		}

	}
}
	

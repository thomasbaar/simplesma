package ssma.sminv.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith
import ssma.sminv.tests.SminvDslInjectorProvider
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.util.SminvDslUtil

import static org.junit.Assert.*
import org.eclipse.xtext.junit4.validation.ValidationTestHelper

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SminvDslInjectorProvider))
class SminvUtilTest {
	@Inject extension ParseHelper<SminvModel>

	@Inject extension SminvDslUtil
	@Inject extension ValidationTestHelper

	@Test
	def void testStartState() {
		val model = '''vars  a a1 states start s1 s2 events ev1 transitions start => s1;
		'''.parse
		model.assertNoErrors
		val startState = model.states.get(0)
		val s1State = model.states.get(1)
		val s3State = model.states.get(2)
		assertTrue(startState.isStartState)
		assertFalse(s1State.isStartState)
		assertFalse(s3State.isStartState)
	}

	@Test
	def void testGetPrintName_Transition() {
		val model = '''vars  a a1 states start s1 s2 events ev1 transitions start => s1; s1 => s2 ev1 [45 < a1] / a += 1 a1 = 4*a;
		'''.parse
		model.assertNoErrors
		val t1=model.transitions.get(0)
		val t2=model.transitions.get(1)
		assertEquals("start => s1 ", t1.printName)
		assertEquals("s1 => s2 ev1 [(45 < a1)] / a += 1 a1 = (4 * a) ", t2.printName)
	}
	
	@Test
	def void testGetInvariants_Empty() {
		val model = '''vars  a a1 states start s1 s2 events ev1 transitions start => s1;
		'''.parse
		model.assertNoErrors
		assertTrue(model.invariants.isEmpty)
	}

	@Test
	def void testGetInvariants_NonEmpty() {
		val model = '''vars  a a1 states start s1 s2 events ev1 transitions start => s1; invariants s1: true;
		'''.parse
		model.assertNoErrors
		assertFalse(model.invariants.isEmpty)
	}

}
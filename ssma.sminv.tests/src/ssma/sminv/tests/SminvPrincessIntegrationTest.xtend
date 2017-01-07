package ssma.sminv.tests
 
import com.google.inject.Inject
import de.htwberlin.selab.princessintegration.PrincessFacade
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith
import ssma.sminv.tests.SminvDslInjectorProvider
import ssma.sminv.pogenerator.SminvDslPOGenerator
import ssma.sminv.printing.SminvDslPrincessPrinter
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.util.SminvDslUtil

import static extension org.junit.Assert.*

/**
 * Test of Princess Integration based on generated proof obligations
 */
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SminvDslInjectorProvider))
class SminvPrincessIntegrationTest {
	@Inject extension ParseHelper<SminvModel>

	@Inject extension SminvDslUtil
	@Inject PrincessFacade out
	@Inject extension SminvDslPrincessPrinter
	@Inject extension SminvDslPOGenerator

	val small = '''vars v1 v2
	               states start a b c
	               events ev1 
	               transitions  start => a / v1=3;
	                            a => b ev1 [v1 < 5] /v1 += 1;
	                            a => c [v1 < 5] / v1 += 1;
	               invariants a: v1 > 2;
	                          b: v1 > 3; 
	                          b: v1 < 6;
	                          c: v1 < 5;
	                          '''

	@Test
	def void princessIntegration_small() {
		val model = small.parse
		val t1 = model.transitions.get(0)
		val t2 = model.transitions.get(1)
		val t3 = model.transitions.get(2)

		val t1PO = t1.PO_InvPreservation.princessRepr
		val t2PO = t2.PO_InvPreservation.princessRepr
		val t3PO = t3.PO_InvPreservation.princessRepr

		" \\problem{ ((true & true) -> (3 > 2)) }".assertEquals(t1PO)
		"\\universalConstants {  int v1;} \\problem{ (((v1 > 2) & (v1 < 5)) -> (((v1 + 1) > 3) & ((v1 + 1) < 6))) }".
			assertEquals(t2PO)

	// invoking the prover
		var result = out.prove(t1PO, "PO for t1")
		assertTrue(result.isProven);
		
		result = out.prove(t2PO, "PO for t2")
		assertTrue(result.isProven);
		
		// a PO that cannot be proven 
		result = out.prove(t3PO, "PO for t3")
		assertFalse(result.isProven);
		assertEquals("v1 = 4", result.counterexample);
		
	}
	
	
}
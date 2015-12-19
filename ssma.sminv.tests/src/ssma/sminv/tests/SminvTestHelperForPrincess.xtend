package ssma.sminv.tests

import com.google.inject.Inject
import ssma.fml.fmlDsl.Term
import ssma.sminv.printing.SminvDslPrincessPrinter

import static extension org.junit.Assert.*

//
	// NOTE: we cannot move the following to SminvTestHelper
	// since our injected ScpurDslPrincessPrinter collides with
	// injected SminvPrincessPrinter
	//

class SminvTestHelperForPrincess {
	@Inject extension SminvDslPrincessPrinter


	/**
	 * assertion based on PrincessPrinter
	 * parameter input: without the ending ';'
	 */
	public def assertPrincessReprFromTerm(Term t, CharSequence expected) {
		expected.assertEquals(
			t.princessRepr
		)
	}
	
}
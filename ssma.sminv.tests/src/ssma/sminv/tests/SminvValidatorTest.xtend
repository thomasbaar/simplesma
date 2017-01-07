package ssma.sminv.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import ssma.sminv.tests.SminvDslInjectorProvider
import ssma.sminv.sminvDsl.SminvDslPackage
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.validation.SminvDslValidator

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SminvDslInjectorProvider))
class SminvValidatorTest {
	@Inject extension ParseHelper<SminvModel>
	@Inject extension ValidationTestHelper

	@Inject extension SminvTestHelper

	// /////////////////////////////////////////////////////////////////
	// Testing NameIsUnique-validator  
	// /////////////////////////////////////////////////////////////////
	@Test
	def void testDuplicateVariables() {
		val model = '''vars  a a states start s1 events ev1 transitions start => s1;
		'''.parse
		model.assertError(SminvDslPackage::eINSTANCE.^var, null)
	}

	// ////////////////////////////////////////////////////////////////
	// Testing Sminv Validators
	// ////////////////////////////////////////////////////////////////
	// testing types for guards and invariants
	@Test
	def void rightTypeForGuard() {
		'''true'''.guardToSminvInput.parse.assertNoErrors
	}


//	//TODO: goes through when executed alone but fails when testing whole project
//	//TODO: decouple validators from tests !!!
//	@Test
//	def void wrongTypeForGuard() {
//		'''5'''.guardToSminvInput.assertGuardValidationError
//	}

	@Test
	def void rightTypeForInv() {
		'''true'''.invToSminvInput.parse.assertNoErrors
	}

	@Test
	def void rightTypeForInv_withVar() {
		'''v1 > 5'''.invToSminvInput.parse.assertNoErrors
	}

	@Test
	def void wrongTypeForInv() {
		'''5'''.invToSminvInput.assertInvValidationError
	}

	// testing post-state of transition
	@Test
	def void postStateIsNotAStartState() {
		'''vars v1 v2
	               states start a b
	               events ev1 
	               transitions  start => a;
	               	            a => b ev1;
	                            b => start;
		'''.parse.assertError(SminvDslPackage.Literals.TRANSITION,
			SminvDslValidator.STARTSTATE_IS_NO_TRANSITIONTARGET)
	}

	// testing out-going states for start state
	@Test
	def void missingOuttransitionForStartState() {
		'''vars v1 v2
	               states start a b
	               events ev1 
	               transitions  a => b ev1;
		'''.parse.assertError(SminvDslPackage.Literals.STATE, SminvDslValidator.STARTSTATE_HAS_ONE_OUTTRANSITION)
	}

	@Test
	def void tooManyOuttransitionForStartState() {
		'''vars v1 v2
	               states start a b
	               events ev1 
	               transitions  start => b; start => a;
		'''.parse.assertError(SminvDslPackage.Literals.STATE, SminvDslValidator.STARTSTATE_HAS_ONE_OUTTRANSITION)
	}

	@Test
	def void outtransitionForStartStateDoesNotHaveEvent() {
		'''vars v1 v2
	               states start a b
	               events ev1 
	               transitions  start => b ev1;
		'''.parse.assertError(SminvDslPackage.Literals.TRANSITION, SminvDslValidator.OUTTRANSITION_NO_EVENT)
	}

	@Test
	def void outtransitionForStartStateDoesNotHaveGuard() {
		'''vars v1 v2
	               states start a b
	               events ev1 
	               transitions  start => b [true];
		'''.parse.assertError(SminvDslPackage.Literals.TRANSITION, SminvDslValidator.OUTTRANSITION_NO_GUARD)
	}

	@Test
	def void startStateDoesNotInvariant() {
		'''vars v1 v2
	               states start a b
	               events ev1 
	               transitions  start => b;
	               invariants a: 4 < 6;
	                          start: true;
		'''.parse.assertError(SminvDslPackage.Literals.STATE, SminvDslValidator.STARTSTATE_HAS_NO_INVARIANT)
	}

	@Test
	def void multipleUpdatesPerVariable() {
		'''vars v1 v2 v3
	               states start a b
	               events ev1 
	               transitions  start => a /v1=0 v2=0;
	                           a => b / v1 = 5 v2=3 v1 += 4
	               invariants a: 4 < 6;
	                          start: true;
		'''.parse.assertError(SminvDslPackage.Literals.TRANSITION,
			SminvDslValidator.TRANSITION_UPDATES_HAS_UNIQUE_LHSS)
	}

	//
	// Semantic checks using Princess
	//
	// temporarily commented out due to inactive validation check
//	@Test
//	def void transitionDoesNotPreserveInvariant() {
//		'''vars v1 v2
//	               states start a b c
//	               events ev1 
//	               transitions  start => a / v1=3;
//	                            a => c [v1 < 5] / v1 += 1;
//	               invariants a: v1 > 2;
//	                          c: v1 < 5;
//	    '''.parse.assertError(SminvDslPackage.Literals.TRANSITION, SminvDslValidator.TRANSITION_MUST_PRESERVE_INVARIANTS)
//	}
	@Test
	def void transitionDoesNotPreserveSelectedInvariant() {
		'''vars v1 v2
	               states start a b c
	               events ev1 
	               transitions  start => a / v1=3;
	                            a => c [v1 < 5] / v1 += 1;
	               invariants a: v1 > 2;
	                          c: v1 < 5;
	    '''.parse.assertError(SminvDslPackage.Literals.INV,
			SminvDslValidator.INCOMING_TRANSITION_MUST_PRESERVE_INVARIANT)
	}

	@Test
	def void transitionPreservesInvariant() {
		'''vars v1 v2
	               states start a b c
	               events ev1 
	               transitions  start => a / v1=3;
	                            a => c ev1 [v1 < 5] / v1 += 1;
	               invariants a: v1 > 2;
	                          c: v1 < 6;
	    '''.parse.assertNoErrors
	}

	@Test
	def void transitionsDeterministic() {
		'''vars v1 v2
	               states start a b c d e
	               events ev1 
	               transitions  start => a / v1=3;
	                            a => b ev1 [v1 < 1];
	                            a => c ev1 [v1 > 1 && v1 < 5];
	                            a => d ev1 [v1 > (2 + 4)];
	    '''.parse.assertNoErrors
	}

	@Test
	def void transitionNonDeterministic1() {
		'''vars v1 v2
	               states start a b c d e
	               events ev1 
	               transitions  start => a / v1=3;
	                            a => b ev1 [v1 < 3];
	                            a => c ev1 [v1 > 1 && v1 < 5];
	                            a => d ev1 [v1 > (2 + 4)];
	    '''.parse.assertError(SminvDslPackage.Literals.STATE,
			SminvDslValidator.OUTGOING_TRANSITIONS_MUST_NOT_BE_NONDETERMINISTIC)
	}
	
	@Test
	def void transitionDead() {
		'''vars v1 v2
	               states start a b c d e
	               events ev1 
	               transitions  start => a / v1=3;
	                            a => b ev1 [v1 < 1];
	               invariants
	               		a : v1 > 2;             
	    '''.parse.assertError(SminvDslPackage.Literals.TRANSITION,
			SminvDslValidator.TRANSITION_MUST_BE_ALIVE)
	}
	
	
}
	


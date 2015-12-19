package ssma.sminv.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
//import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import ssma.sminv.SminvDslInjectorProvider
import ssma.sminv.pogenerator.SminvDslPOGenerator
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.util.SminvDslUtil

/**
 * Testing the PO-generation but also the SminvPrincessPrinter
 */
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SminvDslInjectorProvider))
class SminvPOGeneratorTest {

	@Inject extension ParseHelper<SminvModel>
	
//	@Inject extension ValidationTestHelper

	@Inject extension SminvTestHelper
	@Inject extension SminvDslUtil
	@Inject extension SminvTestHelperForPrincess
	@Inject extension SminvDslPOGenerator

	val small = '''vars v1 v2
	               states start a b c
	               events ev1 
	               transitions  start => a / v1=3;
	                            a => b ev1 [v1 < 5] /v1 += 1;
	                            a => b ev1 [v1 < 5] /v2 = v1 - 5 v1 = v1 + 1;
	                            a => c ev1 /v2 = v1 - 5 v1 = v1 + 1;
	                            a => c ev1 [v1 > 1 && v1 < 5];
	                            b => c ;
	                            b => c ;
	                            b => a [v1 < 2];
	               invariants a: v1 > 2;
	                          b: v1 > 3;
	                          c: v1 < v2 -> v2 == 23 && v1 >= 11;
	                          c: v1 < v2 -> true;
	                          '''

	@Test
	def void invPreservation_small() {
		val model = small.parse
//		model.assertNoErrors  //TODO: have to comment out since otherwise the validator would complain
                              // TODO: how to switch-off some validations for assetNoErrors ???
		val t1 = model.transitions.get(0)
		val t2 = model.transitions.get(1)
		val t3 = model.transitions.get(2)
		val t4 = model.transitions.get(3)

		val i4 = model.invariants.get(3)

		val po1 = t1.PO_InvPreservation
		val po2 = t2.PO_InvPreservation
		val po3 = t3.PO_InvPreservation
		val po4 = t4.PO_InvPreservation

		po1.assertReprFromTerm("((true && true) -> (3 > 2))")
		po2.assertReprFromTerm("(((v1 > 2) && (v1 < 5)) -> ((v1 + 1) > 3))")
		po3.assertReprFromTerm("(((v1 > 2) && (v1 < 5)) -> ((v1 + 1) > 3))")
		po4.
			assertReprFromTerm(
				"(((v1 > 2) && true) -> ((((v1 + 1) < (v1 - 5)) -> (((v1 - 5) == 23) && ((v1 + 1) >= 11))) && (((v1 + 1) < (v1 - 5)) -> true)))"
			)

		val po41 = t4.getPO_InvPreservation_ForPostInvariant(i4)
		po41.assertReprFromTerm("(((v1 > 2) && true) -> (((v1 + 1) < (v1 - 5)) -> true))")

		//	the expected output for the Princess prover
		po1.assertPrincessReprFromTerm(" \\problem{ ((true & true) -> (3 > 2)) }")
		po2.assertPrincessReprFromTerm(
			"\\universalConstants {  int v1;} \\problem{ (((v1 > 2) & (v1 < 5)) -> ((v1 + 1) > 3)) }")

	}

	@Test
	def void nondetermism_small() {
		val model = small.parse
//		model.assertNoErrors
		val t_a_c_1 = model.transitions.get(3)
		val t_a_c_2 = model.transitions.get(4)
		val t_b_c_1 = model.transitions.get(5)
		val t_b_c_2 = model.transitions.get(6)

		val po1 = t_a_c_1.getPO_NonDeterminism(t_a_c_2)
		val po2 = t_b_c_1.getPO_NonDeterminism(t_b_c_2)

		po1.assertReprFromTerm("((v1 > 2) -> (!(true && ((v1 > 1) && (v1 < 5)))))")
		po2.assertReprFromTerm("((v1 > 3) -> (!(true && true)))")

		//	the expected output for the Princess prover
		po1.assertPrincessReprFromTerm("\\universalConstants {  int v1;} \\problem{ ((v1 > 2) -> (!(true & ((v1 > 1) & (v1 < 5))))) }")
		po2.assertPrincessReprFromTerm("\\universalConstants {  int v1;} \\problem{ ((v1 > 3) -> (!(true & true))) }")

	}
	
		@Test
	def void deadtransition_small() {
		val model = small.parse
//		model.assertNoErrors
		val t_b_a_1 = model.transitions.get(7)
		
		val po = t_b_a_1.PO_AliveTransition
	
		po.assertReprFromTerm("((v1 > 3) && (v1 < 2))")

		po.assertPrincessReprFromTerm("\\existentialConstants {  int v1;} \\problem{ ((v1 > 3) & (v1 < 2)) }", false)
		
		}

	

}
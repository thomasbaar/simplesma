package ssma.sminvcb.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import ssma.fml.validation.FmlDslValidator
import ssma.sminv.sminvDsl.SminvDslPackage
import ssma.sminvcb.sminvcbDsl.SminvcbDslPackage
import ssma.sminvcb.validation.SminvcbDslValidator

/**
 * A "multi-language test that need first to 
 * parse another file.
 * 
 * The 'first language' is here sminv, the 'second language' s sminvcb
 * 
 * Note, that the first language model must be parsed "manually", since
 * the parseHelper probably works only for the second language.
 * Also note, we need a own InjectorProvider.
 * 
 */
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(BothLanguagesInjectorProvider))
class SminvcbParserTest extends SminvcbParserUtil{


	val inp1_First = '''project myprojsminv
						vars v
			               states start a b
			               events ev1 
			               transitions  start => a;
			                            a => b ev1 [3 < 5];
		'''
	val inp1_Sec = '''project cb refers_to  myprojsminv
						adapter_class ""
						code_vars
						state_preds
						global_preds
	'''
	
	
	//
	// Incorrect variants of inp1_Sec
	//
	val inp1_Sec1 = '''project cb refers_to  myprojsminv
						adapter_class ""
						code_vars c_s c_s //double name
						state_preds
						global_preds
	'''
	
	val inp1_Sec2 = '''project cb refers_to  myprojsminv
						adapter_class ""
						import myprojsminv.*;
						code_vars  c_s v // overlap with var
						                 // becomes an error only by the import ?!
						state_preds
						global_preds
	'''

	val inp1_Sec3 = '''project cb refers_to  myprojsminv
						adapter_class ""
						import myprojsminv.*;
						code_vars  
						state_preds
							a: 5; // no bool
						global_preds
	'''
	
	val inp1_Sec4 = '''project cb refers_to  myprojsminv
						adapter_class ""
						import myprojsminv.*;
						code_vars  
						state_preds
						global_preds
							bla: 5; // no bool
	'''
	
	val inp1_Sec5 = '''project cb refers_to  myprojsminv
						adapter_class ""
						import myprojsminv.*;
						code_vars  
						state_preds
							a: 5 < v; // statevar used
						global_preds
	'''
	
	
	
	
	

	@Test def void checkInp1() {
		val model = parseComposedModel(inp1_First, inp1_Sec)
		validationTester.assertNoIssues(model)
	}


	@Test def void checkStack() {
		val model = parseComposedModel(stack, stackcb)
		validationTester.assertNoIssues(model)
	}
	
	//
	// Incorrect cases
	//

	@Test def void checkInp11() {
		val model = parseComposedModel(inp1_First, inp1_Sec1)
		validationTester.assertError(model, SminvDslPackage::eINSTANCE.^var, null)
	}


	@Test def void checkInp13() {
		val model = parseComposedModel(inp1_First, inp1_Sec3)
		validationTester.assertError(model, SminvcbDslPackage::eINSTANCE.statePred, FmlDslValidator.WRONG_TYPE)
	}

	@Test def void checkInp14() {
		val model = parseComposedModel(inp1_First, inp1_Sec4)
		validationTester.assertError(model, SminvcbDslPackage::eINSTANCE.globalPred, FmlDslValidator.WRONG_TYPE)
	}

	@Test def void checkInp15() {
		val model = parseComposedModel(inp1_First, inp1_Sec5)
		validationTester.assertError(model, SminvcbDslPackage::eINSTANCE.statePred, SminvcbDslValidator.STATEPRED_ONLY_WITH_CODEVARS)
	}



////
//// Helper methods
////
//
//	def public SminvcbModel parseComposedModel(String inp_First, String inp_Sec){
//		val rs = resourceSetProvider.get
//
//		// // parsing language1-model with parseHelper does not work ;-(
////		val model1 = parseHelperFirst.parse(inputFirst,rs)
////		
////		assertNotNull(model1)
////		validationTester.assertNoIssues(model1)
//		val Resource res1 = rs.createResource(URI.createURI("sample.sminv"))
//		// parse some contents
//		res1.load(new StringInputStream(inp_First), emptyMap)
//		val model1 = res1.contents.head as SminvModel
//		assertNotNull(model1)
//		validationTester.assertNoIssues(model1)
//
//		val model2 = parseHelperSec.parse(inp_Sec, rs)
//
//		assertNotNull(model2)
//		model2
//		
//	}

}

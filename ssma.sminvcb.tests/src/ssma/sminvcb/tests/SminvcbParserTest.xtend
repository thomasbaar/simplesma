package ssma.sminvcb.tests

import com.google.inject.Inject
import com.google.inject.Provider

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.resource.XtextResourceSet
import org.eclipse.xtext.util.StringInputStream

import org.eclipse.emf.common.util.URI

import org.junit.Test
import org.junit.runner.RunWith

import ssma.sminvcb.sminvcbDsl.SminvcbModel
import org.eclipse.emf.ecore.resource.Resource
import ssma.sminv.sminvDsl.SminvModel

import static org.junit.Assert.*
import ssma.sminv.sminvDsl.SminvDslPackage
import ssma.fml.validation.FmlDslValidator
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
class SminvcbParserTest {

	// parse helper for first language  does not work :-(
//	@Inject ParseHelper<SminvModel> parseHelperFirst
	// parse helper for second language
	@Inject ParseHelper<SminvcbModel> parseHelperSec
	// Allows to obtain a new resource set
	@Inject Provider<XtextResourceSet> resourceSetProvider
	// Helper to test all validation rules and ensure resolved links
	@Inject ValidationTestHelper validationTester

	val inp1_First = '''project myprojsminv
						vars v
			               states start a b
			               events ev1 
			               transitions  start => a;
			                            a => b ev1 [3 < 5];
		'''
	val inp1_Sec = '''refers_to  myprojsminv
						code_vars
						state_preds
						global_preds
	'''
	
	
	//
	// Incorrect variants of inp1_Sec
	//
	val inp1_Sec1 = '''refers_to  myprojsminv
						code_vars c_s c_s //double name
						state_preds
						global_preds
	'''
	
	val inp1_Sec2 = '''refers_to  myprojsminv
						import myprojsminv.*;
						code_vars  c_s v // overlap with var
						                 // becomes an error only by the import ?!
						state_preds
						global_preds
	'''

	val inp1_Sec3 = '''refers_to  myprojsminv
						import myprojsminv.*;
						code_vars  
						state_preds
							a: 5; // no bool
						global_preds
	'''
	
	val inp1_Sec4 = '''refers_to  myprojsminv
						import myprojsminv.*;
						code_vars  
						state_preds
						global_preds
							bla: 5; // no bool
	'''
	
	val inp1_Sec5 = '''refers_to  myprojsminv
						import myprojsminv.*;
						code_vars  
						state_preds
							a: 5 < v; // statevar used
						global_preds
	'''
	
	
	
	val inp2_First = '''project sminv_stack
							vars num
			               	states start isEmpty nonEmpty
			               	events push pop
			               	transitions  
			               		start => isEmpty;
			               		isEmpty => nonEmpty push /num += 1;
			               		nonEmpty => nonEmpty push /num += 1;
			               		nonEmpty => nonEmpty pop [num > 1] /num -= 1;
			               		nonEmpty => isEmpty pop [num==1] /num -= 1;
		'''
	val inp2_Sec = '''project sminv_state_codebridge 
						refers_to sminv_stack
						import sminv_stack.*;
						code_vars c_s
						state_preds
							isEmpty: c_s==0;
							nonEmpty: c_s>0;
						global_preds
							def_num : num == c_s;
	'''
	
	

	@Test def void checkInp1() {
		val model = parseComposedModel(inp1_First, inp1_Sec)
		validationTester.assertNoIssues(model)
	}


	@Test def void checkInp2() {
		val model = parseComposedModel(inp2_First, inp2_Sec)
		validationTester.assertNoIssues(model)
	}
	
	//
	// Incorrect cases
	//

	@Test def void checkInp11() {
		val model = parseComposedModel(inp1_First, inp1_Sec1)
		validationTester.assertError(model, SminvDslPackage::eINSTANCE.^var, null)
	}

// TODO: fix this
//	@Test def void checkInp12() {
//		val model = parseComposedModel(inp1_First, inp1_Sec2)
//		validationTester.assertError(model, SminvDslPackage::eINSTANCE.^var, null)
//	}

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



//
// Helper methods
//

	def private SminvcbModel parseComposedModel(String inp_First, String inp_Sec){
		val rs = resourceSetProvider.get

		// // parsing language1-model with parseHelper does not work ;-(
//		val model1 = parseHelperFirst.parse(inputFirst,rs)
//		
//		assertNotNull(model1)
//		validationTester.assertNoIssues(model1)
		val Resource res1 = rs.createResource(URI.createURI("sample.sminv"))
		// parse some contents
		res1.load(new StringInputStream(inp_First), emptyMap)
		val model1 = res1.contents.head as SminvModel
		assertNotNull(model1)
		validationTester.assertNoIssues(model1)

		val model2 = parseHelperSec.parse(inp_Sec, rs)

		assertNotNull(model2)
		model2
		
	}

}

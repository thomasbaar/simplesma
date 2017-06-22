package ssma.sminvcb.tests

import com.google.inject.Inject
import com.google.inject.Provider
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.resource.XtextResourceSet
import org.eclipse.xtext.util.StringInputStream
import org.junit.runner.RunWith
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminvcb.sminvcbDsl.SminvcbModel

import static org.junit.Assert.*

/**
 * Provides parsing support and example inputs
 */
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(BothLanguagesInjectorProvider))
class SminvcbParserUtil {
	
	
	@Inject ParseHelper<SminvcbModel> parseHelperSec
	// Allows to obtain a new resource set
	@Inject Provider<XtextResourceSet> resourceSetProvider
	// Helper to test all validation rules and ensure resolved links
	@Inject public ValidationTestHelper validationTester
	
	
	
	//
	//  Example inputs
	//
	
	// stack example
	
	public  val stackspec_concrete= '''project sminv_stack
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
	public  val stackcb_concrete = '''project sminv_state_codebridge 
						refers_to sminv_stack
						adapter_class "exa.stack.adapter.AppAdapter_Stack"
						import sminv_stack.*;
						code_vars c_s
						state_preds
							isEmpty: c_s == 0;
							nonEmpty: c_s>0;
	//					global_preds
	//						def_num : num == c_s;
	'''
	

	public  val stackspec_abstract= '''project sminv_stack
							vars num
			               	states start init
			               	events push pop
			               	transitions  
			               		start => init;
			               		init => init push;
			               		init => init pop;
		'''
	public  val stackcb_abstract = '''project sminv_state_codebridge 
						refers_to sminv_stack
						adapter_class "exa.stack.adapter.AppAdapter_Stack"
						import sminv_stack.*;
						code_vars c_s
//						state_preds
//							isEmpty: c_s == 0;
//							nonEmpty: c_s>0;
	'''
	
	
	
	
//
// Helper methods
//

	def public SminvcbModel parseComposedModel(String inp_First, String inp_Sec){
		val rs = resourceSetProvider.get

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
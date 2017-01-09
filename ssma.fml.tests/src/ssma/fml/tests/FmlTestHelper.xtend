package ssma.fml.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import ssma.fml.fmlDsl.FmlModel
import ssma.fml.typing.TermType
import ssma.fml.typing.TermTypeProvider

import static extension org.junit.Assert.*
import ssma.fml.printing.FmlDslPrinter
import ssma.fml.fmlDsl.Term

class FmlTestHelper extends AbstractFmlTestHelper {

	@Inject extension ParseHelper<FmlModel>
	@Inject extension ValidationTestHelper
	@Inject extension TermTypeProvider
	@Inject extension FmlDslPrinter

	/** assertion based on TermTypeProvider
	 * 
	 */
	override assertType(CharSequence input, TermType expectedType) {
		val model = input.parse
		model.assertNoErrors // check syntactic correctness first
		expectedType.assertSame(model.terms.last.t.typeFor)
	}
	
	
	override assertValue(CharSequence input, CharSequence bindingActions, boolean expected){
		throw new UnsupportedOperationException("not implemented here")
	} 
	
	override getRightStringRepr(Term t) {
		t.stringRepr
	}


}
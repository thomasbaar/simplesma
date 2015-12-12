package ssma.sminv.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import ssma.sminv.SminvDslInjectorProvider
import ssma.sminv.sminvDsl.SminvModel
  
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SminvDslInjectorProvider))
class SminvParserTest {
	@Inject extension ParseHelper<SminvModel>
	@Inject extension ValidationTestHelper

	// possible correct inputs
	val minimal = '''vars states start a events ev1 transitions start => a;'''

	val smallWithoutVars = '''vars
	               states start a b
	               events ev1 
	               transitions  start => a;
	                            a => b ev1 [3 < 5];'''

	val smallWithVars = '''vars v1
	               states start a b
	               events ev1 
	               transitions  start => a;
	                            a => b ev1 [v1 < 5] /v1 += 1;'''

	val runningExample = '''
vars  collected bill

states start idle waitingForMoney paid

events cardInserted coinInserted

transitions 

start => idle / collected = 0 bill = 3;

idle => waitingForMoney cardInserted ;

waitingForMoney => waitingForMoney  coinInserted [collected < bill - 1 ] / collected += 1;

waitingForMoney => paid coinInserted [collected == bill - 1] / collected += 1;

paid => idle / collected = 0;'''




	@Test def test_minimal() {minimal.assertParseNoError}
	@Test def test_smallWithoutVars() {smallWithoutVars.assertParseNoError}
	@Test def test_smallWithVars() {smallWithVars.assertParseNoError}
	@Test def test_runningExample() {runningExample.assertParseNoError}
	
	
	def void assertParseNoError(CharSequence inp) {
		inp.parse.assertNoErrors
	}


}
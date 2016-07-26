package ssma.frontend.pn.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import ssma.frontend.pn.pnDsl.PnModel
import ssma.frontend.pn.PnDslInjectorProvider

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(PnDslInjectorProvider))
class PnParserTest {
	@Inject extension ParseHelper<PnModel>
	@Inject extension ValidationTestHelper

	// possible correct inputs
	val minimal = '''project simple places p1 p2 initialization: p1 transitions t1: p1 => p1; invariants'''

	val runningExample = '''
project running 

places door_closed door_opened ready dest_selected dest_unselected elevator_runs elevator_stopped

initialization: door_closed dest_unselected

transitions 

t_openDoor : door_closed  elevator_stopped => door_opened;
t_closeDoor: door_opened                   => door_closed ready;
t_select   : dest_unselected               => dest_selected;
t_start    : ready dest_selected           => dest_unselected elevator_runs;
t_stop     : elevator_runs                 => elevator_stopped;

invariants
door_closed || ! (door_opened && ready);
ready && ! ready || (ready && ready);
'''




	@Test def test_minimal() {minimal.assertParseNoError}
	@Test def test_runningExample() {runningExample.assertParseNoError}
	
	
	def void assertParseNoError(CharSequence inp) {
		inp.parse.assertNoErrors
	}


}
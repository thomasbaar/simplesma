package ssma.sminv.simulation.domain

import com.google.inject.Inject
import java.time.Instant
import ssma.sminv.eval.Binding
//import ssma.sminv.eval.TermEvalProvider
import ssma.sminv.sminvDsl.Event
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.sminvDsl.State
import ssma.sminv.sminvDsl.Transition
//import ssma.sminv.util.SminvDslUtil

import static extension org.eclipse.xtext.EcoreUtil2.*

import static extension ssma.sminv.util.SminvDslUtil_Static.*
import static extension ssma.sminv.eval.TermEvalProvider.*

class ExecutionState {
//	@Inject extension SminvDslUtil
//	@Inject extension TermEvalProvider

	var Instant creationTime
	var State activeState
	/** Transition that was fired to enter 'this' */
	var Transition preTrans
	var Binding binding

	// for the start-state
	new(SminvModel model) {
		creationTime = Instant.now
		binding = new Binding()
		binding.init(model)
		val states = model.sd.states
//		val states = model.states  // TODO: why is this not the equivalent of line above and causes error?
		activeState = states.head
//		activeState = model.startState
		preTrans = null
	}

	/**
	 * Clients should used this constructor only together with an
	 * init()-call right afterwards 
	 */
	new() {
		creationTime = Instant.now
	}

	// for all other cases (state transition is attempted) the client 
	// - has first to create an ExecutionState object with nullary-constructor
	// - then has to call init()
	//
	// - this should also work for outgoing transition from start-state
	// which do not have event attached (event==null in this case)
	def init(ExecutionState preExecState, Event event) throws CreationException{
		if (preExecState == null) {
			throw new IllegalArgumentException("preExecState must not be null")
		}
		creationTime = Instant.now
		val preState = preExecState.activeState

		var Iterable<Transition> outTransitions

		outTransitions = preState.outgoingTransitions.filter[ev == event]
//		if (event == null) {
//			// TODO: have trouble with injection here
//			outTransitions = preState.outgoingTransitions.filter[ev == null]
//////			outTransitions = preState.outgoingTransitions
//////			outTransitions = preState.root.transitions.filter[pre == preState]
////			val root = preState.getContainerOfType(typeof(SminvModel))
//////			val trans = root.transitions
////			val trans = root.td.trans
////			outTransitions = trans.filter[ev == null]
//		} else {
//			outTransitions = preState.outgoingTransitions.filter[ev == event]
//		}
		if (outTransitions.isEmpty) {
			throw new CreationException(CreationException.NO_OUTTRANS_FOR_EVENT) // OK
		}

		val outTransitionsAfterGuardEval = outTransitions.filter[g == null || g.evalBool(preExecState.binding)]

		if (outTransitionsAfterGuardEval.isEmpty) {
			throw new CreationException(CreationException.NO_OUTTRANS_FOR_EVENT_AND_GUARD) // OK
		}

		val firedTrans = outTransitionsAfterGuardEval.head
		// set the attributes on this
		preTrans = firedTrans
		activeState = firedTrans.post
		val oldBinding = preExecState.binding
		binding = oldBinding.getCopy
		evalActionsOnBinding(firedTrans, oldBinding)

		// we return with an exception if we had a non-deterministic choice
		if (outTransitionsAfterGuardEval.size > 1) {
			throw new CreationException(CreationException.NON_DETERMINISTIC_CHOICE) // Should result in a warning
		}
	}

	def Binding getBinding() {
		binding
	}

	private def evalActionsOnBinding(Transition t, Binding oldBinding) {
		if (t.act == null || t.act.empty) {
			// nothing to do
			return
		}

		for (up : t.act) {
			val v = up.variable
			val vVal = oldBinding.getVal(v)
			val rhsVal = up.value.evalInt(oldBinding)
			var int resultingVal
			switch up.op {
				case '=': resultingVal = rhsVal
				case '+=': resultingVal = vVal + rhsVal
				case '-=': resultingVal = vVal - rhsVal
			}

			// store the result of the update in the new binding
			binding.setVal(v,
				resultingVal)
		}
	}

	static class CreationException extends Exception {
		val public static String NO_OUTTRANS_FOR_EVENT = "there is not outtransition for event"
		val public static String NO_OUTTRANS_FOR_EVENT_AND_GUARD = "there is not outtransition for event and guard"
		val public static String NON_DETERMINISTIC_CHOICE = "there were multiple transitions possible to fire. One was chosen."

		val String reason

		new(String msg) {
			super(msg)
			reason = msg
		}

		def String getReason() {
			reason
		}
	}

}

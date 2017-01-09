package ssma.sminv.simulation.domain

import java.time.Instant
import java.util.ArrayList
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.sminvDsl.Event
import ssma.sminv.eval.Binding

class Trace {
	
	var SminvModel statemachine
	var Instant creationTime
	var states = new ArrayList<ExecutionState>()
	var ExecutionState last

	new(SminvModel aStatemachine){
		creationTime = Instant.now
		statemachine = aStatemachine
		init()
	}	
	
	/**
	 * Initialization is done by entering the first state after start-state
	 */
	private def init(){
		// adding the start-state
		last=new ExecutionState(statemachine)
		states.add(last)

		// execute outgoing transition from start-state
		occurred(null)		
	}
	
	
	/**
	 * An event occurred that might cause a new last state in the trace.
	 * e can also be null.
	 */
	def occurred(Event e){
		val nextExecStateCandidate = new ExecutionState()
		try{
			nextExecStateCandidate.init(last,e)
			// now exception occurred
			candidateStateApproved(nextExecStateCandidate)
		}catch(ExecutionState.CreationException exc){
			if (exc.reason.equals(ExecutionState.CreationException.NON_DETERMINISTIC_CHOICE)){
				// we accept it
				candidateStateApproved(nextExecStateCandidate)
				//TODO: warn the user
			}
			// in all other cases we reject the candidateState and do nothing
			//TODO: make logging an transition attempt
		}
	}
	
	def private candidateStateApproved(ExecutionState state) {
		states.add(state)
		last = state
	}
	
	// for testing
	def Binding getLastBinding(){
		last.binding
	}
	
}
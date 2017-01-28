package ssma.sminv.simulation.domain

import java.time.Instant
import java.util.ArrayList
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.sminvDsl.Event
import ssma.sminv.eval.Binding
import java.util.List

class Trace {
	
	var SminvModel statemachine
	var Instant creationTime
	var states = new ArrayList<ExecutionState>()
	var ExecutionState last
	var Trace.ITraceListener listener


	new(SminvModel aStatemachine){
		this(aStatemachine, null)
	}	

	new(SminvModel aStatemachine, Trace.ITraceListener aListener){
		creationTime = Instant.now
		statemachine = aStatemachine
		listener=aListener
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
	
//	def void setListener(Trace.ITraceListener arg){
//		listener = arg
//	}
	
	private def void updateWarn(String msg){
		listener?.warn(msg)
	}
	
	private def void updateInfo(String msg){
		listener?.info(msg)
	}

	/**
	 * An event occurred that might cause a new last state in the trace.
	 * e can also be null.
	 */
	def occurred(Event e){
		val nextExecStateCandidate = new ExecutionState()
		try{
			nextExecStateCandidate.init(last,e)
			// no exception occurred
			candidateStateApproved(nextExecStateCandidate, e)
		}catch(ExecutionState.CreationException exc){
			if (exc.reason.equals(ExecutionState.CreationException.NON_DETERMINISTIC_CHOICE)){
				// we accept it
				candidateStateApproved(nextExecStateCandidate, e)
				updateWarn("Last exec-state was created non-deterministically")
			}
			// in all other cases we reject the candidateState and do nothing
			if (exc.reason.equals(ExecutionState.CreationException.NO_OUTTRANS_FOR_EVENT)){
				updateWarn("Event " + e.name + " was rejected due to missing outgoing transition")
			}
			if (exc.reason.equals(ExecutionState.CreationException.NO_OUTTRANS_FOR_EVENT_AND_GUARD)){
				updateWarn("Event " + e.name + " was rejected because guard evaluates to false ")
			}
		}
	}
	
	def private candidateStateApproved(ExecutionState state, Event e) {
		states.add(state)
		last = state
		updateInfo("Successful transition for event " + e?.name + " - entering new exec-state for " + state.activeState.name)
	}
	
	// for testing
	def Binding getLastBinding(){
		last.binding
	}
	
	// for testing
	def List<ExecutionState> getStates(){
		states
	}
	
	
	def getLast(){
		last
	}
	
	
	static interface ITraceListener {
		def void info(String s)
		def void warn(String s)
		def void error(String s)
	}
	
}
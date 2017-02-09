package ssma.sminvcb.execution

import org.eclipse.emf.ecore.resource.Resource
import ssma.sminvcb.sminvcbDsl.SminvcbModel
import com.google.inject.Inject
import ssma.sminvcb.printing.SminvcbDslPrinter
import ssma.sminv.simulation.domain.Trace
import ssma.sminvcb.adapter.IAppAdapter
import ssma.sminvcb.adapter.ISmAdapter
import java.util.Map
import ssma.sminv.sminvDsl.Event
import java.util.HashMap
import ssma.sminv.sminvDsl.State

import static extension ssma.sminv.eval.TermEvalProvider.*
import static extension ssma.sminv.util.SminvDslUtil_Static.*
import ssma.fml.fmlDsl.Term

class SminvcbDslExecutor implements Trace.ITraceListener, ISmAdapter{
	 
	@Inject
	var SminvcbDslPrinter  printer	
	
	var Trace trace
	var IAppAdapter appAdapter
	
	var Map<String, Event> eventForName = new HashMap<String, Event>()
	
	var SminvcbModel model
	
	//TODO: try to understand why only one resource (sminvcb) is sufficient here
	//     (and I can navigate even to the referred sminv-model)
	def process(Resource resource){
		val aModel = resource.allContents
				.filter(typeof(SminvcbModel)).head
				
				
		println("MYLOG : in executor.process()")		
				
		println("MYLOG cb-model is : " + printer.stringRepr(aModel))

		processModel(aModel)
		
		println("MYLOG :executor.process() finished")		
	}
	
	// the argument is for testing purpose
	def processModel(SminvcbModel aModel){
		model = aModel
		//fill event map
		model.sminvModel.ed.events.forEach[ev| eventForName.put(ev.name, ev)]
		
		// creates Traces
		trace = new Trace(model.sminvModel, this)
		
		
		appAdapter =  createAppAdapter(model)
		appAdapter.init(this)
		  
		// if specified, we override the event list for the simulation
		if (model.evt != null && !model.evt.l.empty){
			appAdapter.eventList = model.evt.l.map[name]
		}
		
		appAdapter.start()
		
	}


	
	def IAppAdapter createAppAdapter(SminvcbModel model) {
		var IAppAdapter result;
		
		if (model.facn == null || model.facn.empty){
			error("Adapter class not set in model")
		}
			try{
				 val c = Class.forName(model.facn)
 		    	result = c.newInstance() as IAppAdapter
 		    	if (result == null)
 		    		throw new IllegalStateException("Could not create IAppAdapter")
			}catch(Exception e){
				error("Cannot created instance of adapter class " + e.message)
			}
		result
	}
	
	override info(String s) {
		println("Executor INFO: " + s)
	}
	
	override warn(String s) {
		println("Executor WARN: " + s)
	}
	
	// might also invoked from this class
	override error(String s) {
		println("Executor ERROR: " + s)
	}
	
	override evOccurred_pre(String evName) {
		
		checkCodeBridgePredicates();
		
		trace.occurred(eventForName.get(evName))
	}
	
	
	/**
	 * We check whether state-machine and implementation are still in sync 
	 * according to the bridge.
	 */
	def private checkCodeBridgePredicates() {
		val State currentState=trace.last.activeState
		
		val predsForCurrentState = model.spd.spreds.filter(sp|sp.state==currentState)

		val binding = new CodeVarBinding(appAdapter, trace.last.binding)
		
		// checking the state-preds
		for(p:predsForCurrentState){
			checkPredTerm(p.state.name, p.pred, binding, currentState)
		}
		
		// checking the global_preds
		val globalPreds = model.gpd.gpreds
		for(p:globalPreds){
			checkPredTerm(p.name, p.pred, binding, currentState)
		}

	}
	
	
	def private checkPredTerm(String name, Term t, CodeVarBinding b, State currentState){
			if (!evalBool(t,b)){
				// the last step was wrong
				error("Expected to be in state " + currentState.name 
				      + " but predicate " + name + "in codebridge failed"  
				    )
				throw new CodeBridgeExecutionException("App behaves differently than statemachine")
			}
		
	}
	
	
	
}
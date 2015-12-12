package ssma.sminv.util

import com.google.inject.Inject
import java.util.ArrayList
import ssma.fml.util.FmlDslUtil
import ssma.sminv.printing.SminvDslPrinter
import ssma.sminv.sminvDsl.Inv
import ssma.sminv.sminvDsl.SminvModel
import ssma.sminv.sminvDsl.State
import ssma.sminv.sminvDsl.StateDecl
import ssma.sminv.sminvDsl.Transition
import ssma.sminv.typing.TermTypeProviderWithVar

import static extension org.eclipse.xtext.EcoreUtil2.*

class SminvDslUtil extends FmlDslUtil{
	
	@Inject extension TermTypeProviderWithVar
	@Inject extension SminvDslPrinter
	
	
	
	protected override checkSubterm(ssma.fml.fmlDsl.Term t) {
		if (! t.typeFor.isBoolean)
			throw new IllegalArgumentException("")
		if (t.eContainer != null)
			throw new IllegalArgumentException("")
	}
	

	//
	// navigation shortcuts
	//
	
	def getInvariants(SminvModel model) {
		// id is the only feature of SminvModel that can be null
		if (model.id == null)
			new ArrayList<Inv>()
		else {
			model.id.invs
		}
	}

	def getTransitions(SminvModel model) {
		model.td.trans
	}

	def getStates(SminvModel model) {
		model.sd.states
	}

	def Iterable<Inv> getInvariants(State s) {
		s.root.invariants.filter[state == s]
	}

	def getRoot(State s) {
		s.getContainerOfType(typeof(SminvModel))
	}

	//
	// derived attributes
	//
	def boolean isStartState(State s) {
		(s.eContainer as StateDecl).states.head == s
	}
	
	def String getPrintName(Transition t){
		'''«t.pre.name» => «t.post.name» ''' +
		'''«IF t.ev != null»«t.ev.name» «ENDIF»''' +
		'''«IF t.g != null»[«t.g.stringRepr»]«ENDIF»''' +
		'''«IF t.act.size != 0» / «FOR up : t.act»«up.variable.name» «up.op» «up.value.stringRepr» «ENDFOR»«ENDIF»'''
	}

	def getIncomingTransitions(State s) {
		s.root.transitions.filter[post==s]
	}

	def getOutgoingTransitions(State s) {
		s.root.transitions.filter[pre==s]
	}
}
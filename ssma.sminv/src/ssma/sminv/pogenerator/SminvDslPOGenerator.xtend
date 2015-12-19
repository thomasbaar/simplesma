package ssma.sminv.pogenerator

import com.google.inject.Inject
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import ssma.fml.fmlDsl.FmlDslFactory
import ssma.fml.fmlDsl.Term
import ssma.sminv.sminvDsl.Inv
import ssma.sminv.sminvDsl.SminvDslFactory
import ssma.sminv.sminvDsl.State
import ssma.sminv.sminvDsl.Transition
import ssma.sminv.sminvDsl.Update
import ssma.sminv.sminvDsl.VarRef
import ssma.sminv.util.SminvDslUtil

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*
import static extension org.eclipse.xtext.EcoreUtil2.*

class SminvDslPOGenerator {
	@Inject extension SminvDslUtil

	/*
	 * Generates the PO generation for preserving invariants
	 * 
	 * Note that this algorithm is (probably) only correct if
	 * invariants and guards to not contain quantified formulas
	 * (this should be always be the case, since the user can enter
	 * only non-quantified formulas)
	 * We assume that all occurring variables have a unique name 
	 * (this is also validated for the input)
	 */
	def getPO_InvPreservation(Transition t) {
		t.pre.invariantsCopyConjunction.and(t.guardCopy).implies(
			t.post.invariantsCopyConjunction.substituteWith(t.updateCopyAsList)
		)
	}

	def getPO_InvPreservation_ForPostInvariant(Transition t, Inv postInv) {
		t.pre.invariantsCopyConjunction.and(t.guardCopy).implies(postInv.inv.copy.substituteWith(t.updateCopyAsList))
	}

	/**
	 * @param t1, t2: assumed that both transitions are potentially in conflict,
	 * i.e. they have the same pre-state and the same event (or no event)
	 */
	def getPO_NonDeterminism(Transition t1, Transition t2) {
		if (t1==null) throw new IllegalArgumentException("null argument")
		if (t2==null) throw new IllegalArgumentException("null argument")
		if(!t1.hasSamePrestate(t2)) throw new IllegalArgumentException("expected same pre-state")
		if(!t1.hasSameEvent(t2)) throw new IllegalArgumentException("expected same event")
		t1.pre.invariantsCopyConjunction.implies(neg(t1.guardCopy.and(t2.guardCopy)))
	}

	private def hasSamePrestate(Transition t1, Transition t2) {
		t1.pre == t2.pre
	}

	/**
	 * Returns true if both transitions have no annotated event or the same event annotated.
	 */
	private def hasSameEvent(Transition t1, Transition t2) {
		if(t1.ev == null && t2.ev == null) return true
		if(t1?.ev == t2?.ev) return true else false
	}

	/** writes += and -= in update definition by simple =-update
	 *  
	 * argument u should be copied before
	 */
	private def normalize(Update u) {
		if (!u.op.equals('=')) {
			val origOp = u.op
			u => [
				op = '='
				value = FmlDslFactory::eINSTANCE.createPlusMinus => [
					if(origOp.equals('+=')) op = '+' else op = '-'
					left = SminvDslFactory::eINSTANCE.createVarRef => [
						v = u.variable
					]
					right = u.value
				]
			]
		} else {
			u
		}
	}

	/*
	 * Substitutes all the VarRefs within t with the corresponding
	 * definition from ul.
	 */
	private def Term substituteWith(Term t, List<Update> ul) {
		val normalizedUpdateList = ul.map[normalize]
		val mapVarTerm = new HashMap<String, Term>(); // we assume unique names of variables
		normalizedUpdateList.forEach[u|mapVarTerm.put(u.variable.name, u.value.asCompound)] // we need compound-Term, since VarRef is an Atomic and might also be substituted by Atomic as well
		val occurringVarRefsInT = t.getAllContentsOfType(typeof(VarRef))

		for (VarRef vr : occurringVarRefsInT) {
			if (mapVarTerm.keySet.contains(vr.v.name)) {
				vr.replace(mapVarTerm.get(vr.v.name).copy) // copy is important if the same variables occurs more than once
			}
		}
		t
	}

	/**
	 * returns '(' t ')'
	 */
	private def asCompound(Term t) {
		SminvDslFactory::eINSTANCE.createCompound => [
			it.t = t
		]
	}

	/*
	 * returns a copy of t's guard ('true' if absent)
	 */
	private def getGuardCopy(Transition t) {
		if(t.g != null) t.g.copy else FmlDslFactory::eINSTANCE.createBoolConstant => [value = 'true']
	}

	/*
	 * returns a copy of t's guard ('true' if absent)
	 */
	private def List<Update> getUpdateCopyAsList(Transition t) {
		val result = new ArrayList<Update>()
		if (t.act != null) {
			for (Update u : t.act) {
				result.add(u.copy)
			}
		}
		result
	}

	/**
	 * returns the conjunction of all copies of invariants
	 */
	private def Term getInvariantsCopyConjunction(State s) {
		val invs = s.invariants
		if (invs.empty)
			FmlDslFactory::eINSTANCE.createBoolConstant => [value = 'true']
		else
			invs.map(i|i.inv.copy).reduce[l, r|l.and(r)]
	}

}
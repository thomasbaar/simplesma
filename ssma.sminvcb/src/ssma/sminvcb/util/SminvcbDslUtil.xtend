package ssma.sminvcb.util

import ssma.sminv.sminvDsl.Var
import ssma.sminvcb.sminvcbDsl.CodeVarDecl

import static extension org.eclipse.xtext.EcoreUtil2.*
import com.google.common.collect.Iterables

class SminvcbDslUtil {


	def static boolean isCodeVar(Var v) {
		! Iterables.filter(v.allContainers,CodeVarDecl).isEmpty
	}


}
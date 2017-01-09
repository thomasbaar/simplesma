package ssma.sminv.eval

import java.util.HashMap
import ssma.sminv.sminvDsl.Var
import ssma.sminv.sminvDsl.SminvModel

/**
 * The bindings of all Var-objects to int-values 
 */

class Binding {
	
	var vv = new HashMap<Var,Integer>()// varvalue
	
	// to be invoked only to compute the binding for the start state
	def init(SminvModel model){
		for(v:model.vd.vars){
			vv.put(v,0)  //initialization is always with 0
		}
	}
	
	def int getVal(Var v){
		if (!vv.keySet.contains(v)){
			throw new IllegalArgumentException("unknows var " + v.name)
		}
		vv.get(v)
	}
	
	def setVal(Var v, int value){
		vv.put(v,value)
	}
	
	/**
	 * returns a new Bindung with the var-value entries in vv as
	 * in this
	 */
	def Binding getCopy(){
		var c = new Binding()
		// next line somehow is syntactically wrong
 		//c.vv = (HashMap<Var,Integer> this.vv.clone)  
 		// so we do the cloning by our own
 		for(v:this.vv.keySet){
 			c.vv.put(v,getVal(v))
 		}
 		c  //  return value
	}
	
}
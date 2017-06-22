package exa.stack.app;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;


public class Stack1 {

//	private Collection<Item> items = new ArrayList<Item>();
	private List<Item> items = new ArrayList<Item>();
	
	public void push(Item i){
		items.add(i);
	}
	
	public Item pop(){
		if (items.isEmpty())
			return null;
		int lastIndex = items.size()-1;
		
//		items.remove(lastIndex);
//		return null;
		return items.remove(lastIndex);
	}
	
	// allow the adapter to get necessary information
	public int getLength(){
		return items.size();
	}
}
	
//	private int cnt = 0;
//	
//	public void push(Item i){
//		cnt=cnt+1;
//	}
//	
//	public void pop(){
//		cnt=cnt-1;
//	}
//
//	public int getLength(){
//		return cnt;
//	}
//}

package exa.stack.app;

import java.util.ArrayList;
import java.util.List;


public class Stack1 {

	private List<Item> items = new ArrayList<Item>();
	
	public void push(Item i){
		items.add(i);
	}
	
	public Item pop(){
		if (items.isEmpty())
			return null;
		int lastIndex = items.size()-1;
		
		return items.remove(lastIndex);
	}
	
	// allow the adapter to get necessary information
	public int getLength(){
		return items.size();
	}

}

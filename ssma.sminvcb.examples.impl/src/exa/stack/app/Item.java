package exa.stack.app;

public class Item {
	
	private String name = "";
	
	public Item(String aName){
		if (aName!=null)
			this.name=aName;
	}
	

	public String getName() {
		return name;
	}

}

package word;


public class WordCarrier {
	
	public String value = null ;
	public int count = 1 ;
	public int filter = 0 ;
	public int dbCount = 0 ;
	public double frequency = 0 ;
	
	
	public WordCarrier (String value) {
		this.value = value ;
	}
	
	public void plus () {
		this.count += 1 ;
	}
	
	public void minus () {
		this.count -= 1 ; 
	}
	
	public void resetCount () {
		this.count = 0 ;
	}
	
}



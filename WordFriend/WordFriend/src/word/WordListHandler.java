package word;

import java.util.ArrayList;
import word.WordCarrier;
import java.util.Iterator;

public class WordListHandler {
	
	public static ArrayList<WordCarrier> sort (ArrayList<WordCarrier> list) {
		
		if (list.size() >= 2) {
			
			for (int i = 0 ; i < list.size()-1 ; i++ ) {
				int minwordindex = i ;
				for (int j = i + 1 ; j < list.size() ; j++ ) {
					if (list.get(minwordindex).count
							- list.get(j).count
							< 0  ) {
						minwordindex = j ; 
					}
				}
				WordCarrier tmpwc = list.get(minwordindex) ;
				list.set(minwordindex , list.get(i)) ;
				list.set(i , tmpwc) ; 
			}
			
		}
		
		return list ;
	}
	
	public static boolean contains (ArrayList<WordCarrier> list , String text) {
		
		if (list.isEmpty() == false) {
			
			boolean flag = false ;
			
			Iterator<WordCarrier> listtraveler = list.iterator() ;
			
			while(listtraveler.hasNext()) {
				String liststring = listtraveler.next().value ;
				if (liststring.equals(text)) {
					flag = true ;
					break ;
				}
			}
			
			return flag ;
			
		} else {
			return false ;
		}
		
	}
	
	public static int indexOf (ArrayList<WordCarrier> list , String text) {
		
		if (list.isEmpty() == false) {
			
			int flag = -1 ;
			
			Iterator<WordCarrier> listtraveler = list.iterator() ;
			
			while(listtraveler.hasNext()) {
				WordCarrier wordc = listtraveler.next() ;
				String liststring = wordc.value ;
				if (liststring.equals(text)) {
					flag = list.indexOf( wordc ) ;
					break ;
				}
			}
			
			return flag ;
			
		} else {
			return -1 ;
		}
		
	}
	
	public static WordCarrier get (ArrayList<WordCarrier> list , String text) {
		
		if (list.isEmpty() == false) {
			
			WordCarrier flag = null ;
			
			Iterator<WordCarrier> listtraveler = list.iterator() ;
			
			while(listtraveler.hasNext()) {
				WordCarrier wordc = listtraveler.next() ;
				String liststring = wordc.value ;
				if (liststring.equals(text)) {
					flag = wordc ;
					break ;
				}
			}
			
			return flag ;
			
		} else {
			return null ;
		}
		
	}
	
}

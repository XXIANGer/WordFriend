package xss;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class XSS {
	
	public static String htmlspecialchar (String plainTextForXss) {
		
		String ampPattern="&" ;
		Pattern ampR = Pattern.compile(ampPattern);
		Matcher ampM = ampR.matcher(plainTextForXss);
		plainTextForXss = ampM.replaceAll("&amp;") ;

		String ltPattern="<" ;
		Pattern ltR = Pattern.compile(ltPattern);
		Matcher ltM = ltR.matcher(plainTextForXss);
		plainTextForXss = ltM.replaceAll("&lt;") ;

		String gtPattern=">" ;
		Pattern gtR = Pattern.compile(gtPattern);
		Matcher gtM = gtR.matcher(plainTextForXss);
		plainTextForXss = gtM.replaceAll("&gt;") ;

		String quotPattern="\"" ;
		Pattern quotR = Pattern.compile(quotPattern);
		Matcher quotM = quotR.matcher(plainTextForXss);
		plainTextForXss = quotM.replaceAll("&quot;") ;

		String h39Pattern="'" ;
		Pattern h39R = Pattern.compile(h39Pattern);
		Matcher h39M = h39R.matcher(plainTextForXss);
		plainTextForXss = h39M.replaceAll("&#39;") ;
		
		return plainTextForXss ;
		
	}
	
}
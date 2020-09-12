package sql; 

import java.util.ArrayList ;
import java.util.Iterator ;
import java.util.Collections ;
import java.util.regex.Matcher ;
import java.util.regex.Pattern ;
import word.* ;
import xss.* ;
import databaseinfo.* ;
import java.sql.* ;


public class SQL {
	
	public void loadDriver () throws SQLException {
		
		Connection conn = null; 
		Statement stmt = null; 
		ResultSet rset = null; 
		
		String dbPath = DB.dbpath ;
		
		try {
			Class.forName( "org.sqlite.JDBC" ) ;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			System.out.println("flag0") ;
			conn = DriverManager.getConnection(dbPath);
			System.out.println("flag1") ;
			stmt = conn.createStatement();
			
			
			
				
			rset = stmt.executeQuery (	"select *,filter from word " ) ;
			rset.next() ;
			String word = rset.getString(2) ;
			System.out.println(word) ;
				
			

		} catch (SQLException e) { 
			System.out.println("SQLException") ;
		} finally {
			if (rset!= null) rset.close(); 
			if (stmt!= null) stmt.close();
			if (conn!= null) conn.close();
		}
	}
	
}




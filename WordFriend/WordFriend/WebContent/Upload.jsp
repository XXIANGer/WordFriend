<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="word.*"%>
<%@page import="xss.*"%>
<%@page import="databaseinfo.*"%>
<%@page import="java.sql.*"%>
<%@page import="regex.*"%>



<!--  pageEncoding : jsp 本身 编码 -->
<!--  charset      : 提示客户端浏览器 , 数据包的编码方式 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<!--  下面两行 , 控制数据包编码方式 -->
<% response.setCharacterEncoding("utf-8") ;%>
<% request.setCharacterEncoding("utf-8"); %>


<!-- 加载驱动 -->
<%  %>
<%	try {
	Class.forName( "org.sqlite.JDBC" ) ;
} catch (ClassNotFoundException e) {
	System.out.println("ClassNotFoundException") ;
}
%>





<%

	if ( request.getParameter("text") != null ) {
		
		// 用户输入字符串 取得 
		String plainText = request.getParameter("text") ;
		
		
		// 正则匹配
		String regex = REGEX.regex ;
		// String regex = "[a-zA-Z]{1,}" ;
				//第二种正则表达 
				//String pattern = "((?i)[a-z]+d)" ;
			
		Pattern p = Pattern.compile(regex);
		Matcher m = p.matcher(plainText);
		// 正则匹配	完成
		
		
		// List 创建 , 单词 | 次数 , 的存储 .
		ArrayList<WordCarrier> list = new ArrayList<WordCarrier>() ;
		
		
		// 单词 , 次数  添加到  list 
		while (m.find( )) {
			
			String word = m.group(0).toLowerCase() ;
			
			// Special value : 
			// it's have was is am were
			if ( word.equals("ve")  ) { continue ; }
			if ( word.equals("s")  ) { continue ; }
			if ( word.equals("m")  ) { continue ; }
			if ( word.equals("re")  ) { continue ; }
			
			if ( WordListHandler.contains(list , word) == true ) {
				WordListHandler.get(list , word).count += 1 ;
			} else {
				list.add( new WordCarrier(word) ) ;
			}
			
		}
		
		
		// 遍历  list  次数   加入数据库 
		int prevCount = -1 ;
		int lastCount = -1 ;
		int newCount  = -1 ;
		
		Connection conn = null; 
	    Statement stmt = null; 
	    ResultSet rset = null; 
	    int countCond = -1 ;
	    
	    String dbPath = DB.dbpath ;
	    
	    try {
	    	conn = DriverManager.getConnection(dbPath);
	    	stmt = conn.createStatement();
	    	
			Iterator<WordCarrier> listTraveler = list.iterator() ;
			
			while ( listTraveler.hasNext() ) {
			
				WordCarrier wordc = listTraveler.next() ;
				String word = wordc.value ;
				lastCount = wordc.count ;
			
				if ( exists( wordc.value ) ) {
					rset = stmt.executeQuery (  String.format("select count from word where name='%s'" , word)  );
					rset.next() ;
					prevCount = rset.getInt(1) ;
					newCount = prevCount + lastCount ;
					stmt.executeUpdate( String.format("update word set count=%d where name='%s'" , newCount , word ) ) ;
				} else {
					prevCount = 0 ;
					newCount = prevCount + lastCount ;
					stmt.executeUpdate( String.format("insert into word (name , count , filter ) values('%s' , %d , 0)" , word , newCount ) ) ;
				}
				// rset = stmt.executeQuery (  "select sumCount from overview where id=1"  );
				// rset.next() ;
				// int prevCountForSum = rset.getInt(1) ;
				// int lastCountForSum = lastCount ;
				// int newCountForSum = prevCountForSum + lastCountForSum ;
				// stmt.executeUpdate( String.format("update overview set sumCount=%d where id=1" , newCountForSum ) ) ;
				
			}
			
	    } catch (SQLException e) { 
	        
	    } finally {
	    	if (rset!= null) rset.close(); 
			if (stmt!= null) stmt.close();
	    	if (conn!= null) conn.close();
	    }
		
		
		
	
	}
			
		
	// out.print(  sqlObj.exists( "apple" ) ) ;
	

		// 链接数据库 

		// 建立  list 

		// 遍历  list 

		// 每一个 wordc		若已经存在于数据库 ,   取得数据库中的次数 增加该文章中次数  

		// 每一个 wordc		若不存在于数据库 , 新建 , 写入次数
%>

<% out.print("<b>上传成功 !</b>"); %>
<a href="WordFriend.jsp">点击这里返回</a>



























<!-- 函数定义 -->


<!-- 返回 某个单词是否已经存在 -->
<%! private boolean exists(String cond) throws SQLException {
	
    Connection conn = null; 
    Statement stmt = null; 
    ResultSet rset = null; 
    int countCond = -1 ;
    
    String dbPath = DB.dbpath ;
    
    try {
    	conn = DriverManager.getConnection(dbPath);
    	stmt = conn.createStatement();
    	rset = stmt.executeQuery (  String.format("select count(*) from (select name from Word where name='%s')" , cond)  );
       
    	rset.next() ;
    	countCond = rset.getInt(1) ;
    	
    } catch (SQLException e) { 
        
    } finally {
    	if (rset!= null) rset.close(); 
		if (stmt!= null) stmt.close();
    	if (conn!= null) conn.close();
    }
    
    if ( countCond == 0 ) {
    	return false ;
    } else if (countCond == 1 ) {
    	return true ; 
    } else {
    	System.out.println("Error: countCond == -1 or >= 2") ;
    	return true ;
    }

}

%>

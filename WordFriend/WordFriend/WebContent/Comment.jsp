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
<% 	try {
	Class.forName( "org.sqlite.JDBC" ) ;
} catch (ClassNotFoundException e) {
	System.out.println("ClassNotFoundException") ;
}
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>评价</title>
	<!-- CSS 设置 -->
		<!-- .class #id label label -->
	<style>
		
	</style>
</head>
<body>

</body>
</html>


<% 
	// 单词 , 生疏度  , 接收参数 
	String word = request.getParameter( "wordComment" ).trim().toLowerCase() ;
	String fi = request.getParameter( "filterComment" ).trim() ;

	if ( !(	"0".equals(fi) ||
			"1".equals(fi) ||
			"2".equals(fi) ||
			"3".equals(fi)  )  ) {
		fi="0" ;
	}
	int filter = Integer.valueOf( fi ) ;

	
	
	// 处理单词  , 防止意外字符(sql注入等) , 空传参   的同时处理 
	boolean isWordNull = false ;
	// 正则匹配
	String regex = REGEX.regex ;
	// String regex = "[a-zA-Z]{1,}" ;
				
	Pattern p = Pattern.compile(regex);
	Matcher m = p.matcher(word);
	if ( m.find() ) {
		word = m.group(0).toLowerCase() ;
	} else {
		isWordNull = true ;
		out.print("<b>输入的单词不存在于数据库中 !</b>") ;
	}
	
	
	
	
	// 生疏度	更新数据库 
	if ( isWordNull == false ){
		Connection conn = null; 
		Statement stmt = null; 
		ResultSet rset = null; 
		String sql = "update word set filter=" + filter + " where name='" + word + "' " ;
		
		String dbPath = DB.dbpath ;
		
		try {
			conn = DriverManager.getConnection(dbPath);
			stmt = conn.createStatement();
			stmt.executeUpdate (  sql  );
			
		} catch (SQLException e) { 
			System.out.println("SQLException") ;
		} finally {
			if (rset!= null) rset.close(); 
			if (stmt!= null) stmt.close();
			if (conn!= null) conn.close();
		}
	}

%>




<!-- 
	<a href="WordFriend.jsp">点击这里返回</a>
 -->
<a href="Filter.jsp">点击这里返回</a>


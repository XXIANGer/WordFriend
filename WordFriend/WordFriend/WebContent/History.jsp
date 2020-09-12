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
<title>筛选器</title>
	<!-- CSS 设置 -->
		<!-- .class #id label label -->
	<style>
		
	</style>
</head>
<body>

	<!-- 菜单 -->
	<div class="menu">
		<form action="" method="post">
			<button type="submit" formaction="WordFriend.jsp">输入文章</button>
			<button type="submit" formaction="Filter.jsp">生疏度筛选</button>
			<button type="submit" formaction="History.jsp">历史次数统计</button>
		</form>
	</div>

<br/>


	<!-- 历史次数统计 -->
		<table border="1">
		<tr>
			<th>单词</th>
			<th>次数(历史)</th>
			<th>生疏度</th>
		</tr>
	<%
	try {
		Class.forName( "org.sqlite.JDBC" );
	} catch ( ClassNotFoundException e) {
		System.out.println("ClassNotFoundException") ;
	}
	Connection conn = null; 
	Statement stmt = null; 
	ResultSet rset = null; 
	String sql = "select name,count,filter from word order by count desc ,name " ;
	
	String dbPath = DB.dbpath ;
	
	try {
		conn = DriverManager.getConnection(dbPath);
		stmt = conn.createStatement();
		rset = stmt.executeQuery (  sql  );
		
		
	   // 这里加遍历代码
		while (rset.next()) {
			
			WordCarrier wordc = new WordCarrier(rset.getString(1)) ;
			String word = rset.getString(1) ;
			int dbCount = rset.getInt(2) ;
			int filter = rset.getInt(3) ;
			wordc.dbCount=dbCount ;
			wordc.filter=filter ;
			out.println("<tr>");
			out.println("<td>" + wordc.value + "</td>");
			out.println("<td>" + wordc.dbCount + "</td>");
			out.println("<td>" + wordc.filter + "</td>");
			out.println("</tr>");
			
			
		}
		
	} catch (SQLException e) { 
		System.out.println("SQLException") ;
	} finally {
		if (rset!= null) rset.close(); 
		if (stmt!= null) stmt.close();
		if (conn!= null) conn.close();
	}
	%>
	</table>
<br/>

	
</body>
</html>



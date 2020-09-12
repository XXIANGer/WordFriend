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


	<!-- 生疏度更新 -->
	<form action="Comment.jsp" method="get">
		<input type="text" name="wordComment" placeholder="在这里输入单词" />
		<input type="text" name="filterComment" placeholder="在这里输入生疏度" />
		<input type="submit" value="评价生疏度"/>
	</form>

<br/>


	<!-- 输入 -->
	<div class="userinput">
		<form>
			<input type="text" name="filter" placeholder="在这里输入生疏度 (0-3)" />
			<input type="submit"  value="筛选" />
		</form>
	</div>

<br/>


	<!-- 输出 - 标签 -->
	<div class="outputText">
		<table border="1">
			<tr>
				<th>单词</th>
				<th>次数(历史)</th>
				<th>生疏度</th>
			</tr>
	

	<!-- 输出 - 内容 -->
	<%
	if ( request.getParameter("filter")==null ) {
	} else {
		// filter init to 0,1,2,3
		
		String filter=request.getParameter("filter").trim() ;
		if ( !(	"0".equals(filter) ||
				"1".equals(filter) ||
				"2".equals(filter) ||
				"3".equals(filter)  )  ) {
			filter="-1" ;
		}
		
		// sql exp init
		String sql = null ;
		if			(  "-1".equals(filter)  ) {
			sql =	"select name,count,filter from word where filter=0 " + 
					" union all " +
					"select name,count,filter from word where filter=1 " + 
					" union all " +
					"select name,count,filter from word where filter=2 " + 
					" union all " +
					"select name,count,filter from word where filter=3 order by filter , name " ;
		} else if	(  "0".equals(filter)  ) {
			sql = "select name,count,filter from word where filter=0 order by name" ;
		} else if	(  "1".equals(filter)  ) {
			sql = "select name,count,filter from word where filter=1 order by name" ;
		} else if	(  "2".equals(filter)  ) {
			sql = "select name,count,filter from word where filter=2 order by name" ;
		} else if	(  "3".equals(filter)  ) {
			sql = "select name,count,filter from word where filter=3 order by name" ;
		}
		
		
		// database exec
		Connection conn = null; 
	    Statement stmt = null; 
	    ResultSet rset = null; 
	    
	    String dbPath = DB.dbpath ;
	    
	    try {
	    	conn = DriverManager.getConnection(dbPath);
	    	stmt = conn.createStatement();
	    	
	    	rset = stmt.executeQuery (  sql  );
	    	
	    	while( rset.next() ) {
	    		out.println("<tr>");
				out.println("<td>" + rset.getString(1) + "</td>");
				out.println("<td>" + rset.getInt(2) + "</td>");
				out.println("<td>" + rset.getInt(3) + "</td>");
				out.println("</tr>");
	    	}
	    	
	    } catch (SQLException e) { 
	        
	    } finally {
	    	if (rset!= null) rset.close(); 
			if (stmt!= null) stmt.close();
	    	if (conn!= null) conn.close();
	    }
	}
	%>
	
		</table>
	</div>
	
<br/>




</body>
</html>


















<!-- 返回 某个单词是否已经存在 -->
<%! private boolean exists(String cond) throws SQLException {
	 String dbPath = DB.dbpath ;
     Connection conn = null; 
     Statement stmt = null; 
     ResultSet rset = null; 
     int countCond = -1 ;
     try {
        conn = DriverManager.getConnection(dbPath);
        stmt = conn.createStatement();
        // dynamic query
        rset = stmt.executeQuery (  String.format("select count(*) from (select %s from Word )" , cond)  );
        
        while (rset.next()) {
        	countCond = rset.getInt(1) ;
        }
        
        
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





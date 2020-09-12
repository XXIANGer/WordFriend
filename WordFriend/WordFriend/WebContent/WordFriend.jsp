<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="word.*"%>
<%@page import="xss.*"%>
<%@page import="databaseinfo.*"%>
<%@page import="java.sql.*"%>
<%@page import="sql.*"%>
<%@page import="regex.*"%>



<!--  pageEncoding : jsp 本身 编码 -->
<!--  charset      : 提示客户端浏览器 , 数据包的编码方式 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!--  下面两行 , 控制数据包编码方式 -->
<% response.setCharacterEncoding("utf-8") ; %>
<% request.setCharacterEncoding("utf-8"); %>


<!-- 加载驱动 -->
<% 
	try {
		Class.forName( "org.sqlite.JDBC" ) ;
	} catch (ClassNotFoundException e) {
		System.out.println("ClassNotFoundException") ;
	}
%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>欢迎来到单词之友!</title>
	<!-- CSS 设置 -->
		<!-- .class #id label label -->
	<style>
		.outputText {
			position: absolute;
			left: 500px;
			top: 50px;
		}
		.inputText textarea {
			width: 440px ;
			height: 210px ;
		}
		#textcalc {
			position: relative;
			left: 0px;
			top: 2px;
		}
		#textupload {
			position: relative;
			left: 260px;
			top: 2px;
		}
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

	<!-- 用户输入区 -->
	<div class="inputText">
		<form action="WordFriend.jsp?isInput=true" method="post">
			<textarea rows='10' cols='50' name='text' placeholder='在这里粘贴文章' autofocus ><%
				String isInput=request.getParameter("isInput") ;
					
					if ( "true".equals(isInput) && request.getParameter("text") != null ) {
						
						String tab="&nbsp&nbsp&nbsp&nbsp";
						
						// 用户输入字符串 取得  
						String plainText = request.getParameter("text") ;
				
						//过滤 XSS 然后 输出  , 调用的是编写的 xss.XSS.java
						plainText=XSS.htmlspecialchar(plainText) ;
						out.print(plainText) ;
						//完成 过滤 XSS
						
						// 修改接收到的 文章 的编码的方式
						// String utf8plainText = new String(plainTextForXss.getBytes("iso-8859-1"), "utf-8") ;
						
					}
			%></textarea>
			<br />
			<input type="submit" value="统计" id="textcalc" />
			<input type="submit" value="写入词频到数据库" id="textupload" formaction="Upload.jsp"  />
		
		</form>
	</div>

<br/>

	<!-- 结果输出区 - 标签部分 -->
	<div class="outputText">
		<table border="1">
			<tr>
				<th>单词</th>
				<th>次数(当前)</th>
				<th>次数(历史)</th>
				<th>生疏度</th>
			</tr>
	
	
	<!-- 结果输出区 - 内容部分 -->
	<%
		// 处理 用户输入 得到 输出
			// String isInput=request.getParameter("isInput") ;
	if ( "true".equals(isInput) && request.getParameter("text") != null ) {
		
		
		// 用户输入字符串 取得 
		String plainText = request.getParameter("text") ;
		
		
		// 正则匹配
		String regex = REGEX.regex ;
		//String regex = "[a-zA-Z]+" ;
		//String regex = "[a-zA-Z]+[']{0,1}[a-zA-Z]+" ;
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
		
		
		// 历史 , 生疏度 添加到  list
		Connection conn = null; 
		Statement stmt = null; 
		ResultSet rset = null; 
		
		String dbPath = DB.dbpath ;

		try {
			conn = DriverManager.getConnection(dbPath);
			stmt = conn.createStatement();
			
			Iterator<WordCarrier> listTraveler = list.iterator() ;
			while (listTraveler.hasNext()) {
				WordCarrier wordc = listTraveler.next() ;
				String word = wordc.value ;
				
				
				rset = stmt.executeQuery (	"select count,filter from word where name='" +
											word + "'" );
				
				
				if (rset.next() ) {

					wordc.dbCount = rset.getInt(1) ;
					wordc.filter = rset.getInt(2);
				
				} else {
					wordc.dbCount = 0 ;
					wordc.filter = 0 ;
				}
				
			}

		} catch (SQLException e) { 
			System.out.println("SQLException") ;
		} finally {
			if (rset!= null) rset.close(); 
			if (stmt!= null) stmt.close();
			if (conn!= null) conn.close();
		}
		
		
		// 按字母升序排列  list 
		WordListHandler.sort(list) ;
		
		
		// 遍历  list  以   输出 
		Iterator<WordCarrier> listTraveler = list.iterator() ;
		
		while ( listTraveler.hasNext() ) {
			
			WordCarrier wordc = listTraveler.next() ;
			out.println("<tr>");
			if (wordc.filter == 0) {
				out.println("<td><font color='black'>" + wordc.value + "</	font></td>");
			} else if (wordc.filter == 1) {
				out.println("<td><font color='green'>" + wordc.value + "</	font></td>");
			} else if (wordc.filter == 2) {
				out.println("<td><font color='blue'>" + wordc.value + "</	font></td>");
			} else if (wordc.filter == 3) {
				out.println("<td><font color='red'>" + wordc.value + "</	font></td>");
			}
			
			out.println("<td>" + wordc.count + "</td>");
			out.println("<td>" + wordc.dbCount + "</td>");
			out.println("<td>" + wordc.filter + "</td>");
			out.println("</tr>");
			
			
			
		}
		
	}
	%>
	
		</table>
	</div>
	
<br/>


</body>
</html>


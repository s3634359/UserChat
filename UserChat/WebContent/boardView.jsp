<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.BoardDTO"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) {
		session.setAttribute("messageType", "Error Message");
		session.setAttribute("messageContent", "You need to log in first.");
		response.sendRedirect("index.jsp");
		return;
	}
	String pageNumber = "1";
	if (request.getParameter("pageNumber") != null) {
		pageNumber = request.getParameter("pageNumber");
	}
	try {
		Integer.parseInt(pageNumber);
	} catch (Exception e) {
		session.setAttribute("messageType", "Error Message");
		session.setAttribute("messageContent", "Invalid Page Number");
		response.sendRedirect("boardView.jsp");
		return;
	}
	ArrayList<BoardDTO> boardList = new BoardDAO().getList(pageNumber);
%>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP Ajax Chat Service</title>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<script type="text/javascript">
	function getUnread(){
		$.ajax({
			type: "POST",
			url: "./chatUnread",
			data: {
				userID: encodeURIComponent('<%=userID%>'),
			},
			success : function(result) {
				if (result >= 1) {
					showUnread(result);
				} else {
					showUnread('');
				}
			}
		});
	}
	function getInfiniteUnread() {
		setInterval(function() {
			getUnread();
		}, 2000);
	}
	function showUnread(result) {
		$('#unread').html(result);
	}
</script>
</head>
<body>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="index.jsp"> Real Time Chat Service</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="index.jsp">Home</a></li>
				<li><a href="find.jsp">Friends</a></li>
				<li><a href="box.jsp">Messages<span id="unread"
						class="label label-info"></span></a></li>
				<li class="active"><a href="boardView.jsp">Community Board</a></li>
			</ul>
						<ul class="nav navbar-nav navbar-right">
				<li class="dropdwon"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false"> Account <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="update.jsp">Profile</a></li>
						<li><a href="profileUpdate.jsp">Profile Picture</a></li>
						<li><a href="logoutAction.jsp">Log out</a></li>
					</ul></li>
			</ul>
		</div>
	</nav>
	<div class="container">
		<table class="table table-bordered table-hover"
			style="text-align: center; border: 1px solid #DDDDDD">
			<thead>
				<tr>
					<th colspan="5"><h4>Community Board</h4></th>
				</tr>
				<tr>
					<th style="background-color: #fafafa; color: #000000; width: 70px;"><h5>Number</h5></th>
					<th style="background-color: #fafafa; color: #000000;"><h5>Title</h5></th>
					<th
						style="background-color: #fafafa; color: #000000; width: 100px;"><h5>Author</h5></th>
					<th
						style="background-color: #fafafa; color: #000000; width: 100px;"><h5>Date</h5></th>
					<th style="background-color: #fafafa; color: #000000; width: 70px;"><h5>View</h5></th>
				</tr>
			</thead>
			<tbody>
				<%
				 for(BoardDTO board : boardList) {
				%>
				<tr>
					<td><%=board.getBoardID()%></td>
					<td style="text-align: left;"><a href="boardShow.jsp?boardID=<%=board.getBoardID()%>">
				<%
					for(int j = 0; j < board.getBoardLevel(); j++) {
				%>
					<span class="glyphicon glyphicon-arrow-right" aria-hidden="true";></span>
				<%
					}
				%>	
				<%
					if(board.getBoardAvailable() == 0) {
				%>
					(Deleted Post)
				<%
					} else {
				%>
					<%=board.getBoardTitle()%>
				<%
					}
				%>
					</a></td>
					<td><%=board.getUserID()%></td>
					<td><%=board.getBoardDate()%></td>
					<td><%=board.getBoardHit()%></td>
				</tr>
				<%
					}
				%>
				<tr>
					<td colspan="5"><a href="boardWrite.jsp"
						class="btn btn-primary pull-right" type="submit">Post</a>
						<ul class="pagination" style="margin: 0 auto;">
					<%
						int startPage = (Integer.parseInt(pageNumber) / 10) * 10 + 1;
						int maxPage = 0;
						if(Integer.parseInt(pageNumber) % 10 == 0) startPage -= 10;
						int targetPage = new BoardDAO().targetPage(pageNumber);
						if(startPage != 1) {
					%>
						<li><a href="boardView.jsp?pageNumber=<%= startPage - 1 %>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
					<%
						} else {
					%>	
						<li><span class="glyphicon glyphicon-chevron-left" style="color: gray;"></span></li>
					<%
						}
						for(int i = startPage; i < Integer.parseInt(pageNumber); i++) {
					%>
						<li><a href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
						}
					%>
						<li class="active"><a href="boardView.jsp?pageNumber=<%= pageNumber %>"><%= pageNumber %></a></li>
					<%
						for(int i = Integer.parseInt(pageNumber) + 1; i <= targetPage + Integer.parseInt(pageNumber); i++) {
							if(i < startPage + 10) {
					%>
						<li><a href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
							}
						}
						if(targetPage + Integer.parseInt(pageNumber) > startPage + 9) {
					%> 
						<li><a href="boardView.jsp?pageNumber=<%= startPage + 10 %>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
					<%
						} else {
					%>
						<li><span class="glyphicon glyphicon-chevron-right" style="color: gray;"></span></li>
					<%
						}
					%>	
						</ul>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<%
		String messageContent = null;
		if (session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}
		String messageType = null;
		if (session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}
		if (messageContent != null) {
	%>
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog"
		aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div
					class="modal-content <%if (messageType.equals("Error Message"))
					out.println("panel-warning");
				else
					out.println("panel-success");%>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span> <span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title"><%= messageType %></h4>
					</div>
					<div class="modal-body"><%= messageContent %></div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">Check</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
		$('#messageModal').modal("show");
	</script>

	<%
		session.removeAttribute("messageContent");
			session.removeAttribute("messageType");
		}
	%>

	<%
		if (userID != null) {
	%>
	<script type="text/javascript">
		$(document).ready(function() {
		});
	</script>
	<%
		}
	%>

</body>
</html>
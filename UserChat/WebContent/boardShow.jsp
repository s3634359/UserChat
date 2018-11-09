<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.BoardDTO"%>
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
	// 게시물 검증
	String boardID = null;
	if (request.getParameter("boardID") != null) {
		boardID = (String) request.getParameter("boardID");
	}
	if(boardID == null || boardID.equals("")) {
		session.setAttribute("messageType", "Error Message");
		session.setAttribute("messageContent", "Invalid Post");
		response.sendRedirect("index.jsp");
		return;
	}
	BoardDAO boardDAO = new BoardDAO();
	BoardDTO board = boardDAO.getBoard(boardID);
	if(board.getBoardAvailable() == 0) {
		session.setAttribute("messageType", "Error Message");
		session.setAttribute("messageContent", "Unavailable Post");
		response.sendRedirect("boardView.jsp");
		return;		
	}
	boardDAO.hit(boardID);
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
					<th colspan="5"><h4>Post Detail</h4></th>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>Title</h5></td>
					<td colspan="3"><h5><%=board.getBoardTitle()%></h5>
					</td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>Author</h5></td>
					<td colspan="3"><h5><%=board.getUserID()%></h5>
					</td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>Date</h5></td>
					<td><h5><%=board.getBoardDate()%></h5>
					</td>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>View</h5></td>
					<td><h5><%=board.getBoardHit() + 1%></h5>
					</td>
				</tr>
				<tr>
					<td
						style="vertical-align: middle; min-height: 150px; background-color: #fafafa; color: #000000; width: 80px;"><h5>Author</h5></td>
					<td colspan="3" style="text-align: left;"><h5><%=board.getBoardContent()%></h5></td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>Attachment</h5></td>
					<td colspan="3"><h5>
							<a href="boardDownload.jsp?boardID=<%=board.getBoardID()%>"><%=board.getBoardFile()%></a>
						</h5></td>
				</tr>
			</thead>
			<tbody>

				<tr>
					<td colspan="5" style="text-align: right;">
						<a href="boardView.jsp"	class="btn btn-primary">List</a>
						<a href="boardReply.jsp?boardID=<%= board.getBoardID() %>" class="btn btn-primary">Reply</a>
					
					<%
						if(userID.equals(board.getUserID())) {
					%>
						<a href="boardUpdate.jsp?boardID=<%=board.getBoardID()%>"
						class="btn btn-primary">Edit</a> 
						<a href="boardDelete?boardID=<%=board.getBoardID()%>"
						class="btn btn-primary" onclick="return confirm('Do you really want to delete this post?')">Delete</a> 
					<%		
						}
					%>
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
						<h4 class="modal-title"><%=messageType%></h4>
					</div>
					<div class="modal-body"><%=messageContent%></div>
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
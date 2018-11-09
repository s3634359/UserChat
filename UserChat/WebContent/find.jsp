<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "You must log in first");
			response.sendRedirect("index.jsp");
			return;
		}
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
	function findFunction(){
		var userID = $("#findID").val();
		$.ajax({
			type: 'POST',
			url: './UserFindServlet',
			data: {userID: userID},
			success: function(result){
				if(result == -1) {
					$('#checkMessage').html('Failed to find out');
					$('#checkType').attr('class', 'modal-content panel-warning');
					failFriend(); 
				} else {
					$('#checkMessage').html('Successfully found.');
					$('#checkType').attr('class', 'modal-content panel-success');
					var data = JSON.parse(result);
					var profile = data.userProfile;
					getFriend(userID, profile); 
				}
				$('#checkModal').modal("show");
			}
		});
	}
	function getFriend(findID , userProfile){
		$('#friendResult').html('<thead>' +
				'<tr>' +
				'<th><h4>Result</h4></th>' +
				'</tr>' +
				'</thead>' +
				'<tbody>' +
				'<tr>' +
				'<td style="text-align: center;">' +
				'<image class="media-object img-circle" style="max-width: 150px; margin: 0px auto;" src="' + userProfile + '">' +
				'<h3>' + findID + '</h3><a href="chat.jsp?toID=' + encodeURIComponent(findID) + '" class="btn btn-primary pull-right">' + 'Send a Message</a></td>' +
				'</tr>' +
				'</tbody>');
	}
	function failFriend(){
		$('#friendResult').html('');
	}
	function getUnread(){
		$.ajax({
			type: "POST",
			url: "./chatUnread",
			data: {
				userID: encodeURIComponent('<%= userID %>'),
			},
			success: function(result) {
				if(result >= 1) {
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
				<li class="active"><a href="find.jsp">Friends</a></li>
				<li><a href="box.jsp">Messages<span id="unread" class="label label-info"></span></a></li>
				<li><a href="boardView.jsp">Community Board</a></li>
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
			style="text-align: center; border: 1px solid #dddddd;">
			<thead>
				<tr>
					<th colspan="2"><h4>Searching friends</h4></th> 
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="width: 110px;"><h5>Friends</h5></td>
					<td><input class="form-control" type="text" id="findID" maxlength="20" placeholder="ID" /></td> 
				</tr>
				<tr>
					<td colspan="2"><button class="btn btn-primary pull-right" onclick="findFunction();">Search</button></td> 
				</tr>
			</tbody>
		</table>
	</div>
	<div class="container">
		<table id="friendResult" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd;">
		
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
	<div class="modal fade" id="checkModal" tabindex="-1" role="dialog"
		aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div id="checkType" class="modal-content panel-info">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span> <span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">Checking Message</h4>
					</div>
					<div id="checkMessage" class="modal-body"></div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">Check</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
		if(userID != null) {
	%>
		<script type="text/javascript">
			$(document).ready(function() {
				getUnread();
				getInfiniteUnread();
			});
		</script>
	<%
		}
	%>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
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
		UserDTO user = new UserDAO().getUser(userID);
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
	function passwordCheckFunction(){
		var userPassword1 = $('#userPassword1').val();
		var userPassword2 = $('#userPassword2').val();
		if(userPassword1 != userPassword2){
			$('#passwordCheckMessage').html('Enter the same passwords.');
		} else {
			$('#passwordCheckMessage').html('');
		}
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
			<a class="navbar-brand" href="index.jsp"> Real Time Chat
				Service</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="index.jsp">Home</a></li>
				<li><a href="find.jsp">Friends</a></li>
				<li><a href="box.jsp">Messages<span id="unread" class="label label-info"></span></a></li>
				<li><a href="boardView.jsp">Community Board</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdwon"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false"> Account <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li class="active"><a href="update.jsp">Profile</a></li>
						<li><a href="profileUpdate.jsp">Profile Picture</a></li>
						<li><a href="logoutAction.jsp">Log out</a></li>
					</ul></li>
			</ul>
		</div>
	</nav>
	<div class="container">
		<form method="post" action="./userUpdate">
			<table class="table table-bordered table-hover"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2"><h4>Edit Profile</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 100px;"><h5>ID</h5></td>
						<td><h5><%= user.getUserID() %></h5>
						<input type="hidden" name="userID" value="<%= user.getUserID() %>"></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>Password</h5></td>
						<td colspan="2"><input type="password" class="form-control"
							placeholder="Password" id="userPassword1" name="userPassword1"
							maxlength="20" onkeyup="passwordCheckFunction();"></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>Password</h5></td>
						<td colspan="2"><input type="password" class="form-control"
							placeholder="Enter Password Again" id="userPassword2"
							name="userPassword2" maxlength="20"
							onkeyup="passwordCheckFunction();"></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>Name</h5></td>
						<td colspan="2"><input type="text" class="form-control"
							placeholder="Name" id="userName" name="userName" maxlength="20" value="<%= user.getUserName() %>"></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>Age</h5></td>
						<td colspan="2"><input type="text" class="form-control"
							placeholder="Age" id="userAge" name="userAge" maxlength="20" value="<%= user.getUserAge() %>"></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>Gender</h5></td>
						<td colspan="2"><div class="form-group"
								style="text-align: center;">
								<div class="btn-group" data-toggle="buttons">
									<label class="btn btn-primary <% if(user.getUserGender().equals("Male")) out.print("active"); %>"> <input
										type="radio" name="userGender" autocomplete="off" value="Male"
										 <% if(user.getUserGender().equals("Male")) out.print("checked"); %>> &nbsp;&nbsp;Male&nbsp;&nbsp;
									</label> <label class="btn btn-primary <% if(user.getUserGender().equals("Female")) out.print("active"); %>"> <input type="radio"
										name="userGender" autocomplete="off" value="Female" <% if(user.getUserGender().equals("Female")) out.print("checked"); %>>
										Female
									</label>
								</div>
							</div></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>Email</h5></td>
						<td colspan="2"><input type="email" class="form-control"
							placeholder="Email" id="userEmail" name="userEmail"
							maxlength="20" value="<%= user.getUserEmail() %>"></td>
					</tr>
					<tr>
					<td style="text-align: left;" colspan="3"><h5 style="color: red;" id="passwordCheckMessage"></h5><button class="btn btn-primary pull-right" type="submit" name="submit">Edit</button></td>
					</tr>
				</tbody>
			</table>
		</form>
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
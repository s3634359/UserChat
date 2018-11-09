<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP Ajax Chat Service</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="js/bootstrap.js"></script>
<script type="text/javascript">
	function registerCheckFunction() {
		var userID = $("#userID").val();
		$.ajax({
			type: 'POST',
			url: './UserRegisterCheckServlet',
			data: {userID: userID},
			success: function(result){
				if(result == 1){
					$('#checkMessage').html('Available');
					$('#checkType').attr('class', 'modal-content panel-success');
				} else {
					$('#checkMessage').html('Invalid');
					$('#checkType').attr('class', 'modal-content panel-warning');
				}
				$('#checkModal').modal("show");
			}
		});
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
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID != null) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "You are already logged in");
			response.sendRedirect("index.jsp");
		}
	%>
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
			<%
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdwon"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false"> Connect <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">Log in</a></li>
						<li class="active"><a href="join.jsp">Register</a></li>
					</ul></li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	<div class="container">
		<form method="post" action="./userRegister">
			<table class="table table-bordered table-hover"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3"><h4>Register</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 100px;"><h5>ID</h5></td>
						<td><input type="text" class="form-control" placeholder="ID"
							name="userID" id="userID" maxlength="20"></td>
						<td style="width: 100px;"><button type="button"
								class="btn btn-primary" onclick="registerCheckFunction();">Check</button></td>
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
							placeholder="Name" id="userName" name="userName" maxlength="20"></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>Age</h5></td>
						<td colspan="2"><input type="text" class="form-control"
							placeholder="Age" id="userAge" name="userAge" maxlength="20"></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>Gender</h5></td>
						<td colspan="2"><div class="form-group"
								style="text-align: center;">
								<div class="btn-group" data-toggle="buttons">
									<label class="btn btn-primary active"> <input
										type="radio" name="userGender" autocomplete="off" value="Male"
										checked> &nbsp;&nbsp;Male&nbsp;&nbsp;
									</label> <label class="btn btn-primary"> <input type="radio"
										name="userGender" autocomplete="off" value="Female">
										Female
									</label>
								</div>
							</div></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>Email</h5></td>
						<td colspan="2"><input type="email" class="form-control"
							placeholder="Email" id="userEmail" name="userEmail"
							maxlength="20"></td>
					</tr>
					<tr>
					<td style="text-align: left;" colspan="3"><h5 style="color: red;" id="passwordCheckMessage"></h5><button class="btn btn-primary pull-right" type="submit" name="submit">Done</button></td>
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
					class="modal-content <%if(messageType.equals("Error Message"))
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
</body>
</html>
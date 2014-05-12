<cfscript>
param name='Variables.fw.navbar' default='navbar-fixed-top';
param name='Variables.fw.container' default=true;
</cfscript>

</head>
<body>
<cfoutput>
<nav class="navbar-default #Variables.fw.navbar#">
	<div class="navbar-inverse">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="##collapse">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a href="/" class="navbar-brand">#Application.fw.Name#</a>
			</div>
		</div>
	</div>
	<div id="msg" class="container<cfif request.fw.msg NEQ ''> #request.fw.msgClass#</cfif>">
		#request.fw.msg#
	</div>
</nav>
<section id="main" class="<cfif Variables.fw.Container>container<cfelse>noContainer</cfif>"<cfif request.fw.hidden && request.fw.css && request.fw.js> hidden</cfif>>
</cfoutput>

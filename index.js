const { connect } = require("http2");

const express = require("express"),
	session = require("express-session"),
	sha1 = require("sha1"),
	mysql = require("mysql"),
	app = express(),
	middlewareObj = require("./middleware");

// App settings
app.set("port", process.env.PORT || 8888);
app.use(express.json());
app.use(express.static(__dirname + "/public"));

// sql connection
const conn = mysql.createConnection({
	host: "34.141.141.50",
	port: 3306,
	user: "starbucks-admin",
	password: "password",
	database: "starbucks_project",
});

conn.connect((err) => {
	if (err) {
		throw err;
	} else {
		console.log(`Connected to Google Cloud SQL database!!`);
	}
});

// session setup
app.use(
	session({
		secret: "sodfjasdfbasjbdfjsdfb",
		resave: true,
		saveUninitialized: true,
	})
);
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.set("view engine", "ejs");

// global ejs variables
app.use((req, res, next) => {
	res.locals.user = req.session.user;
	next();
});
// setting up Routes
// const questionRoute = require("./routes/question"),
// 	questionResponseRoute = require("./routes/questionResponse"),
// 	userRoute = require("./routes/user");

// Adding Routes
app.get("/", (req, res) => {
	res.render("index.ejs");
});

app.post("/login", (req, res) => {
	const exec_id = req.body.executive_id;
	const exec_pass = req.body.password;
	const statement = `SELECT * FROM executive E, starbucks_chain S WHERE E.executive_id = ${exec_id} 
						AND E.chain_id = S.chain_id`;
	conn.query(statement, (err, result) => {
		if (err) {
			req.session.err_msg = "Invalid administrative id";
		} else {
			const { login_pass, is_admin, chain_id, chain_name, phone_num, email } =
				result[0];
			if (login_pass == sha1(exec_pass)) {
				const user = {
					executive_id: exec_id,
					is_admin: is_admin,
					chain_id: chain_id,
					chain_name: chain_name,
					email: email,
					phone_num: phone_num,
				};
				req.session.loggedin = true;
				req.session.user = user;
				res.redirect("/dashboard");
				return;
			} else {
				req.session.err_msg = "Invalid password";
			}
		}
		res.redirect("/login");
	});
});
app.get("/login", (req, res) => {
	console.log(req.body.err_msg);
	if (req.session.loggedin) {
		res.redirect("/dashboard");
	} else {
		res.render("login.ejs", { err_msg: req.session.err_msg });
	}
});

app.get("/logout", middlewareObj.isLoggedIn, (req, res) => {
	req.session.destroy();
	res.redirect("/");
});

app.get("/dashboard", middlewareObj.isLoggedIn, (req, res) => {
	res.render("dashboard.ejs");
});

app.get("/menu", (req, res) => {
	res.render("menu.ejs");
});
app.get("/employee", middlewareObj.isLoggedIn, (req, res) => {
	res.render("employee.ejs");
});
app.get("/inventory", middlewareObj.isLoggedIn, (req, res) => {
	res.render("inventory.ejs");
});

app.get("/branch-menu", middlewareObj.isLoggedIn, (req, res) => {
	const branch_id = req.session.user.chain_id;
	const statement = `SELECT * FROM main_menu M WHERE M.item_id IN (SELECT item_id FROM chain_menu WHERE chain_id = ${branch_id})`;
	conn.query(statement, (err, result) => {
		if (err) {
			req.session.branch_menu_err_msg =
				"Error fetching menu information for given chain id";
		}
		const branchMenu = result;

		// Find items not in branch menu
		const statement2 = `SELECT * FROM main_menu M WHERE M.item_id NOT IN (SELECT item_id FROM chain_menu WHERE chain_id = ${branch_id})`;
		conn.query(statement2, (err, result) => {
			const notInBranchMenu = result;
			res.render("branch-menu.ejs", {
				branchMenu: branchMenu,
				notInBranchMenu: notInBranchMenu,
				branch_menu_err_msg: req.session.branch_menu_err_msg,
			});
		});
	});
});

app.get("/review", middlewareObj.isLoggedIn, (req, res) => {
	res.render("review.ejs");
});

// Using routes
// app.use(questionRoute);
// app.use(questionResponseRoute);
// app.use(userRoute);

app.listen(app.get("port"), () => {
	console.log(
		`Backend Server has started at http://localhost:${app.get("port")}`
	);
});

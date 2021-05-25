const express = require("express"),
	bodyParser = require("body-parser"),
	session = require("express-session"),
	path = require("path"),
	app = express();

// App settings
app.set("port", process.env.PORT || 8888);
app.use(express.json());
app.use(express.static(__dirname + "/public"));

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

// setting up Routes
// const questionRoute = require("./routes/question"),
// 	questionResponseRoute = require("./routes/questionResponse"),
// 	userRoute = require("./routes/user");

// Adding Routes
app.get("/", (req, res) => {
	res.render("index.ejs");
});

app.post("/login", (req, res) => {
	console.log(req.body);
	if (req.body.email === "admin" && req.body.password === "admin") {
		req.session.loggedin = true;
		req.session.username = req.body.email;
		res.redirect("/dashboard");
	} else {
		res.redirect("/login");
	}
});
app.get("/login", (req, res) => {
	console.log(`the reqiest is: ${req.session}`);
	if (req.session.loggedin) {
		console.log("loggedin");
		res.redirect("/dashboard");
	} else {
		res.render("login.ejs");
	}
});

app.get("/logout", (req, res) => {
	req.session.destroy();
	res.redirect("/");
});

app.get("/dashboard", (req, res) => {
	res.render("dashboard.ejs");
});

app.get("/menu", (req, res) => {
	res.render("menu.ejs");
});
app.get("/employee", (req, res) => {
	res.render("employee.ejs");
});
app.get("/inventory", (req, res) => {
	res.render("inventory.ejs");
});
app.get("/test", (req, res) => {
	res.render("header.ejs");
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

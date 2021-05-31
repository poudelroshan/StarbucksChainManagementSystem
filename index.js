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
	const chain_id = req.session.user.chain_id;
	const statement = `select * from order_hist H, order_hist_details D, 
		(select item_id, item_name, item_price from main_menu WHERE item_id IN
		(select item_id from order_hist H, order_hist_details D WHERE H.order_id = D.order_id)) N
		WHERE H.order_id = D.order_id AND D.item_id = N.item_id AND chain_id = ${chain_id}`;
	conn.query(statement, (err, result) => {
		const order_details = result;
		console.log(order_details);
		res.render("dashboard", { order_details: order_details });
	});
});

app.get("/menu", (req, res) => {
	res.render("menu.ejs");
});
app.get("/employee", middlewareObj.isLoggedIn, (req, res) => {
	const chain_id = req.session.user.chain_id;
	const statement = `select * from employee E, works_in W WHERE
    					E.emp_id = W.emp_id AND W.chain_id = ${chain_id}`;
	conn.query(statement, (err, result) => {
		res.render("employee.ejs", {
			employees: result,
			msg: req.session.msg,
		});
	});
});

app.delete("/api/employee/:emp_id", middlewareObj.isLoggedIn, (req, res) => {
	const emp_id = req.params.emp_id;
	const statement = `DELETE FROM employee WHERE emp_id = '${emp_id}'`;
	conn.query(statement, (err, result) => {
		const statement1 = `DELETE FROM works_in WHERE emp_id = '${emp_id}'`;
		conn.query(statement1, (err, result) => {
			res.send("QUERY OKAY");
		});
	});
});
app.get("/inventory", middlewareObj.isLoggedIn, (req, res) => {
	const chain_id = req.session.user.chain_id;
	const statement = `select * from supply_inventory I, supplies S, supplier SP WHERE
    					I.chain_id = ${chain_id} AND I.supply_id = S.supply_id 
						AND S.supplier_id = SP.supplier_id`;
	conn.query(statement, (err, result) => {
		res.render("inventory.ejs", {
			inventory: result,
		});
	});
});

app.post("/api/inventory/:supply_id", middlewareObj.isLoggedIn, (req, res) => {
	const chain_id = req.session.user.chain_id;
	const supply_id = req.params.supply_id;
	const statement = `UPDATE supply_inventory SET inventory = 100 WHERE chain_id = ${chain_id} 
						AND supply_id = ${supply_id}`;
	conn.query(statement, (err, result) => {
		res.send("QUERY OKAY");
	});
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

app.post("/api/menu/:item_id", middlewareObj.isLoggedIn, (req, res) => {
	const chain_id = req.session.user.chain_id;
	const item_id = req.params.item_id;
	const statement = `INSERT INTO chain_menu VALUES(${chain_id}, ${item_id})`;
	conn.query(statement, (err, result) => {
		res.send("QUERY OKAY");
	});
});

app.delete("/api/menu/:item_id", middlewareObj.isLoggedIn, (req, res) => {
	const chain_id = req.session.user.chain_id;
	const item_id = req.params.item_id;
	const statement = `DELETE FROM chain_menu WHERE chain_id = ${chain_id} AND item_id = ${item_id}`;
	conn.query(statement, (err, result) => {
		res.send("QUERY OKAY");
	});
});

app.get("/sales", middlewareObj.isLoggedIn, (req, res) => {
	const branch_id = req.session.user.chain_id;
	const statement = `SELECT * FROM main_menu M WHERE M.item_id IN (SELECT item_id FROM chain_menu WHERE chain_id = ${branch_id})`;
	conn.query(statement, (err, result) => {
		if (err) {
			req.session.branch_menu_err_msg =
				"Error fetching menu information for given chain id";
		}
		const branchMenu = result;
		const menuObjList = [];
		for (let i = 0; i < branchMenu.length; i++) {
			menuObjList.push({
				item_id: branchMenu[i].item_id,
				item_name: branchMenu[i].item_name,
				item_size: branchMenu[i].item_size,
				item_price: branchMenu[i].item_price,
			});
		}
		res.render("sales", {
			branchMenu: menuObjList,
			orderSuccess: req.session.orderSuccess,
		});
	});
});

app.post("/api/order", middlewareObj.isLoggedIn, (req, res) => {
	console.log(req.body);
	const order_id = sha1(new Date());
	const chain_id = req.session.user.chain_id;
	const customer_id = req.body.customer_id;
	const orders = req.body.order;
	const order_date = new Date().toISOString().slice(0, 19).replace("T", " ");
	for (const item_id in orders) {
		const item_quantity = orders[item_id];
		let statement = `INSERT INTO order_hist_details VALUES ('${order_id}', ${item_id}, ${item_quantity})`;
		conn.query(statement, (err, result) => {});
	}
	let statement1 = `INSERT INTO order_hist VALUES ('${order_id}', ${customer_id}, '${order_date}',${chain_id} )`;
	conn.query(statement1, (err, result) => {
		req.session.orderSuccess = "Order added to Database!!!";
		res.send("OK");
	});
});

app.post("/api/employee", middlewareObj.isLoggedIn, (req, res) => {
	console.log(req.body);
	const emp_id = sha1(new Date());
	const chain_id = req.session.user.chain_id;
	const since = new Date().toISOString().slice(0, 19).replace("T", " ");
	const phone_num = req.body.employeePhonenum;
	const title = req.body.title;
	const name = req.body.employeeName;
	const dept_name = req.body.department;
	const salary = req.body.salary;

	const statement = `SELECT * FROM department WHERE chain_id = ${chain_id} AND dept_name = '${dept_name}'`;
	console.log(statement);
	conn.query(statement, (err, result) => {
		console.log(result);
		const dept_id = result[0].dept_id;
		const statement1 = `INSERT INTO employee VALUES ('${emp_id}', '${name}', '${phone_num}')`;
		conn.query(statement1, (err, result) => {
			if (err) {
				console.log(err);
			}
			const statement2 = `INSERT INTO works_in VALUES ('${emp_id}', '${dept_id}', ${chain_id}, '${since}', '${title}', ${salary})`;
			conn.query(statement2, (err, result) => {
				if (err) {
					console.log(err);
				}

				req.session.msg = "Employee added to the database";
				res.redirect("/employee");
			});
		});
	});
});

// Using routes
// app.use(questionRoute);
// app.use(questionResponseRoute);
// app.use(userRoute);
app.get("/test", (req, res) => {
	res.send(`${new Date()} <br> ${sha1(new Date())}`);
});
app.listen(app.get("port"), () => {
	console.log(
		`Backend Server has started at http://localhost:${app.get("port")}`
	);
});

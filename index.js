const express = require("express"),
	session = require("express-session"),
	sha1 = require("sha1"),
	mysql = require("mysql"),
	app = express(),
	moment = require("moment"),
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
	// Admin of Starbucks
	if (exec_id === "admin" && sha1("admin") == sha1(exec_pass)) {
		req.session.loggedin = true;
		res.redirect("/admin");
		return;
	}

	// Non admin (Managers)
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

app.post("/api/admin/bmgr", (req, res) => {
	const { location, branch_name } = req.body;
	let statement = "";
	if (branch_name === "") {
		statement = `SELECT * FROM executive E, starbucks_chain S 
							WHERE E.chain_id = S.chain_id`;
	} else {
		statement = `SELECT * FROM executive E, starbucks_chain S 
							WHERE E.chain_id = S.chain_id AND
							S.chain_name = '${branch_name}'`;
	}
	conn.query(statement, (err, result) => {
		result.push(location);
		res.json(result);
	});
});
// select * from department d, employee e, works_in w, starbucks_chain s where d.emp_id = e.emp_id
// AND w.chain_id = s.chain_id AND w.emp_id = e.emp_id AND s.chain_name = 'New York';
//select * from department D, employee E where D.dept_name = 'finance' AND D.mgr_id = E.emp_id;
//select * from starbucks_chain C, department D, employee E, works_in W where D.dept_name = 'finance' AND D.dept_id = W.dept_id AND
//D.mgr_id = E.emp_id AND D.mgr_id = W.emp_id AND W.chain_id = C.chain_id;
app.post("/api/admin/dmgr", (req, res) => {
	const { department, branch_name } = req.body;
	let statement = "";
	if (branch_name === "") {
		statement = `select * from starbucks_chain C, department D, employee E, works_in W where D.dept_name = '${department}' AND 
					D.dept_id = W.dept_id AND D.mgr_id = E.emp_id AND D.mgr_id = W.emp_id AND W.chain_id = C.chain_id`;
	} else {
		statement = `select * from starbucks_chain C, department D, employee E, works_in W where D.dept_name = '${department}' AND 
					D.dept_id = W.dept_id AND D.mgr_id = E.emp_id AND D.mgr_id = W.emp_id AND W.chain_id = C.chain_id AND C.chain_name = '${branch_name}'`;
	}
	conn.query(statement, (err, result) => {
		console.log(err);
		console.log(result);
		res.json(result);
	});
});

app.post("/api/admin/cfac", (req, res) => {
	const { branch_name } = req.body;
	let statement = `select * from chain_facility f, starbucks_chain s where s.chain_name= '${branch_name}' AND f.chain_id = s.chain_id`;
	conn.query(statement, (err, result) => {
		res.json(result);
	});
});

app.post("/api/admin/crat", (req, res) => {
	const { branch_name } = req.body;
	let statement = `select * from ratings r, starbucks_chain c where c.chain_name = '${branch_name}' AND r.chain_id = c.chain_id`;
	conn.query(statement, (err, result) => {
		console.log(result);
		res.json(result);
	});
});

// select * from department d, works_in w, starbucks_chain c where d.dept_id = w.dept_id AND c.chain_id = w.chain_id AND c.chain_name = 'new york'
// mysql> select * from employee e,  department d, works_in w, starbucks_chain c where d.dept_id = w.dept_id AND c.chain_id = w.chain_id AND c.chain_name = 'new york' AND d.dept_name = 'Coffee House' AND e.emp_id = w.emp_id;
app.post("/api/admin/gemp", (req, res) => {
	const { branch_name, dept_name } = req.body;
	let statement = `select * from department d, employee e, works_in w, starbucks_chain c where d.dept_id = w.dept_id AND c.chain_id = w.chain_id 
					AND c.chain_name = '${branch_name}' AND d.dept_name = '${dept_name}' AND e.emp_id = w.emp_id`;
	conn.query(statement, (err, result) => {
		res.json(result);
	});
});

app.post("/api/admin/gsal", (req, res) => {
	const { branch_name, from, to } = req.body;
	console.log(req.body);
	const statement = `select * from main_menu m, order_hist_details D, order_hist H, starbucks_chain s, customer c WHERE
H.chain_id = s.chain_id AND D.order_id = H.order_id AND c.cust_id = H.cust_id AND m.item_id = D.item_id AND s.chain_name = '${branch_name}'`;
	conn.query(statement, (err, result) => {
		console.log(err);
		const order_details = result;
		console.log(result);
		res.json(result);
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
		const statement2 = `select count(*) AS c from order_hist where chain_id = ${chain_id} AND datediff(curdate(), order_hist.order_date) < 30;`;
		conn.query(statement2, (err, result1) => {
			const num_cust_last_month = result1;
			res.render("dashboard", {
				order_details: order_details,
				cust_count: result1[0].c,
			});
		});
	});
});

// app.get("/admin", middlewareObj.isLoggedIn, (req, res) => {
app.get("/admin", middlewareObj.isLoggedIn, (req, res) => {
	res.render("admin.ejs");
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
	const branch_id = req.session.user.chain_id;
	const statement = `select * from ratings R, customer C where C.cust_id = R.cust_id AND R.chain_id = ${branch_id}`;
	conn.query(statement, (err, result) => {
		console.log(err);
		console.log(result);
		let rating = 0;
		let star_count = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
		for (let i = 0; i < result.length; i++) {
			rating += result[i].rating / result.length;
			star_count[result[i].rating] += 1;
		}
		console.log(star_count);
		res.render("review.ejs", {
			reviews: result,
			rating: Math.ceil(rating),
			star_count: star_count,
		});
	});
});

app.get("/cust-signup", (req, res) => {
	res.render("cust-signup.ejs");
});

app.post("/api/cust-signup", (req, res) => {
	const { customer_name, customer_id, phone_num } = req.body;
	const statement = `INSERT INTO customer VALUES(${customer_id}, '${customer_name}', '${phone_num}')`;
	conn.query(statement, (err, result) => {
		res.redirect("/customer-review");
	});
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
	const emp_id = sha1(new Date());
	const chain_id = req.session.user.chain_id;
	const since = new Date().toISOString().slice(0, 19).replace("T", " ");
	const phone_num = req.body.employeePhonenum;
	const title = req.body.title;
	const name = req.body.employeeName;
	const dept_name = req.body.department;
	const salary = req.body.salary;

	const statement = `SELECT * FROM department WHERE chain_id = ${chain_id} AND dept_name = '${dept_name}'`;
	conn.query(statement, (err, result) => {
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

app.get("/customer-review", (req, res) => {
	res.render("cust-review.ejs");
});

app.post("/api/review", (req, res) => {
	const { chain_id, customer_id, review, star } = req.body;
	let statement1 = `INSERT INTO ratings VALUES (${customer_id}, ${chain_id}, ${star}, '${review}', '${new Date()
		.toISOString()
		.slice(0, 19)
		.replace("T", " ")}' )`;
	conn.query(statement1, (err, result) => {
		console.log(err);
		res.redirect("/customer-review");
	});
});

app.get("/*", (req, res) => {
	res.render("404.ejs");
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

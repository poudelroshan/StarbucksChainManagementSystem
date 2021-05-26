const middlewareObj = {};

middlewareObj.isLoggedIn = (req, res, next) => {
	if (req.session.loggedin) {
		next();
	} else {
		req.session.err_msg = "You need to login to access that page";
		res.redirect("/login");
	}
};

module.exports = middlewareObj;

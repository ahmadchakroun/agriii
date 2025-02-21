const express = require("express");
const { getUsers, getUsersByType } = require("../controllers/user.controller");
const router = express.Router();
const { validateToken } = require("../middleware/auth");

router.get("/users", validateToken, getUsers);
router.get("/type/:type", validateToken, getUsersByType);

module.exports = router;
const express = require("express");
const { getUsers, getUsersByType , getUserById} = require("../controllers/user.controller");
const router = express.Router();
const { validateToken } = require("../middleware/auth");

router.get("/users", validateToken, getUsers);
router.get("/type/:type", validateToken, getUsersByType);
router.get("/users/:id", validateToken, getUserById);  
module.exports = router;
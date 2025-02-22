const express = require("express");
const { register, login,update,favorite ,getFavorites} = require("../controllers/auth.controller");
const router = express.Router();
const { validateToken } = require("../middleware/auth");


router.post("/register", register);
router.post("/login", login);

router.put("/update/:id", validateToken, update);
router.post("/favorites/:favoriteUserId", validateToken, favorite);
router.get("/favorites", validateToken, getFavorites);

module.exports = router;

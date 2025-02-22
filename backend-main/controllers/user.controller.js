const User = require("../models/User");

const getUsers = async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
const getUserById = async (req, res) => {
  try {
    const { id } = req.params;
    const user = await User.findById(id).select("-password");

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
const getUsersByType = async (req, res) => {
  try {
    const { type } = req.params;
    console.log("Fetching users of type:", type); // Debugging

    if (!["Ingenieurs", "Bureau d’étude"].includes(type)) {
      return res.status(400).json({ error: "Invalid user type" });
    }

    const users = await User.find({ userType: type }).select("-password");
    console.log("Users found:", users); // Debugging
    res.status(200).json(users);
  } catch (error) {
    console.error("Error in getUsersByType:", error); // Debugging
    res.status(500).json({ error: error.message });
  }
};

module.exports = { getUsers, getUsersByType ,getUserById};
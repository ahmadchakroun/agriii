const { registerUser, loginUser ,getFavoriteUsers  ,addToFavorites  , updateUserById} = require("../services/auth.service");

const register = async (req, res) => {
  try {
    const result = await registerUser(req.body);
    res.status(201).json(result);  // ✅ Ensure a proper JSON response with status code 201
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

const login = async (req, res) => {
  try {
    console.log("📥 Incoming Request Body:", req.body); // Debugging

    if (!req.body.password) {
      throw new Error("❌ Password is missing in request!");
    }

    const result = await loginUser(req.body);
    res.json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
const update = async (req, res) => {
  try {
    // Get user ID from token instead of URL params
    const userId = req.user.id;
    const updateData = req.body;

    console.log("Updating user ID:", userId); // Debugging
    console.log("Update Data:", updateData); // Debugging

    const result = await updateUserById(userId, updateData);
    res.status(200).json(result);
  } catch (error) {
    console.error("Error in update:", error);
    res.status(400).json({ error: error.message });
  }
};
// Add to Favorites
const getFavorites = async (req, res) => {
  try {
    const favorites = await getFavoriteUsers(req.user.id);
    res.status(200).json({ favorites });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

const favorite = async (req, res) => {
  try {
    const updatedUser = await addToFavorites(
      req.user.id,
      req.params.favoriteUserId
    );
    res.status(200).json(updatedUser);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

module.exports = { update, favorite, getFavorites ,login,register};


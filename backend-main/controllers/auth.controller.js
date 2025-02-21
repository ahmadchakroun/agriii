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
    const { id } = req.params; // Get user ID from URL
    const updateData = req.body; // Get update data from request body

    console.log("Request Body:", req.body); // Debugging

    const result = await updateUserById(id, updateData);
    res.status(200).json(result);
  } catch (error) {
    console.error("Error in update:", error); // Debugging
    res.status(400).json({ error: error.message });
  }
};
// Add to Favorites
const favorite = async (req, res) => {
  try {
    const result = await addToFavorites(req.user.id, req.params.favoriteUserId);
    res.status(200).json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get List of Favorited Users
const getFavorites = async (req, res) => {
  try {
    const result = await getFavoriteUsers(req.user.id);
    res.status(200).json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

module.exports = { update, favorite, getFavorites ,login,register};


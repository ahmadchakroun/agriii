const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
const { createTokens } = require("../JWT/jwt");

// Register User
const registerUser = async ({ username, password, email }) => {
  const existingUser = await User.findOne({ username });
  if (existingUser) throw new Error("Username already exists");

  const hashedPassword = await bcrypt.hash(password, 10);
  const newUser = new User({ username, password: hashedPassword, email });
  await newUser.save();

  return { message: "✅ USER REGISTERED" };
};

// Login User
const loginUser = async ({ username, password }) => {
  console.log("🔍 Checking username:", username);

  const user = await User.findOne({ username });
  if (!user) {
    console.log("❌ User not found");
    throw new Error("User Doesn't Exist");
  }

  console.log("✅ User found:", user.username);
  console.log("🔒 Stored Hashed Password:", user.password);
  console.log("🔑 Entered Password:", password);

  if (!password) {
    console.log("❌ Received empty password!");
    throw new Error("Password is required");
  }

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) {
    console.log("❌ Password does not match");
    throw new Error("Wrong Username and Password!");
  }

  console.log("🔑 Generating token...");
  const accessToken = createTokens(user);
  console.log("Generated Token:", accessToken);
  return { message: "✅ LOGGED IN", accessToken };
};

// Update User Information
const updateUserById = async (userId, updateData) => {
  console.log("Updating user with ID:", userId); // Debugging
  console.log("Update Data:", updateData); // Debugging

  const user = await User.findById(userId);
  if (!user) throw new Error("User not found");

  // If updating password, hash it first
  if (updateData.password) {
    updateData.password = await bcrypt.hash(updateData.password, 10);
  }

  const updatedUser = await User.findByIdAndUpdate(
    userId,
    updateData,
    { new: true } // Return the updated document
  );

  console.log("Updated User:", updatedUser); // Debugging
  return { message: "✅ USER UPDATED", user: updatedUser };
};
// Add to Favorites
const addToFavorites = async (userId, favoriteUserId) => {
  const user = await User.findById(userId);
  const favoriteUser = await User.findById(favoriteUserId);

  if (!user || !favoriteUser) throw new Error("User not found");

  if (!user.favorites.includes(favoriteUserId)) {
    user.favorites.push(favoriteUserId);
    await user.save();
  }

  return { message: "✅ USER ADDED TO FAVORITES" };
};

// Get List of Favorited Users
const getFavoriteUsers = async (userId) => {
  const user = await User.findById(userId).populate("favorites", "username email");
  if (!user) throw new Error("User not found");

  return { favorites: user.favorites };
};

module.exports = { registerUser, loginUser, updateUserById, addToFavorites, getFavoriteUsers };

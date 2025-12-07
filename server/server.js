


// //sjdknfskdjfndkjfnfk
// const express = require("express");
// const mongoose = require("mongoose");
// const cors = require("cors");

// const app = express();

// // Routes
// const readingHistoryRoutes = require("./routes/readingHistory");

// // ----------------------------
// // Middleware
// // ----------------------------
// app.use(cors({ origin: "*" }));
// app.use(express.json({ limit: "10mb" }));

// // ----------------------------
// // MongoDB (using environment variable from Render)
// // ----------------------------
// mongoose
//   .connect(process.env.MONGO_URI, {
//     useNewUrlParser: true,
//     useUnifiedTopology: true,
//   })
//   .then(() => console.log("✅ MongoDB Connected"))
//   .catch((err) => console.log("❌ MongoDB Error:", err));

// // ----------------------------
// // Schema (Feature)
// // ----------------------------
// const FeatureSchema = new mongoose.Schema(
//   {
//     title: String,
//     description: String,
//     image: String,
//     steps: [
//       {
//         title: String,
//         content: String,
//       }
//     ]
//   },
//   { timestamps: true }
// );

// const Feature = mongoose.model("Feature", FeatureSchema);

// // ----------------------------
// // Routes
// // ----------------------------

// // Test Route
// app.get("/", (req, res) => {
//   res.send("Server is running 🔥");
// });

// // Reading History Routes
// app.use("/api/reading-history", readingHistoryRoutes);

// // Add Feature
// app.post("/api/feature/add", async (req, res) => {
//   try {
//     const { title, description, image, steps } = req.body;

//     const newFeature = await Feature.create({
//       title,
//       description,
//       image,
//       steps: Array.isArray(steps) ? steps : []
//     });

//     res.status(200).json({ message: "Feature added", feature: newFeature });
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });

// // Get All Features
// app.get("/api/feature/all", async (req, res) => {
//   try {
//     const features = await Feature.find().sort({ createdAt: -1 });
//     res.json(features);
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });

// // Update Feature
// app.put("/api/feature/update/:id", async (req, res) => {
//   try {
//     const { title, description, image, steps } = req.body;

//     const updateData = {
//       title,
//       description,
//     };

//     if (image) updateData.image = image;
//     if (steps) updateData.steps = steps;

//     const updated = await Feature.findByIdAndUpdate(req.params.id, updateData, {
//       new: true,
//     });

//     res.json({ message: "Feature updated", feature: updated });
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });

// // Delete Feature
// app.delete("/api/feature/delete/:id", async (req, res) => {
//   try {
//     await Feature.findByIdAndDelete(req.params.id);
//     res.json({ message: "Feature deleted" });
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });

// // ----------------------------
// // Run Server on Render
// // ----------------------------
// const PORT = process.env.PORT || 3000;

// app.listen(PORT, () => {
//   console.log(`🚀 Server running on port ${PORT}`);
// });


// ----------------------------
// server.js
// ----------------------------
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const dotenv = require("dotenv");

// Load environment variables from .env in local development
if (process.env.NODE_ENV !== "production") {
  dotenv.config();
}

const app = express();

// ----------------------------
// Middleware
// ----------------------------
app.use(cors({ origin: "*" }));
app.use(express.json({ limit: "10mb" }));

// ----------------------------
// MongoDB connection
// ----------------------------
const mongoUri = process.env.MONGO_URI;

if (!mongoUri) {
  console.error(
    "❌ MONGO_URI is not defined! Set it in .env (for local) or Render environment variables."
  );
  process.exit(1); // Stop server if URI is missing
}

mongoose
  .connect(mongoUri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("✅ MongoDB Connected"))
  .catch((err) => console.error("❌ MongoDB Connection Error:", err));

// ----------------------------
// Schemas
// ----------------------------

// Feature Schema
const FeatureSchema = new mongoose.Schema(
  {
    title: String,
    description: String,
    image: String,
    steps: [
      {
        title: String,
        content: String,
      },
    ],
  },
  { timestamps: true }
);

const Feature = mongoose.model("Feature", FeatureSchema);

// Likes Schema
const LikeSchema = new mongoose.Schema(
  {
    userId: { type: String, required: true },
    moduleId: { type: String, required: true },
  },
  { timestamps: true }
);

const Like = mongoose.model("Like", LikeSchema);

// ----------------------------
// Test Route
// ----------------------------
app.get("/", (req, res) => {
  res.send("Server is running 🔥");
});

// ----------------------------
// Feature Routes
// ----------------------------

// Add Feature
app.post("/api/feature/add", async (req, res) => {
  try {
    const { title, description, image, steps } = req.body;
    const newFeature = await Feature.create({
      title,
      description,
      image,
      steps: Array.isArray(steps) ? steps : [],
    });
    res.status(200).json({ message: "Feature added", feature: newFeature });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get All Features
app.get("/api/feature/all", async (req, res) => {
  try {
    const features = await Feature.find().sort({ createdAt: -1 });
    res.json(features);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update Feature
app.put("/api/feature/update/:id", async (req, res) => {
  try {
    const { title, description, image, steps } = req.body;
    const updateData = { title, description };
    if (image) updateData.image = image;
    if (steps) updateData.steps = steps;

    const updated = await Feature.findByIdAndUpdate(req.params.id, updateData, { new: true });
    res.json({ message: "Feature updated", feature: updated });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete Feature
app.delete("/api/feature/delete/:id", async (req, res) => {
  try {
    await Feature.findByIdAndDelete(req.params.id);
    res.json({ message: "Feature deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ----------------------------
// Likes Routes
// ----------------------------

// Like a module
app.post("/api/likes/like", async (req, res) => {
  try {
    const { userId, moduleId } = req.body;
    if (!userId || !moduleId) return res.status(400).json({ error: "Missing userId or moduleId" });

    const existing = await Like.findOne({ userId, moduleId });
    if (existing) return res.status(400).json({ error: "Already liked" });

    const like = new Like({ userId, moduleId });
    await like.save();
    res.status(200).json({ message: "Liked successfully" });
  } catch (err) {
    res.status(500).json({ error: "Server error" });
  }
});

// Unlike a module
app.post("/api/likes/unlike", async (req, res) => {
  try {
    const { userId, moduleId } = req.body;
    if (!userId || !moduleId) return res.status(400).json({ error: "Missing userId or moduleId" });

    await Like.deleteOne({ userId, moduleId });
    res.status(200).json({ message: "Unliked successfully" });
  } catch (err) {
    res.status(500).json({ error: "Server error" });
  }
});

// Get total likes for a module
app.get("/api/likes/count/:moduleId", async (req, res) => {
  try {
    const { moduleId } = req.params;
    const count = await Like.countDocuments({ moduleId });
    res.status(200).json({ likes: count });
  } catch (err) {
    res.status(500).json({ error: "Server error" });
  }
});

// Check if a user liked a module
app.get("/api/likes/check/:userId/:moduleId", async (req, res) => {
  try {
    const { userId, moduleId } = req.params;
    const liked = await Like.exists({ userId, moduleId });
    res.status(200).json({ liked: !!liked });
  } catch (err) {
    res.status(500).json({ error: "Server error" });
  }
});

// ----------------------------
// Start Server
// ----------------------------
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});




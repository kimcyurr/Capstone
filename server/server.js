// const express = require("express");
// const mongoose = require("mongoose");
// const cors = require("cors");

// const app = express();

// // ----------------------------
// // Middleware
// // ----------------------------
// app.use(cors()); // allow requests from any origin
// app.use(express.json({ limit: "10mb" })); // allow large JSON payloads (images)

// // ----------------------------
// // Connect to MongoDB Atlas
// // ----------------------------
// mongoose
//   .connect(
//     "mongodb+srv://aureakimcyrus15:cymik123@capstone.db06dq4.mongodb.net/capstone?retryWrites=true&w=majority"
//   )
//   .then(() => console.log("✅ MongoDB Connected"))
//   .catch((err) => console.log("❌ MongoDB connection error:", err));

// // ----------------------------
// // Mongoose Schema
// // ----------------------------
// const FeatureSchema = new mongoose.Schema(
//   {
//     title: String,
//     description: String,
//     image: String, // base64 string
//   },
//   { timestamps: true } // automatically add createdAt/updatedAt
// );

// const Feature = mongoose.model("Feature", FeatureSchema);

// // ----------------------------
// // Routes
// // ----------------------------

// // Test route
// app.get("/", (req, res) => {
//   res.send("Server is running");
// });

// // Add a new feature
// app.post("/api/feature/add", async (req, res) => {
//   console.log("POST /api/feature/add hit");
//   console.log("Request body:", req.body);

//   try {
//     const { title, description, image } = req.body;

//     if (!title || !description || !image) {
//       return res
//         .status(400)
//         .json({ error: "Missing title, description, or image" });
//     }

//     const feature = new Feature({ title, description, image });
//     await feature.save();

//     console.log("✅ Feature saved to MongoDB:", feature);
//     res.status(200).json({ message: "Feature saved successfully" });
//   } catch (e) {
//     console.log("❌ Error saving feature:", e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // Get all features
// app.get("/api/feature/all", async (req, res) => {
//   try {
//     const features = await Feature.find().sort({ createdAt: -1 });
//     res.status(200).json(features);
//   } catch (e) {
//     console.log("❌ Error fetching features:", e);
//     res.status(500).json({ error: e.message });
//   }
// });

// // ----------------------------
// // Start Server
// // ----------------------------
// const PORT = 3000;
// app.listen(PORT, "0.0.0.0", () =>
//   console.log(`🚀 Server running on http://localhost:${PORT}`)
// );

const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();

// ----------------------------
// Middleware
// ----------------------------
app.use(cors()); // allow requests from any origin
app.use(express.json({ limit: "10mb" })); // allow large JSON payloads (images)

// ----------------------------
// Connect to MongoDB Atlas
// ----------------------------
mongoose
  .connect(
    "mongodb+srv://aureakimcyrus15:cymik123@capstone.db06dq4.mongodb.net/capstone?retryWrites=true&w=majority"
  )
  .then(() => console.log("✅ MongoDB Connected"))
  .catch((err) => console.log("❌ MongoDB connection error:", err));

// ----------------------------
// Mongoose Schema
// ----------------------------
const FeatureSchema = new mongoose.Schema(
  {
    title: String,
    description: String,
    image: String, // base64 string
  },
  { timestamps: true } // automatically add createdAt/updatedAt
);

const Feature = mongoose.model("Feature", FeatureSchema);

// ----------------------------
// Routes
// ----------------------------

// Test route
app.get("/", (req, res) => {
  res.send("Server is running");
});

// Add a new feature
app.post("/api/feature/add", async (req, res) => {
  console.log("POST /api/feature/add hit");
  console.log("Request body:", req.body);

  try {
    const { title, description, image } = req.body;

    if (!title || !description || !image) {
      return res
        .status(400)
        .json({ error: "Missing title, description, or image" });
    }

    const feature = new Feature({ title, description, image });
    await feature.save();

    console.log("✅ Feature saved to MongoDB:", feature);
    res.status(200).json({ message: "Feature saved successfully", feature });
  } catch (e) {
    console.log("❌ Error saving feature:", e);
    res.status(500).json({ error: e.message });
  }
});

// Get all features
app.get("/api/feature/all", async (req, res) => {
  try {
    const features = await Feature.find().sort({ createdAt: -1 });
    res.status(200).json(features);
  } catch (e) {
    console.log("❌ Error fetching features:", e);
    res.status(500).json({ error: e.message });
  }
});

// ----------------------------
// UPDATE Feature (Edit)
// ----------------------------
app.put("/api/feature/update/:id", async (req, res) => {
  try {
    const { title, description, image } = req.body;

    const updateData = { title, description };
    if (image) updateData.image = image; // only update image if provided

    const updatedFeature = await Feature.findByIdAndUpdate(
      req.params.id,
      updateData,
      { new: true } // return updated document
    );

    if (!updatedFeature) {
      return res.status(404).json({ error: "Feature not found" });
    }

    res
      .status(200)
      .json({ message: "Feature updated successfully", feature: updatedFeature });
  } catch (e) {
    console.log("❌ Error updating feature:", e);
    res.status(500).json({ error: e.message });
  }
});

// ----------------------------
// DELETE Feature
// ----------------------------
app.delete("/api/feature/delete/:id", async (req, res) => {
  try {
    const deletedFeature = await Feature.findByIdAndDelete(req.params.id);

    if (!deletedFeature) {
      return res.status(404).json({ error: "Feature not found" });
    }

    res.status(200).json({ message: "Feature deleted successfully" });
  } catch (e) {
    console.log("❌ Error deleting feature:", e);
    res.status(500).json({ error: e.message });
  }
});

// ----------------------------
// Start Server
// ----------------------------
const PORT = 3000;
app.listen(PORT, "0.0.0.0", () =>
  console.log(`🚀 Server running on http://localhost:${PORT}`)
);

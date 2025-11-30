
// const express = require("express");
// const mongoose = require("mongoose");
// const cors = require("cors");
// const os = require("os");

// const app = express();
// const readingHistoryRoutes = require("./routes/readingHistory");
// // const readingHistoryRoutes = require("./routes/readingHistory");
// // app.use("/api/reading-history", readingHistoryRoutes);
// // At the top of server.js


// // After other routes



// // ----------------------------
// // Get Local IP (for mobile testing)
// // ----------------------------
// function getLocalIP() {
//   const interfaces = os.networkInterfaces();
//   for (let name in interfaces) {
//     for (let iface of interfaces[name]) {
//       if (iface.family === "IPv4" && !iface.internal && iface.address.startsWith("192.168")) {
//         return iface.address;
//       }
//     }
//   }
//   return "localhost";
// }

// const LOCAL_IP = getLocalIP();

// // ----------------------------
// // Middleware
// // ----------------------------
// app.use(cors({ origin: "*" }));
// app.use(express.json({ limit: "10mb" }));

// // ----------------------------
// // MongoDB
// // ----------------------------
// mongoose
//   .connect("process.env.mongodb+srv://aureakimcyrus15:cymik123@capstone.db06dq4.mongodb.net/capstone")
//   .then(() => console.log("✅ MongoDB Connected"))
//   .catch((err) => console.log("❌ MongoDB Error:", err));

// // ----------------------------
// // Schema Update (IMPORTANT)
// // ----------------------------
// // steps: [{ title: String, content: String }]
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
//     if (steps) updateData.steps = steps; // now array of objects

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
// // Run Server
// // ----------------------------
// const PORT = 3000;
// app.listen(PORT, "0.0.0.0", () => {
//   console.log("🚀 Server running!");
//   console.log(`📱 Mobile: http://${LOCAL_IP}:${PORT}`);
//   console.log(`💻 PC: http://localhost:${PORT}`);
// });



//sjdknfskdjfndkjfnfk
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();

// Routes
const readingHistoryRoutes = require("./routes/readingHistory");

// ----------------------------
// Middleware
// ----------------------------
app.use(cors({ origin: "*" }));
app.use(express.json({ limit: "10mb" }));

// ----------------------------
// MongoDB (using environment variable from Render)
// ----------------------------
mongoose
  .connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("✅ MongoDB Connected"))
  .catch((err) => console.log("❌ MongoDB Error:", err));

// ----------------------------
// Schema (Feature)
// ----------------------------
const FeatureSchema = new mongoose.Schema(
  {
    title: String,
    description: String,
    image: String,
    steps: [
      {
        title: String,
        content: String,
      }
    ]
  },
  { timestamps: true }
);

const Feature = mongoose.model("Feature", FeatureSchema);

// ----------------------------
// Routes
// ----------------------------

// Test Route
app.get("/", (req, res) => {
  res.send("Server is running 🔥");
});

// Reading History Routes
app.use("/api/reading-history", readingHistoryRoutes);

// Add Feature
app.post("/api/feature/add", async (req, res) => {
  try {
    const { title, description, image, steps } = req.body;

    const newFeature = await Feature.create({
      title,
      description,
      image,
      steps: Array.isArray(steps) ? steps : []
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

    const updateData = {
      title,
      description,
    };

    if (image) updateData.image = image;
    if (steps) updateData.steps = steps;

    const updated = await Feature.findByIdAndUpdate(req.params.id, updateData, {
      new: true,
    });

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
// Run Server on Render
// ----------------------------
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});


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
// app.use(express.json({ limit: "20mb" })); // Increase limit for Base64 images

// // ----------------------------
// // MongoDB (using Render env variable)
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
// const StepSchema = new mongoose.Schema({
//   title: String,
//   content: String,
//   image: String, // <-- ADDED THIS
// });

// const FeatureSchema = new mongoose.Schema(
//   {
//     title: String,
//     description: String,
//     image: String, // base64 string
//     steps: [StepSchema], // <-- Step images now supported
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

// // ============================
// // ADD FEATURE
// // ============================
// app.post("/api/feature/add", async (req, res) => {
//   try {
//     const { title, description, image, steps } = req.body;

//     const formattedSteps = Array.isArray(steps)
//       ? steps.map((s) => ({
//           title: s.title || "",
//           content: s.content || "",
//           image: s.image || null, // <-- Store image
//         }))
//       : [];

//     const newFeature = await Feature.create({
//       title,
//       description,
//       image,
//       steps: formattedSteps,
//     });

//     res.status(200).json({ message: "Feature added", feature: newFeature });
//   } catch (err) {
//     console.log("❌ Add Feature Error:", err);
//     res.status(500).json({ error: err.message });
//   }
// });

// // ============================
// // GET ALL FEATURES
// // ============================
// app.get("/api/feature/all", async (req, res) => {
//   try {
//     const features = await Feature.find().sort({ createdAt: -1 });
//     res.json(features);
//   } catch (err) {
//     console.log("❌ Get All Error:", err);
//     res.status(500).json({ error: err.message });
//   }
// });

// // ============================
// // UPDATE FEATURE
// // ============================
// app.put("/api/feature/update/:id", async (req, res) => {
//   try {
//     const { title, description, image, steps } = req.body;

//     const updateData = {
//       title,
//       description,
//     };

//     if (image !== undefined) updateData.image = image;

//     if (Array.isArray(steps)) {
//       updateData.steps = steps.map((s) => ({
//         title: s.title || "",
//         content: s.content || "",
//         image: s.image || null, // <-- Step image support
//       }));
//     }

//     const updated = await Feature.findByIdAndUpdate(
//       req.params.id,
//       updateData,
//       { new: true }
//     );

//     res.json({ message: "Feature updated", feature: updated });
//   } catch (err) {
//     console.log("❌ Update Error:", err);
//     res.status(500).json({ error: err.message });
//   }
// });

// // ============================
// // DELETE FEATURE
// // ============================
// app.delete("/api/feature/delete/:id", async (req, res) => {
//   try {
//     await Feature.findByIdAndDelete(req.params.id);
//     res.json({ message: "Feature deleted" });
//   } catch (err) {
//     console.log("❌ Delete Error:", err);
//     res.status(500).json({ error: err.message });
//   }
// });

// // ----------------------------
// // Run Server
// // ----------------------------
// const PORT = process.env.PORT || 3000;

// app.listen(PORT, () => {
//   console.log(`🚀 Server running on port ${PORT}`);
// });

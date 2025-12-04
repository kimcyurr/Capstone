// routes/readingHistory.js
const express = require("express");
const router = express.Router();
const ReadingHistory = require("../models/ReadingHistory");

// Get reading history for a user
router.get("/user/:userId", async (req, res) => {
  try {
    const histories = await ReadingHistory.find({ userId: req.params.userId })
      .populate("featureId")  // <-- Populates the feature details
      .sort({ createdAt: -1 }); // optional: latest first

    res.json(histories);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Add reading history
router.post("/add", async (req, res) => {
  try {
    const { userId, featureId } = req.body;
    if (!userId || !featureId) return res.status(400).json({ error: "Missing fields" });

    const history = new ReadingHistory({ userId, featureId });
    await history.save();

    res.json({ message: "History added successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get top read modules (for admin dashboard)
// router.get("/top-modules", async (req, res) => {
//   try {
//     const topModules = await ReadingHistory.aggregate([
//       {
//         $group: {
//           _id: "$featureId",       // group by module
//           readCount: { $sum: 1 }   // count reads
//         }
//       },
//       { $sort: { readCount: -1 } }, // sort descending
//       { $limit: 5 }                 // top 5 modules
//     ]);

//     // populate module details
//     const populated = await ReadingHistory.populate(topModules, { path: "_id", select: "name" });

//     // Format data
//     const result = populated.map((m) => ({
//       moduleName: m._id.name,
//       readCount: m.readCount
//     }));

//     res.json(result);
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });


module.exports = router;


// routes/readingHistory.js
// const express = require("express");
// const router = express.Router();
// const ReadingHistory = require("../models/ReadingHistory");
// const Feature = require("../models/Feature"); // <-- make sure this is your module collection

// // -----------------------------
// // Get reading history for a user
// // -----------------------------
// router.get("/user/:userId", async (req, res) => {
//   try {
//     const histories = await ReadingHistory.find({ userId: req.params.userId })
//       .populate("featureId")  // <-- Populates the feature details
//       .sort({ createdAt: -1 }); // latest first

//     res.json(histories);
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });

// // -----------------------------
// // Add reading history
// // -----------------------------
// router.post("/add", async (req, res) => {
//   try {
//     const { userId, featureId } = req.body;
//     if (!userId || !featureId) return res.status(400).json({ error: "Missing fields" });

//     const history = new ReadingHistory({ userId, featureId });
//     await history.save();

//     res.json({ message: "History added successfully" });
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });

// // -----------------------------
// // Get top read modules (for admin dashboard)
// // -----------------------------
// router.get("/top-modules", async (req, res) => {
//   try {
//     const topModules = await ReadingHistory.aggregate([
//       {
//         $group: {
//           _id: "$featureId",       // group by module
//           readCount: { $sum: 1 }   // count reads
//         }
//       },
//       {
//         $lookup: {
//           from: "features",        // collection name of your modules
//           localField: "_id",
//           foreignField: "_id",
//           as: "feature"
//         }
//       },
//       { $unwind: "$feature" },     // convert array to object
//       {
//         $project: {
//           moduleName: "$feature.name",
//           readCount: 1
//         }
//       },
//       { $sort: { readCount: -1 } }, // sort descending
//       { $limit: 5 }                 // top 5 modules
//     ]);

//     res.json(topModules);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: err.message });
//   }
// });

// module.exports = router;

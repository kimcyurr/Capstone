const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

// Replace YOUR_CONNECTION_STRING with your updated string
mongoose.connect(
  //"mongodb+srv://aureakimcyrus15_db_user:StrongPassword123@agsecuredb.qbmb1fp.mongodb.net/agsecuredb?retryWrites=true&w=majority"
  "mongodb+srv://aureakimcyrus15_db_user:<J76Tl8xVx7PN0ydM>@agsecuredb.qbmb1fp.mongodb.net/?appName=agsecuredb"
)
.then(() => console.log("MongoDB Connected"))
.catch(err => console.log(err));

const CropSchema = new mongoose.Schema({
  title: String,
  description: String,
  image: String,
});

const Crop = mongoose.model("Crop", CropSchema);

app.get("/crops", async (req, res) => {
  const crops = await Crop.find();
  res.json(crops);
});

app.post("/crops", async (req, res) => {
  const crop = new Crop(req.body);
  await crop.save();
  res.json({ message: "Crop added", crop });
});

app.delete("/crops/:id", async (req, res) => {
  await Crop.findByIdAndDelete(req.params.id);
  res.json({ message: "Crop deleted" });
});

const PORT = 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

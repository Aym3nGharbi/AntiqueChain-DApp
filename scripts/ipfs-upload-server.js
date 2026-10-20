require("dotenv").config();
const express = require("express");
const multer = require("multer");

const app = express();
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: (_req, file, done) => done(null, ["image/jpeg", "image/png", "image/webp"].includes(file.mimetype))
});

/** Téléverse le fichier vers Pinata, qui le "pin" afin de le conserver sur IPFS. */
app.post("/api/ipfs", upload.single("image"), async (req, res) => {
  if (!process.env.PINATA_JWT) return res.status(503).json({ error: "PINATA_JWT absent : configurez-le dans .env." });
  if (!req.file) return res.status(400).json({ error: "Choisissez une image JPG, PNG ou WebP (5 Mo maximum)." });
  try {
    const form = new FormData();
    form.append("file", new Blob([req.file.buffer], { type: req.file.mimetype }), req.file.originalname);
    form.append("pinataMetadata", JSON.stringify({ name: `antiquechain-${Date.now()}-${req.file.originalname}` }));
    const response = await fetch("https://api.pinata.cloud/pinning/pinFileToIPFS", {
      method: "POST", headers: { Authorization: `Bearer ${process.env.PINATA_JWT}` }, body: form
    });
    const body = await response.json();
    if (!response.ok || !body.IpfsHash) throw new Error(body.error?.details || body.error || "Réponse IPFS invalide");
    res.json({ cid: body.IpfsHash, uri: `ipfs://${body.IpfsHash}` });
  } catch (error) { res.status(502).json({ error: `Téléversement IPFS impossible : ${error.message}` }); }
});
app.use((error, _req, res, _next) => res.status(error.code === "LIMIT_FILE_SIZE" ? 413 : 400).json({ error: error.code === "LIMIT_FILE_SIZE" ? "Image trop volumineuse (maximum 5 Mo)." : "Fichier image invalide." }));
app.listen(8787, "127.0.0.1", () => console.log("Service IPFS prêt : http://127.0.0.1:8787"));

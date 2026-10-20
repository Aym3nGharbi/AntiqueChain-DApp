const fs = require("fs");
const path = require("path");
const objets = require("../data/objets.json");
const output = path.join(__dirname, "../frontend/public/images");

async function main() {
  fs.mkdirSync(output, { recursive: true });
  for (const objet of objets) {
    const response = await fetch(objet.imageUrl);
    if (!response.ok) throw new Error(`Image Met ${objet.metObjectId} inaccessible (${response.status})`);
    const file = path.join(output, `${objet.metObjectId}.jpg`);
    fs.writeFileSync(file, Buffer.from(await response.arrayBuffer()));
    console.log(`Téléchargée : ${objet.metObjectId}.jpg`);
  }
}
main().catch(error => { console.error(error.message); process.exitCode = 1; });

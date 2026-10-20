# Registre d’antiquités sur blockchain

Projet universitaire : un expert certifie une antiquité, puis le contrat Ethereum conserve sa provenance, ses transferts et ses ventes. La blockchain ne prouve pas qu’un objet est authentique : elle rend la certification de l’expert et l’historique des propriétaires infalsifiables.

## Lancer la démonstration

Prérequis : Node.js 18+ et MetaMask.

```bash
npm install
npm run node
# dans un second terminal
npm run deploy
npm run seed
npm run dev
```

Ouvrir l’URL Vite. Le visiteur voit le registre sans wallet. Pour signer, ajoutez dans MetaMask le réseau `Hardhat Local` : RPC `http://127.0.0.1:8545`, chain ID `31337`, symbole `ETH`. Importez les clés affichées par `npm run node` : elles sont publiques et réservées au test. Compte 0 = expert ; comptes 1 à 3 = propriétaires/acheteurs.

`npm run images` télécharge les images Met en local ; la galerie utilise sinon l’URL officielle distante. `npm test` exécute les tests.

## Démonstration

1. Visiteur : ouvrir une fiche et sa frise d’événements.
2. Expert (compte 0) : connecter MetaMask, enregistrer un objet.
3. Propriétaire : transférer ou vendre son objet.
4. Acheteur : acheter au prix exact ; la propriété et l’historique changent.

## Architecture

```text
Utilisateur → Interface Vite (ethers.js) → MetaMask (signature)
                                      → Smart contract Solidity → Blockchain Hardhat
```

Les œuvres et métadonnées proviennent de The Metropolitan Museum of Art, Open Access (domaine public), legs d’Ada Small Moore, 1955. Démonstration pédagogique : propriétaires et expert simulés.

## Limites et évolutions

L’expert demeure le garant hors chaîne de l’examen physique. Évolutions : plusieurs experts, certificats hachés, images/IPFS et NFT ERC-721. Aucune clé privée n’est dans ce dépôt.

## Images et IPFS

Les six œuvres initiales sont téléchargées depuis les URLs officielles du Met avec `npm run images` dans `frontend/public/images/`; elles sont ainsi visibles même si une URL distante est indisponible. Les objets déjà inscrits conservent leurs URLs Met immuables : elles ne peuvent pas être remplacées sans falsifier leur enregistrement.

Pour une nouvelle antiquité, l’expert choisit un JPG, PNG ou WebP (5 Mo max). Le navigateur montre un aperçu, puis envoie le fichier au serveur local IPFS. Ce serveur conserve le secret Pinata côté machine, épingle le fichier, reçoit son CID et renvoie `ipfs://CID`. Cette chaîne est enregistrée dans le champ `imageUrl` du contrat existant ; aucune image volumineuse n’est mise sur Ethereum. Le frontend transforme ensuite `ipfs://CID` en URL de passerelle et l’affiche.

Configuration : créez un compte Pinata, générez un JWT avec droit de téléversement, copiez `.env.example` vers `.env`, puis renseignez `PINATA_JWT`. Dans deux terminaux :

```bash
npm run ipfs-server
npm run dev
```

Le CID est une empreinte adressant le contenu : changer un seul octet de l’image produit un CID différent. Sans `PINATA_JWT`, le serveur répond explicitement qu’il manque la configuration et aucune transaction n’est proposée. Les CIDs des six images Met ne sont pas ajoutés automatiquement : cela nécessite votre compte de pinning ; leurs copies locales et URLs officielles restent utilisées pour préserver les données déjà déployées.

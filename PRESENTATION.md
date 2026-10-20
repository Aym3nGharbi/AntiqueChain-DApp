# Présentation orale — 9 slides

1. **Problème** — Fraude et provenance difficile à prouver. *Dire : un historique papier est modifiable et dispersé.*
2. **Solution** — Registre public d’objets certifiés. *Dire : le contrat fixe qui peut écrire et garde les traces.*
3. **Concepts** — Blocs, hash, immuabilité, EVM, gas. *Dire : chaque transaction signée devient une trace coûteuse à altérer.*
4. **Rôles** — Expert, propriétaire, acheteur, visiteur. *Dire : seul l’expert enregistre, le propriétaire agit sur son objet.*
5. **Architecture** — Vite/ethers → MetaMask → contrat. *Dire : MetaMask signe, ethers dialogue, Solidity applique les règles.*
6. **Contrat** — `Antiquite`, `Evenement`, historique append-only. *Dire : ventes et transferts ne remplacent jamais les événements passés.*
7. **Démo** — Consulter, certifier, transférer, vendre. *Dire : montrer la frise avant et après achat.*
8. **Sécurité / limites** — `require`, accès, checks-effects-interactions. *Dire : la chaîne protège l’enregistrement, pas l’expertise physique.*
9. **Conclusion** — Transparence et traçabilité. *Dire : une base solide pour une solution patrimoniale plus complète.*

## Questions probables

1. **Où est l’authenticité ?** Hors chaîne : l’expert examine l’objet ; la chaîne fixe sa certification.
2. **Pourquoi pas une base de données ?** Elle dépend d’un administrateur ; la chaîne rend l’historique partagé et difficile à modifier.
3. **C’est quoi le gas ?** Le coût payé pour exécuter une transaction Ethereum.
4. **Qui paie le gas ?** La personne qui déclenche l’écriture : expert, propriétaire ou acheteur.
5. **Si l’expert perd sa clé ?** Cette version ne permet pas de récupération ; une évolution ajouterait une gouvernance/multisig.
6. **Pourquoi pas l’image sur chaîne ?** C’est trop coûteux ; on stocke une URL, idéalement IPFS ensuite.
7. **Comment le contrat connaît l’expert ?** `msg.sender`, issu de la signature de la transaction.
8. **Bitcoin vs Ethereum ?** Bitcoin cible surtout la monnaie ; Ethereum exécute des smart contracts.
9. **Qu’est-ce que l’EVM ?** La machine virtuelle qui exécute le bytecode Solidity sur les nœuds Ethereum.
10. **Peut-on modifier le contrat ?** Non après déploiement ; on redéploie une nouvelle version ou prévoit un mécanisme dès le départ.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/** @title RegistreAntiquites - registre pédagogique, append-only, d'antiquités certifiées. */
contract RegistreAntiquites {
    address public expert;
    struct Antiquite { uint256 id; string nom; string origine; string epoque; string description; string imageUrl; string sourceUrl; address proprietaire; address certifiePar; uint256 dateEnregistrement; bool enVente; uint256 prix; }
    struct Evenement { address de; address vers; uint256 date; string typeEvenement; uint256 prix; }
    mapping(uint256 => Antiquite) private objets;
    mapping(uint256 => Evenement[]) private historique;
    uint256 public nombreObjets;

    event ObjetEnregistre(uint256 indexed id, address indexed proprietaire, string nom);
    event ProprieteTransferee(uint256 indexed id, address indexed de, address indexed vers);
    event MiseEnVente(uint256 indexed id, uint256 prix);
    event RetraitDeVente(uint256 indexed id);
    event ObjetVendu(uint256 indexed id, address indexed vendeur, address indexed acheteur, uint256 prix);

    modifier onlyExpert() { require(msg.sender == expert, "Seul l'expert peut enregistrer un objet"); _; }
    modifier onlyProprietaire(uint256 id) { require(id > 0 && id <= nombreObjets, "Objet inexistant"); require(msg.sender == objets[id].proprietaire, "Seul le proprietaire peut effectuer cette action"); _; }

    /// @notice Le déployeur devient l'autorité de certification.
    constructor() { expert = msg.sender; }

    /// @notice Certifie un objet; uniquement l'expert, nom et propriétaire non vides.
    function enregistrerObjet(string calldata nom, string calldata origine, string calldata epoque, string calldata description, string calldata imageUrl, string calldata sourceUrl, address premierProprietaire) external onlyExpert {
        require(bytes(nom).length > 0, "Le nom est obligatoire"); require(premierProprietaire != address(0), "Proprietaire invalide");
        uint256 id = ++nombreObjets;
        objets[id] = Antiquite(id, nom, origine, epoque, description, imageUrl, sourceUrl, premierProprietaire, msg.sender, block.timestamp, false, 0);
        historique[id].push(Evenement(msg.sender, premierProprietaire, block.timestamp, "CERTIFICATION", 0));
        emit ObjetEnregistre(id, premierProprietaire, nom);
    }
    /// @notice Transfère la propriété; uniquement le propriétaire actuel vers une autre adresse.
    function transfererPropriete(uint256 id, address nouveauProprietaire) external onlyProprietaire(id) {
        require(nouveauProprietaire != address(0), "Proprietaire invalide"); require(nouveauProprietaire != msg.sender, "Transfert vers soi-meme interdit");
        objets[id].proprietaire = nouveauProprietaire; objets[id].enVente = false; objets[id].prix = 0;
        historique[id].push(Evenement(msg.sender, nouveauProprietaire, block.timestamp, "TRANSFERT", 0)); emit ProprieteTransferee(id, msg.sender, nouveauProprietaire);
    }
    /// @notice Met en vente; uniquement le propriétaire, prix strictement positif.
    function mettreEnVente(uint256 id, uint256 prix) external onlyProprietaire(id) { require(prix > 0, "Le prix doit etre superieur a zero"); objets[id].enVente = true; objets[id].prix = prix; emit MiseEnVente(id, prix); }
    /// @notice Retire une annonce; uniquement le propriétaire si l'objet est en vente.
    function retirerDeLaVente(uint256 id) external onlyProprietaire(id) { require(objets[id].enVente, "Objet non en vente"); objets[id].enVente = false; objets[id].prix = 0; emit RetraitDeVente(id); }
    /// @notice Achète au prix exact; état changé avant paiement pour prévenir la réentrance.
    function acheter(uint256 id) external payable {
        require(id > 0 && id <= nombreObjets, "Objet inexistant"); Antiquite storage objet = objets[id]; require(objet.enVente, "Objet non en vente"); require(msg.value == objet.prix, "Montant incorrect"); require(msg.sender != objet.proprietaire, "Le proprietaire ne peut pas acheter son objet");
        address vendeur = objet.proprietaire; uint256 prix = objet.prix;
        objet.proprietaire = msg.sender; objet.enVente = false; objet.prix = 0;
        historique[id].push(Evenement(vendeur, msg.sender, block.timestamp, "VENTE", prix));
        (bool success,) = payable(vendeur).call{value: prix}(""); require(success, "Paiement au vendeur echoue"); emit ObjetVendu(id, vendeur, msg.sender, prix);
    }
    /// @notice Consultation publique gratuite d'un objet existant.
    function consulterObjet(uint256 id) external view returns (Antiquite memory) { require(id > 0 && id <= nombreObjets, "Objet inexistant"); return objets[id]; }
    /// @notice Historique immuable, seulement enrichi par append.
    function consulterHistorique(uint256 id) external view returns (Evenement[] memory) { require(id > 0 && id <= nombreObjets, "Objet inexistant"); return historique[id]; }
    /// @notice Liste publique de tous les objets enregistrés.
    function listerObjets() external view returns (Antiquite[] memory resultat) { resultat = new Antiquite[](nombreObjets); for(uint256 i=1;i<=nombreObjets;i++) resultat[i-1]=objets[i]; }
}

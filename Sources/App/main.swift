import Foundation

//Structures :

struct Livre {
    var titre: String
    var auteur: String
    var codeISBN: String
    var disponible: Bool = true
}

struct Utilisateur {
    var nom: String
    var id: String
    var livresEmpruntes: [String] = []

    mutating func emprunter(isbn: String) {
        livresEmpruntes.append(isbn)
    }

    mutating func retourner(isbn: String) {
        if let index = livresEmpruntes.firstIndex(of: isbn) {
            livresEmpruntes.remove(at: index)
        }
    }
}

struct Bibliotheque {

    var livres: [String: Livre]
    var utilisateurs: [String: Utilisateur]

    //Ajout des livres :
    mutating func ajouterLivre(_ livre: Livre) {

        let isbn = livre.codeISBN.trimmingCharacters(in: .whitespacesAndNewlines)

        if livres[isbn] != nil {
            print("❌ Le livre existe déjà !")
        } else {
            var nouveauLivre = livre
            nouveauLivre.codeISBN = isbn
            livres[isbn] = nouveauLivre
            print("✅ Le livre est bien ajouté !")
        }
    }

    //Ajout des utilisateurs :
    mutating func ajouterUtilisateur(_ utilisateur: Utilisateur) {

        let id = utilisateur.id.trimmingCharacters(in: .whitespacesAndNewlines)

        if utilisateurs[id] != nil {
            print("❌ L'utilisateur existe déjà !")
        } else {
            var nouvelUtilisateur = utilisateur
            nouvelUtilisateur.id = id
            utilisateurs[id] = nouvelUtilisateur
            print("✅ L'utilisateur est bien ajouté !")
        }
    }

    //emprunter un livre :
    mutating func emprunterLivre(isbn: String, userId: String) {

        let cleanedISBN = isbn.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedID = userId.trimmingCharacters(in: .whitespacesAndNewlines)

        guard var livre = livres[cleanedISBN] else {
            print("❌ Le livre est introuvable !")
            return
        }

        guard var utilisateur = utilisateurs[cleanedID] else {
            print("❌ L'utilisateur est introuvable !")
            return
        }

        if !livre.disponible {
            print("❌ Le livre est déjà emprunté !")
            return
        }

        if utilisateur.livresEmpruntes.contains(cleanedISBN) {
            print("❌ L'utilisateur a déjà emprunté ce livre !")
            return
        }

        livre.disponible = false
        utilisateur.emprunter(isbn: cleanedISBN)

        livres[cleanedISBN] = livre
        utilisateurs[cleanedID] = utilisateur

        print("✅ Le livre est bien emprunté !")
    }

    //retourner un livre :
    mutating func retournerLivre(isbn: String, userId: String) {

        let cleanedISBN = isbn.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedID = userId.trimmingCharacters(in: .whitespacesAndNewlines)

        guard var livre = livres[cleanedISBN] else {
            print("❌ Le livre est introuvable !")
            return
        }

        guard var utilisateur = utilisateurs[cleanedID] else {
            print("❌ L'utilisateur est introuvable !")
            return
        }

        if !utilisateur.livresEmpruntes.contains(cleanedISBN) {
            print("❌ Ce livre n'a pas été emprunté par cet utilisateur !")
            return
        }

        livre.disponible = true
        utilisateur.retourner(isbn: cleanedISBN)

        livres[cleanedISBN] = livre
        utilisateurs[cleanedID] = utilisateur

        print("✅ Le livre est bien retourné !")
    }

    //affichage des livres disponibles :
    func afficherLivres() {

        let disponibles = livres.values.filter { $0.disponible }

        if disponibles.isEmpty {
            print("📚 Aucun livre n'est disponible !")
            return
        }

        for livre in disponibles {
            print("📖 \(livre.titre) - \(livre.auteur) (ISBN: \(livre.codeISBN))")
        }
    }

    //les livres d'un utilisateur :
    func afficherLivresUtilisateur(userId: String) {

        let cleanedID = userId.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let utilisateur = utilisateurs[cleanedID] else {
            print("❌ L'utilisateur est introuvable !")
            return
        }

        print("📖 Les livres empruntés par \(utilisateur.nom) sont :")

        if utilisateur.livresEmpruntes.isEmpty {
            print("❌ Aucun livre n'est emprunté !")
            return
        }

        for isbn in utilisateur.livresEmpruntes {
            if let livre = livres[isbn] {
                print("📚 - \(livre.titre)")
            }
        }
    }
}

//le menu :

func lancerProgramme() {

    var bibliotheque = Bibliotheque(

        livres: [
            "9780747532699": Livre(
                titre: "Harry Potter and the philosopher's stone",
                auteur: "J.K Rowling",
                codeISBN: "9780747532699"
            ),
            "9782070584626": Livre(
                titre: "Harry Potter and the order of the phoenix",
                auteur: "J.K Rowling",
                codeISBN: "9782070584626"
            ),
        ],

        utilisateurs: [
            "U1": Utilisateur(nom: "Alice", id: "U1"),
            "U2": Utilisateur(nom: "Bob", id: "U2"),
        ]
    )

    var continuer = true

    func afficherMenu() {
        print(
            """

            ============= 📋 MON MENU 📋 =============
            1. 📚 Ajouter un livre
            2. 👤 Ajouter un utilisateur
            3. 📖 Afficher les livres disponibles
            4. 📤 Emprunter un livre
            5. 📥 Retourner un livre
            6. 👁️ Afficher les livres emprunté par un utilisateur
            7. 🚪 Quitter le menu !
            =========================================
            """)
    }

    while continuer {

        afficherMenu()

        let choix = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        switch choix {

        case "1":
            print("📚 Titre du livre :")
            let titre = readLine() ?? ""

            print("✍️ Auteur du livre :")
            let auteur = readLine() ?? ""

            print("🔢 CODE ISBN :")
            let isbn = readLine() ?? ""

            bibliotheque.ajouterLivre(
                Livre(titre: titre, auteur: auteur, codeISBN: isbn)
            )

        case "2":
            print("👤 Votre nom :")
            let nom = readLine() ?? ""

            print("🆔 Votre ID :")
            let id = readLine() ?? ""

            bibliotheque.ajouterUtilisateur(
                Utilisateur(nom: nom, id: id)
            )

        case "3":
            bibliotheque.afficherLivres()

        case "4":
            print("🔍 ISBN du livre :")
            let isbn = readLine() ?? ""

            print("🆔 ID de l'utilisateur :")
            let id = readLine() ?? ""

            bibliotheque.emprunterLivre(isbn: isbn, userId: id)

        case "5":
            print("🔍 ISBN du livre :")
            let isbn = readLine() ?? ""

            print("🆔 ID de l'utilisateur :")
            let id = readLine() ?? ""

            bibliotheque.retournerLivre(isbn: isbn, userId: id)

        case "6":
            print("🆔 ID de l'utilisateur :")
            let id = readLine() ?? ""

            bibliotheque.afficherLivresUtilisateur(userId: id)

        case "7":
            continuer = false
            print("👋 Au revoir !")

        default:
            print("⚠️ Votre choix est invalide !")
        }
    }
}

//lancer le programme:

lancerProgramme()

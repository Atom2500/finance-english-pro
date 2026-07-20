# Finance English Pro

Eine Flutter-App mit klarem Quizlet-Prinzip für professionelles Englisch in Accounting, Group Accounting, Finance, Audit, Controlling und Procurement.

## Enthalten

- **1029 hochwertige Lernkarten**
- Fachbegriffe, typische Kollokationen, aktive Übersetzungen und berufliche Reaktionen
- Bewertungen: **Nicht gewusst / Unsicher / Gewusst**
- zeitgesteuerte Wiederholungen
- Filter nach Lernpfad, Fälligkeit, neuen Karten, schwierigen Karten und Favoriten
- Suche und Kartenbibliothek
- Fortschritt, Lerntage und Lernserie
- 15 ausführliche Gesprächsprompts für echte KI-Sprachgespräche
- keine Browserstimme und keine zufällig zusammengewürfelten Quizantworten

## Kostenlos auf dem iPhone verwenden

Der kostenlose Weg ist die Web-App über GitHub Pages. Du brauchst keinen Apple-Developer-Account.

1. Kostenloses GitHub-Konto erstellen.
2. Neues **öffentliches** Repository anlegen.
3. Den Inhalt dieses Ordners hochladen und auf den Branch `main` speichern.
4. In GitHub unter **Settings → Pages → Source** den Eintrag **GitHub Actions** wählen.
5. Der Workflow `Deploy Flutter Web to GitHub Pages` baut und veröffentlicht die App automatisch.
6. Die angezeigte Pages-Adresse in Safari öffnen.
7. In Safari **Teilen → Zum Home-Bildschirm** wählen.

Der Lernfortschritt wird lokal auf dem jeweiligen Gerät gespeichert.

## Android-APK kostenlos bauen

Im Repository unter **Actions** den Workflow `Build Android APK` manuell starten. Nach Abschluss kann die APK als Workflow-Artefakt heruntergeladen werden.

## Lokal auf Windows entwickeln

1. Flutter kostenlos installieren.
2. `setup_windows.bat` ausführen.

Alternativ:

```bash
flutter create . --platforms=android,web --project-name=finance_english_pro
flutter pub get
flutter run
```

## Inhalte bearbeiten

Die Karten liegen in:

- `assets/data/cards.json`
- `assets/data/learning_cards.csv`

Die Gesprächsprompts liegen in:

- `assets/data/conversation_prompts.json`

## Technischer Hinweis

Eine dauerhaft nativ signierte iPhone-App benötigt Apples iOS-Signierungsprozess. Die über GitHub Pages installierte Web-App ist deshalb der vollständig kostenlose iPhone-Weg. Android und Web können ohne kostenpflichtigen Entwickleraccount gebaut werden.

@echo off
where flutter >nul 2>nul
if %errorlevel% neq 0 (
  echo Flutter wurde nicht gefunden. Installiere zuerst Flutter und fuege es zum PATH hinzu.
  pause
  exit /b 1
)
flutter create . --platforms=android,web --project-name=finance_english_pro
flutter pub get
flutter run
pause

from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
import sys
import os

# Activer le debug QML (optionnel)
os.environ["QML_DEBUG"] = "1"

# Créer l'application Qt
app = QApplication(sys.argv)

# Créer le moteur QML
engine = QQmlApplicationEngine()

# Charger le fichier QML
qml_file = os.path.join(os.path.dirname(__file__), 'IndicatorControls.qml')
engine.load(qml_file)

# Vérifier si le fichier QML a été chargé
if not engine.rootObjects():
    sys.exit("Erreur : impossible de charger main.qml")

# Lancer la boucle principale
sys.exit(app.exec())

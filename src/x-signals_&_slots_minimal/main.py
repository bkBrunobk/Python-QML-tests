#!/usr/bin/env python3
"""
Exemple minimal et commenté (français) démontrant les Signaux et Slots
entre Python (PySide6) et QML.

But pédagogique : garder le code court et lisible.
"""

import os
import sys

try:
    from PySide6.QtCore import QObject, Signal, Slot, QUrl
    from PySide6.QtGui import QGuiApplication
    from PySide6.QtQml import QQmlApplicationEngine
except Exception:
    print("PySide6 est requis. Installez-le : pip install -r requirements.txt")
    raise


class Backend(QObject):
    """Objet Python exposé à QML.

    - messageToQml : Signal(str) envoyé vers QML
    - send_to_python(text) : Slot appelé depuis QML (asynchrone)
    - request_from_python() : Slot synchrone (retourne une chaîne)
    - ping() : Slot simple qui renvoie un message asynchrone
    """

    messageToQml = Signal(str)

    @Slot(str)
    def send_to_python(self, text):
        """Slot asynchrone : reçoit un message depuis QML.
        
        Args:
            text (str): Message envoyé par QML
            
        Behavior:
            - Valide le texte (non-vide, max 500 chars)
            - Log en console
            - Émet messageToQml avec confirmation ou message d'erreur
        """
        try:
            # Validation basique
            if not isinstance(text, str):
                raise TypeError(f"Attendu str, reçu {type(text).__name__}")
            if not text or text.isspace():
                raise ValueError("Le texte ne peut pas être vide")
            if len(text) > 500:
                raise ValueError("Le texte dépasse 500 caractères")
            
            # Log et confirmation
            print(f"[Python] Reçu : {text}")
            self.messageToQml.emit(f"✓ Python a reçu : {text}")
            
        except (TypeError, ValueError) as e:
            error_msg = f"⚠ Erreur : {str(e)}"
            print(f"[Python] {error_msg}")
            self.messageToQml.emit(error_msg)

    @Slot(result=str)
    def request_from_python(self):
        """Slot synchrone : retourne une réponse immédiate à QML.
        
        Returns:
            str: Réponse synchrone. Attention : bloque l'UI si lent.
            
        Note:
            Pour opérations longues, préférer send_to_python() + messageToQml signal.
        """
        return "Réponse synchrone de Python"

    @Slot()
    def ping(self):
        """Slot asynchrone : émet un signal de pong vers QML.
        
        Behavior:
            - N'a pas de valeur de retour (undefined en QML).
            - Utilise le signal messageToQml pour notifier QML.
            - Démontre le pattern asynchrone pur.
        """
        self.messageToQml.emit("Pong (depuis Python)")


def main(argv):
    app = QGuiApplication(argv)
    engine = QQmlApplicationEngine()

    backend = Backend()
    # Exposer l'objet Python à QML sous le nom 'backend'
    engine.rootContext().setContextProperty('backend', backend)

    # Charger le QML (chemin absolu)
    qml_file = os.path.join(os.path.dirname(__file__), 'main.qml')
    engine.load(QUrl.fromLocalFile(qml_file))

    if not engine.rootObjects():
        print('Échec du chargement QML')
        return -1

    # Envoyer un message d'initialisation (optionnel, pédagogique)
    try:
        backend.messageToQml.emit('Python prêt')
    except Exception:
        pass

    return app.exec()


if __name__ == '__main__':
    sys.exit(main(sys.argv))

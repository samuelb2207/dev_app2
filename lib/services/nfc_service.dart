import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';

// Service pour gérer l'interaction avec le matériel NFC.
class NfcService {
  // !! ACTION REQUISE !! Remplacez la valeur ci-dessous par l'UID de votre propre badge.
  static const String _authorizedUid = 'REMPLACEZ_MOI_PAR_VOTRE_UID';

  ValueNotifier<bool> isTagAuthorized = ValueNotifier(false);

  Future<bool> isNfcAvailable() async {
    return NfcManager.instance.isAvailable();
  }

  void startNfcSession({required Function onTagScanned, required Function(String) onError}) {
    NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
      },
      onDiscovered: (NfcTag tag) async {
        try {
          final tagData = tag.data as Map;
          final nfcAData = tagData['nfca'];

          if (nfcAData == null || nfcAData is! Map) {
            onError("Tag non compatible (données NFCA non trouvées).");
            await NfcManager.instance.stopSession();
            return;
          }

          final identifier = nfcAData['identifier'];

          if (identifier == null) {
            onError("Impossible de lire l'UID du tag.");
            await NfcManager.instance.stopSession();
            return;
          }

          final String uid = identifier.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();

          debugPrint('UID du tag scanné: $uid');

          if (uid == _authorizedUid) {
            isTagAuthorized.value = true;
            onTagScanned();
          } else {
            isTagAuthorized.value = false;
            onError("Ce badge n'est pas un Pass Parieur valide.");
          }

          await NfcManager.instance.stopSession();

        } catch (e) {
          isTagAuthorized.value = false;
          onError("Erreur lors de la lecture du tag: ${e.toString()}");
          await NfcManager.instance.stopSession();
        }
      },
    );
  }

  void stopNfcSession() {
      NfcManager.instance.stopSession();
  }
}

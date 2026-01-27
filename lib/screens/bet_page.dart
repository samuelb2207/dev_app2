import 'package:esme2526/models/bet.dart';
import 'package:esme2526/services/nfc_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ... (Le widget PulsatingCircleAnimation reste le même)
class PulsatingCircleAnimation extends StatefulWidget {
  final Widget child;
  const PulsatingCircleAnimation({Key? key, required this.child}) : super(key: key);
  @override
  _PulsatingCircleAnimationState createState() => _PulsatingCircleAnimationState();
}

class _PulsatingCircleAnimationState extends State<PulsatingCircleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: Tween<double>(begin: 0.7, end: 1.0).animate(_animationController), child: widget.child);
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class BetPage extends StatefulWidget {
  final Bet bet;

  const BetPage({Key? key, required this.bet}) : super(key: key);

  @override
  _BetPageState createState() => _BetPageState();
}

class _BetPageState extends State<BetPage> {
  final NfcService _nfcService = NfcService();
  late TextEditingController _textEditingController;
  bool _isNfcAuthorized = false;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: "100");
  }

  void _startNfcScan() {
    setState(() => _isScanning = true);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scan en cours... Approchez votre badge.')));
    _nfcService.startNfcSession(
      onTagScanned: () {
        if (!mounted) return;
        setState(() {
          _isNfcAuthorized = true;
          _isScanning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pass Parieur validé !'), backgroundColor: Colors.green));
      },
      onError: (message) {
        if (!mounted) return;
        setState(() => _isScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
      },
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    if (_isScanning) {
      _nfcService.stopNfcSession();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bet.title),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // NOUVEAU : La Bet Card avec fond d'image
            _buildBetCard(context),
            const SizedBox(height: 30),
            if (_isNfcAuthorized)
              _buildBettingSection()
            else
              _buildNfcLockSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBetCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 8.0,
      child: Stack(
        children: [
          // Fond d'image
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.pexels.com/photos/270085/pexels-photo-270085.jpeg'), // Image de stade
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay sombre
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.8), Colors.transparent, Colors.black.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Contenu texte et bouton
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.bet.description, // Texte dynamique
                          style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Text(
                        '${widget.bet.startTime.day}/${widget.bet.startTime.month}/${widget.bet.startTime.year}',
                        style: GoogleFonts.roboto(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () { /* Pour l'instant, le clic est géré sur la page d'accueil */ },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Cote : ${widget.bet.odds.toStringAsFixed(2)}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNfcLockSection() {
    // ... (Cette fonction ne change pas)
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.nfc, size: 80, color: Colors.blueAccent),
          const SizedBox(height: 20),
          const Text('Authentification requise', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          PulsatingCircleAnimation(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.nfc_outlined),
              label: const Text('Scanner votre badge pour parier'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)), padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
              onPressed: _isScanning ? null : _startNfcScan,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBettingSection() {
    // ... (Cette fonction ne change pas)
    return Column(
      children: [
          TextField(
            controller: _textEditingController,
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Votre mise', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.monetization_on_outlined),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
            onPressed: () { /* TODO: Logique de confirmation du pari après mise */ },
            child: const Text('Placer le Pari', style: TextStyle(fontSize: 18)),
          ),
      ],
    );
  }
}

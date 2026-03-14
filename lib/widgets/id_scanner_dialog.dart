import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../theme.dart';

class IdScannerDialog extends StatefulWidget {
  const IdScannerDialog({super.key});

  @override
  State<IdScannerDialog> createState() => _IdScannerDialogState();
}

class _IdScannerDialogState extends State<IdScannerDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;

  bool _isProcessing = false;
  bool _hasImage = false;
  Uint8List? _imageBytes;
  String _statusText = 'Choose how to scan your ID';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scannerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 1600,
      );

      if (picked == null || !mounted) return;

      final bytes = await picked.readAsBytes();

      setState(() {
        _imageBytes = bytes;
        _hasImage = true;
        _statusText = 'ID uploaded! Tap "Scan & Extract" to proceed';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusText = 'Could not open picker. Try another option.';
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'heic'],
        withData: true,
      );

      if (result == null || result.files.isEmpty || !mounted) return;

      final file = result.files.first;
      final bytes = file.bytes;

      if (bytes == null) return;

      setState(() {
        _hasImage = true;
        _imageBytes = bytes;
        _statusText = 'File selected! Tap "Scan & Extract" to proceed.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusText = 'Could not access files. Try another option.';
      });
    }
  }

  Map<String, String> _parseExtractedText(String text) {
    String firstName = '';
    String middleName = '';
    String lastName = '';
    String suffix = '';
    String email = '';

    // Normalize — collapse tabs/multiple spaces
    final normalized = text.replaceAll(RegExp(r'[ \t]+'), ' ').trim();
    final lines = normalized
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final upperText = normalized.toUpperCase();

    // 1. EMAIL
    final emailMatch = RegExp(
      r'[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}',
    ).firstMatch(normalized);
    if (emailMatch != null) email = emailMatch.group(0)!.toLowerCase();

    // 2. LABEL-BASED FALLBACK PARSER
    lastName = _findLabelValue(lines, normalized, [
      'APELYIDO',
      'LAST NAME',
      'LASTNAME',
      'SURNAME',
      'FAMILY NAME',
    ]);
    firstName = _findLabelValue(lines, normalized, [
      'MGA PANGALAN',
      'GIVEN NAMES',
      'GIVEN NAME',
      'FIRST NAME',
      'FIRSTNAME',
      'PANGALAN',
    ]);
    middleName = _findLabelValue(lines, normalized, [
      'GITNANG APELYIDO',
      'MIDDLE NAME',
      'MIDDLE INITIAL',
    ]);
    suffix = _findLabelValue(lines, normalized, ['SUFFIX', 'NAME SUFFIX']);

    // 3. MRZ ZONE (Passport machine-readable lines like PHLDELACRUZ<<JUAN<REYES)
    if (lastName.isEmpty && firstName.isEmpty) {
      final m = RegExp(
        r'P[A-Z]{3}([A-Z]+)<<([A-Z]+)<([A-Z]*)',
      ).firstMatch(upperText);
      if (m != null) {
        lastName = m.group(1) ?? '';
        firstName = m.group(2) ?? '';
        middleName = m.group(3) ?? '';
      }
    }

    // 4. CLEAN UP junk label words that leached into values
    final junk = RegExp(
      r'\b(NAME|LAST|FIRST|GIVEN|MIDDLE|SURNAME|SUFFIX|MGA|PANGALAN|APELYIDO|GITNANG)\b',
      caseSensitive: false,
    );
    lastName = lastName.replaceAll(junk, '').trim();
    firstName = firstName.replaceAll(junk, '').trim();
    middleName = middleName.replaceAll(junk, '').trim();

    return {
      'firstName': _titleCase(firstName),
      'middleName': _titleCase(middleName),
      'lastName': _titleCase(lastName),
      'suffix': suffix.trim(),
      'email': email,
    };
  }

  String _titleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .toLowerCase()
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  String _findLabelValue(
    List<String> lines,
    String normalized,
    List<String> labels,
  ) {
    // 1. Apelyido/Last Name
    if (labels.contains('LAST NAME') || labels.contains('APELYIDO')) {
      final match = RegExp(
        r'Apelyido/Last Name\s+([A-Z\s\-\.]+)',
        caseSensitive: false,
      ).firstMatch(normalized);
      if (match != null) return match.group(1)!.trim();

      for (int i = 0; i < lines.length; i++) {
        if (lines[i].toUpperCase().contains('LAST NAME') &&
            i + 1 < lines.length) {
          return lines[i + 1].trim();
        }
      }
    }

    // 2. Mga Pangalan/Given Names
    // The OCR output looked exactly like: "MA Pangalan/Given Names\nBALIS& Apeiyido/Middle Name"
    if (labels.contains('GIVEN NAMES') || labels.contains('MGA PANGALAN')) {
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].toUpperCase().contains('GIVEN NAMES') &&
            i + 1 < lines.length) {
          String val = lines[i + 1].trim();
          // The next line often merges with the middle name label, so split and take the first part
          val = val
              .split(RegExp(r'&|Apeiyido|Middle|/Middle', caseSensitive: false))
              .first;
          return val.trim();
        }
      }
    }

    // 3. Gitnang Apelyido/Middle Name
    // The OCR output looked exactly like: "BALIS& Apeiyido/Middle Name\nMAtan/Sex"
    if (labels.contains('MIDDLE NAME') || labels.contains('GITNANG APELYIDO')) {
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].toUpperCase().contains('MIDDLE NAME') &&
            i + 1 < lines.length) {
          String val = lines[i + 1].trim();
          // The next line often merges with the sex/date label, so split and take the first part
          val = val
              .split(RegExp(r'/Sex|Sex|BECEM|Place|Date', caseSensitive: false))
              .first;
          return val.trim();
        }
      }
    }

    return '';
  }

  void _processImage() async {
    if (_imageBytes == null) return;
    if (!mounted) return;

    setState(() {
      _isProcessing = true;
      _statusText = 'Uploading to OCR engine...';
    });

    try {
      // Using Didit Identity Verification OCR API
      final uri = Uri.parse(
        'https://verification.didit.me/v3/id-verification/',
      );

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] =
            'Bearer YOUR_DIDIT_API_KEY' // Replace with your actual Didit token
        ..files.add(
          http.MultipartFile.fromBytes(
            'document', // The key required by Didit's API for the image file
            _imageBytes!,
            filename: 'id_scan.jpg',
          ),
        );

      if (!mounted) return;
      setState(() => _statusText = 'Scanning ID with Didit...');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint('Didit Response: ${response.body}');

        // Try mapping against standard Didit JSON format
        final docText = data['text'] ?? data['document'] ?? data;

        // If it returns raw text, we reuse our robust parser
        if (docText is String && docText.isNotEmpty) {
          setState(() => _statusText = 'Analyzing ID details...');
          final result = _parseExtractedText(docText);
          Navigator.of(context).pop(result);
          return;
        }

        // If Didit natively parsed the structured document fields for us (which ID verifiers usually do)
        final result = {
          'firstName': _titleCase(
            (docText['first_name'] ??
                    docText['firstName'] ??
                    docText['given_names'] ??
                    '')
                .toString()
                .trim(),
          ),
          'middleName': _titleCase(
            (docText['middle_name'] ?? docText['middleName'] ?? '')
                .toString()
                .trim(),
          ),
          'lastName': _titleCase(
            (docText['last_name'] ??
                    docText['lastName'] ??
                    docText['surname'] ??
                    '')
                .toString()
                .trim(),
          ),
          'suffix': _titleCase((docText['suffix'] ?? '').toString().trim()),
          'email': '',
        };

        if (result['firstName']!.isEmpty && result['lastName']!.isEmpty) {
          setState(() {
            _isProcessing = false;
            _statusText = 'No text found. Try a clearer, brighter image.';
          });
          return;
        }

        setState(() => _statusText = 'Analyzing ID details...');
        await Future.delayed(const Duration(milliseconds: 400));

        if (!mounted) return;
        Navigator.of(context).pop(result);
      } else {
        setState(() {
          _isProcessing = false;
          _statusText = 'Didit service error. Check your API key or internet.';
        });
        debugPrint('Didit error: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _statusText = 'Network error: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.document_scanner_rounded,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Digital ID Scanner',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.label,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppTheme.labelSecondary,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _statusText,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.labelSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Preview Area
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: _isProcessing
                  ? _buildProcessingView()
                  : _hasImage && _imageBytes != null
                  ? _buildImagePreview()
                  : _buildEmptyFrame(),
            ),

            const SizedBox(height: 20),

            if (_isProcessing) ...[
              const SizedBox(height: 8),
            ] else if (_hasImage) ...[
              ElevatedButton.icon(
                onPressed: _processImage,
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text('Scan & Extract Info'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => setState(() {
                  _hasImage = false;
                  _imageBytes = null;
                  _statusText = 'Choose how to scan your ID';
                }),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Choose Different Image'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.labelSecondary,
                  side: BorderSide(color: AppTheme.separator),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_rounded, size: 18),
                label: const Text('Take Photo of ID'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_rounded, size: 18),
                label: const Text('Upload ID from Gallery'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  side: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.folder_open_rounded, size: 18),
                label: const Text('Browse File Manager'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F5132),
                  side: const BorderSide(color: Color(0xFFBBDFCA)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppTheme.labelSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFrame() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.credit_card_rounded,
          color: Colors.white.withOpacity(0.2),
          size: 56,
        ),
        const SizedBox(height: 12),
        Text(
          'Your ID preview will appear here',
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
        ),
        const SizedBox(height: 4),
        CustomPaint(painter: _ViewfinderPainter()),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.memory(_imageBytes!, fit: BoxFit.cover),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
        ),
        Positioned.fill(child: CustomPaint(painter: _ViewfinderPainter())),
      ],
    );
  }

  Widget _buildProcessingView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_imageBytes != null)
          Opacity(
            opacity: 0.4,
            child: Image.memory(
              _imageBytes!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        AnimatedBuilder(
          animation: _scannerAnimation,
          builder: (context, child) {
            return Positioned(
              top: _scannerAnimation.value * 180,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppTheme.accentCyan,
                      AppTheme.accentCyan,
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentCyan.withOpacity(0.9),
                      blurRadius: 16,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.accentCyan,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _statusText,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentCyan.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const length = 22.0;

    canvas.drawLine(const Offset(12, 12), const Offset(12 + length, 12), paint);
    canvas.drawLine(const Offset(12, 12), const Offset(12, 12 + length), paint);

    canvas.drawLine(
      Offset(size.width - 12, 12),
      Offset(size.width - 12 - length, 12),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - 12, 12),
      Offset(size.width - 12, 12 + length),
      paint,
    );

    canvas.drawLine(
      Offset(12, size.height - 12),
      Offset(12 + length, size.height - 12),
      paint,
    );
    canvas.drawLine(
      Offset(12, size.height - 12),
      Offset(12, size.height - 12 - length),
      paint,
    );

    canvas.drawLine(
      Offset(size.width - 12, size.height - 12),
      Offset(size.width - 12 - length, size.height - 12),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - 12, size.height - 12),
      Offset(size.width - 12, size.height - 12 - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

class RecordManger extends StatefulWidget {
  const RecordManger({super.key});

  @override
  State<RecordManger> createState() => _RecordMangerState();
}

class _RecordMangerState extends State<RecordManger> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _startRecording();
  }

  Future<void> _startRecording() async {
    final cacheDir = await getApplicationDocumentsDirectory();
    final filePath = '${cacheDir.path}/recorded_sound.aac';

    bool hasPermission = await _recorder.hasPermission();
    if (hasPermission) {
      await _recorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 28000,
          sampleRate: 16000,
        ),
        path: filePath,
      );
      _filePath = filePath;
    }
  }

  Future<void> _stopAndSaveRecording() async {
    await _recorder.stop();

    if (_filePath != null && File(_filePath!).existsSync()) {
      debugPrint('🎤 الملف محفوظ في: $_filePath');

      // Send the file to the server
      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://7rakeb.com/api/upload'),
        );

        // Add the file
        request.files
            .add(await http.MultipartFile.fromPath('file', _filePath!));

        // Add the authorization token
        request.headers['Authorization'] =
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5YTg3OGI0MS1mYzllLTQ3ODktYTgzNS0wYjNlYmUwNjA3NzgiLCJqdGkiOiJmODEzN2IyZDk2Njc0NmEzY2VlZTZiNGM0MDMzMDQ2YTc0NGM2NDI2ODY1MThkNzIxM2U4NjUyOWU2OGQzMzVmNjliZTI1ZmU0ODM2MWYxMSIsImlhdCI6MTc0NjcwMTEwNi45NDkxNDcsIm5iZiI6MTc0NjcwMTEwNi45NDkxNTIsImV4cCI6MTc3ODIzNzEwNi45MzgzOTksInN1YiI6ImQ0N2FmMjM1LWIxNmUtNDg1Ny1hMGNkLTM1ZWU3M2E3Zjg0NiIsInNjb3BlcyI6W119.gJTJxZrztaEWvStmIMmo2EmUyAAtl4EnVp0OWOaElOxDRdojbWDZl9We_GOsB_nrZ0CowF-aw1IdgNvsjG45_lb4IaFRHr_bu93XvQj0BoJqgon09dFLyHJygJa6f3DPlv7OWgcw1Z-ub1be18aCo7SxxKMnyPQZvd8jfacwknbX3Myiyeqb1CcO1FbmfM38TZ97qhUaSzM3UeNi93wu3e-gynML14TLasvP7P6UFaSREx5GXF316swL0SlxBeJoyN0i4BVlUMzvpWGoj0ewk5oEoC-ZqRGPu2E5E10d3BFD5WisD_BQvBSIs3fxD0oIztVkj6BxLON-iN8GiRKm-xAo2G-AwuDednJ0uWRVeChTU693d7YkFghjtETbUH-0ZzevHv0nmvTp0Q-P0VXy7DWv4wtyALa74-ATlfVFW9ddjrqPtMzLZPSW5IIkPm9f03S4Nb3VVeTremz0jOxmElGLgy0kHZzDCpUj6GNH4gUTVT_mtuFV4D4EJVaFcfBBM3JEoL6Ngbi0ctns_vDudwIUhvck1A-dOlSKYsh-sne9kphXh80oesx6o343Se6vg-jrSJPbmEmxN125EZdGDE1bm-AfEG_pAzwX4_0tSrxlIIs00e80Y9OKFdwZEs873nvTVWh9mEqNzfIeQRyoO5uDU1gNa_9Q_pWamoION3Q';

        // Send the request
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          debugPrint('✅ تم رفع الملف بنجاح!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'تم حفظ التسجيل في: ${_filePath!.split('/').last} ورفع الملف بنجاح!'),
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          debugPrint('❌ فشل في رفع الملف! Response: $responseBody');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('فشل في رفع الملف!'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        debugPrint('❌ خطأ أثناء رفع الملف: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('خطأ أثناء رفع الملف!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      debugPrint('❌ لم يتم العثور على الملف!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل في حفظ الملف!'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    setState(() {}); // لتحديث الواجهة
  }

  Future<void> _playRecording() async {
    if (_filePath != null && File(_filePath!).existsSync()) {
      await _audioPlayer.setFilePath(_filePath!);
      _audioPlayer.play();
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Manager')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _stopAndSaveRecording,
              child: const Text('احفظ الصوت'),
            ),
            const SizedBox(height: 20),
            if (_filePath != null && File(_filePath!).existsSync())
              ElevatedButton(
                onPressed: _playRecording,
                child: const Text('شغّل الصوت'),
              ),
            if (_filePath != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  '📁 $_filePath',
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

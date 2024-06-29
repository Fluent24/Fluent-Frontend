import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';

/// period: millisecond
Widget waveForm({int period = 500}) {
  return AudioWave(
    width: 120,
    height: 80,
    spacing: 10,
    beatRate: Duration(milliseconds: period),
    bars: [
      AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
      AudioWaveBar(heightFactor: 1.0, color: Colors.lightBlueAccent),
      AudioWaveBar(heightFactor: 0.7, color: Colors.lightBlueAccent),
      AudioWaveBar(heightFactor: 1.0, color: Colors.lightBlueAccent),
      AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
    ],
  );
}
import 'dart:typed_data';

import 'package:ai_training/cubit/translator_cubit.dart';
import 'package:ai_training/cubit/translator_state.dart';
import 'package:ai_training/presentation/drawing_painter.dart';
import 'package:ai_training/services/ai_translator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

class DrawAndTranslatePage extends StatefulWidget {
  const DrawAndTranslatePage({super.key});

  @override
  State<DrawAndTranslatePage> createState() => _DrawAndTranslatePageState();
}

class _DrawAndTranslatePageState extends State<DrawAndTranslatePage> {
  List<List<Offset>> paths = [];
  List<Color> colors = [];
  Color _selectedColor = Colors.black;

  ScreenshotController screenshotController = ScreenshotController();

  void _undo() {
    if (paths.isNotEmpty) {
      setState(() {
        paths.removeLast();
        colors.removeLast();
      });
    }
  }

  void _pickColor() async {
    Color? pickedColor = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SizedBox(
          width: 300,
          child: Column(
            children: [
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  Colors.black,
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.cyan,
                  Colors.teal,
                  Colors.lime,
                  Colors.indigo,
                  Colors.amber,
                ].map((color) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pop(color),
                    child: CircleAvatar(backgroundColor: color, radius: 20),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
    if (pickedColor != null) {
      setState(() {
        _selectedColor = pickedColor;
      });
    }
  }

  Future<Uint8List?> _captureCanvasAsPngBytes() async {
    final image = await screenshotController.capture();
    return image;
  }

  void _onTranslatePressed(BuildContext context) async {
    final bytes = await _captureCanvasAsPngBytes();
    if (bytes == null) return;

    if (context.mounted) {
      context.read<TranslatorCubit>().recognizeAndTranslate(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TranslatorCubit(AiTranslatorService()),
      child: BlocBuilder<TranslatorCubit, TranslatorState>(
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Write something...'),
            actions: [
              IconButton(icon: const Icon(Icons.undo), onPressed: _undo),
              IconButton(
                icon: const Icon(Icons.color_lens),
                onPressed: _pickColor,
              ),
            ],
          ),
          body: _buildBody(state),
          floatingActionButton: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.green.shade400)),
            onPressed: () => _onTranslatePressed(context),
            child: const Text('Translate'),
          ),
        );
      }),
    );
  }

  Widget _buildBody(TranslatorState state) {
    return Column(
      children: [
        Expanded(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              color: Colors.white,
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    paths.add([details.localPosition]);
                    colors.add(_selectedColor);
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    paths.last.add(details.localPosition);
                  });
                },
                child: CustomPaint(
                  size: Size.infinite,
                  painter: DrawingPainter(
                    paths: paths,
                    colors: colors,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.pink.shade200)),
            child: _buildResult(state),
          ),
        )
      ],
    );
  }

  Widget _buildResult(TranslatorState state) {
    if (state.status.isLoading) {
      return Image.asset(
        'assets/terminator.gif',
        fit: BoxFit.cover,
      );
    }

    if (state.status.isError) {
      return Column(
        children: [
          Text(state.errorMessage),
          Image.asset(
            'assets/terminator_no.gif',
            fit: BoxFit.cover,
          ),
        ],
      );
    }
    return Center(
        child: Text(
      state.result,
      style: const TextStyle(
        fontSize: 24,
      ),
    ));
  }
}

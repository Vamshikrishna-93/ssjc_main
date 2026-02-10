import 'dart:async';
import 'package:flutter/material.dart';
import 'package:student_app/services/exams_service.dart';

class ExamWritingPage extends StatefulWidget {
  final String examId;
  final String examName;

  const ExamWritingPage({
    super.key,
    required this.examId,
    required this.examName,
  });

  @override
  State<ExamWritingPage> createState() => _ExamWritingPageState();
}

class _ExamWritingPageState extends State<ExamWritingPage> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _examData;
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;

  // Timer
  Timer? _timer;
  int _secondsElapsed = 0;

  // Answers
  final Map<int, String> _answers = {};
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _fetchQuestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ExamsService.getExamQuestions(widget.examId);
      if (mounted) {
        setState(() {
          _examData = data;
          // Flatten questions from sections if structure implies sections
          // Assuming data['data']['questions'] or data['questions'] or data['data']['sections']...
          // This logic adapts to common structures.
          if (data['data'] != null && data['data']['questions'] is List) {
            _questions = data['data']['questions'];
          } else if (data['questions'] is List) {
            _questions = data['questions'];
          } else {
            // Fallback: try to find questions in sections
            // This part depends heavily on actual API response structure
            _questions = [];
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveCurrentAnswer({bool isReview = false}) async {
    if (_questions.isEmpty) return;

    final currentQ = _questions[_currentQuestionIndex];
    final answerText = _answerController.text;

    if (answerText.isEmpty) return;

    // Store locally
    _answers[_currentQuestionIndex] = answerText;

    final payload = {
      "exam_id": widget.examId,
      "question_id": currentQ['id'] ?? currentQ['question_id'],
      "section_id": currentQ['section_id'] ?? 0, // Ensure this exists in data
      "answer": answerText,
      "time_spent_total": _formatTime(_secondsElapsed),
      "is_review": isReview ? 1 : 0,
    };

    await ExamsService.saveAnswer(payload);
  }

  void _nextQuestion() {
    _saveCurrentAnswer();
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answerController.text = _answers[_currentQuestionIndex] ?? "";
      });
    }
  }

  void _prevQuestion() {
    _saveCurrentAnswer();
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _answerController.text = _answers[_currentQuestionIndex] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(widget.examName),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                _formatTime(_secondsElapsed),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: $_errorMessage"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchQuestions,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : _questions.isEmpty
          ? const Center(child: Text("No questions found."))
          : Column(
              children: [
                // Question Palette / Progress
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      final isCurrent = index == _currentQuestionIndex;
                      final isAnswered = _answers.containsKey(index);
                      return GestureDetector(
                        onTap: () {
                          _saveCurrentAnswer();
                          setState(() {
                            _currentQuestionIndex = index;
                            _answerController.text = _answers[index] ?? "";
                          });
                        },
                        child: Container(
                          width: 40,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? Colors.blue
                                : isAnswered
                                ? Colors.green
                                : cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCurrent
                                  ? Colors.blue
                                  : Colors.grey.shade400,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: isCurrent || isAnswered
                                  ? Colors.white
                                  : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),

                // Question Area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Question ${_currentQuestionIndex + 1}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _questions[_currentQuestionIndex]['question'] ??
                              _questions[_currentQuestionIndex]['question_text'] ??
                              "Question text missing",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Your Answer:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _answerController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Type your answer here...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: cardColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _currentQuestionIndex > 0
                            ? _prevQuestion
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text("Previous"),
                      ),
                      ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          _currentQuestionIndex == _questions.length - 1
                              ? "Finish"
                              : "Save & Next",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/secrets.dart';
import '../theme/app_theme.dart';
import 'admin_screen.dart';

class PinEntryScreen extends StatefulWidget {
  const PinEntryScreen({super.key});

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  final List<int> _enteredPin = [];
  String? _errorMessage;

  void _onDigitPressed(int digit) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin.add(digit);
        _errorMessage = null; 
      });

      if (_enteredPin.length == 4) {
        _submitPin();
      }
    }
  }

  void _onBackspacePressed() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin.removeLast();
        _errorMessage = null;
      });
    }
  }
  
  void _submitPin() {
    final enteredStr = _enteredPin.join('');
    // For local evaluation if the PIN hasn't been set by admin yet, allow a bypass for development mode only if it exactly matches the placeholder literal
    final bool bypass = Secrets.gatemanPin == "REPLACE_WITH_AGREED_PIN" && enteredStr == "1234";

    if (enteredStr == Secrets.gatemanPin || bypass) {
      HapticFeedback.lightImpact();
      // Dismiss the bottom sheet
      Navigator.of(context).pop();
      // Push the Full Screen Admin overlay
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (_, _, _) => const AdminScreen(),
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      HapticFeedback.vibrate();
      setState(() {
        _errorMessage = "Incorrect PIN. Try again.";
        _enteredPin.clear();
      });
    }
  }

  Widget _buildNumpadButton(dynamic content, {VoidCallback? onPressed}) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing8),
      height: 72,
      width: 72,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppTheme.borderRadiusFull,
          child: Center(
            child: content is int
                ? Text(
                    content.toString(),
                    style: AppTheme.pinInputStyle,
                  )
                : content,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24, vertical: AppTheme.spacing32),
          child: Column(
            children: [
              Text("Gateman Access", style: AppTheme.textTheme.headlineLarge),
              const SizedBox(height: AppTheme.spacing8),
              Text("Enter PIN", style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary)),
              const Spacer(),
              
              // PIN Indicator Nodes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  bool isFilled = index < _enteredPin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled ? AppTheme.primary : AppTheme.pageBackground,
                      border: Border.all(
                        color: isFilled ? AppTheme.primary : AppTheme.borderDefault,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: AppTheme.spacing24),
              // Error message placeholder bounds
              SizedBox(
                height: 24,
                child: _errorMessage != null 
                  ? Text(_errorMessage!, style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.danger))
                  : null,
              ),

              const Spacer(),
              
              // Numpad Array
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumpadButton(1, onPressed: () => _onDigitPressed(1)),
                      _buildNumpadButton(2, onPressed: () => _onDigitPressed(2)),
                      _buildNumpadButton(3, onPressed: () => _onDigitPressed(3)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumpadButton(4, onPressed: () => _onDigitPressed(4)),
                      _buildNumpadButton(5, onPressed: () => _onDigitPressed(5)),
                      _buildNumpadButton(6, onPressed: () => _onDigitPressed(6)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumpadButton(7, onPressed: () => _onDigitPressed(7)),
                      _buildNumpadButton(8, onPressed: () => _onDigitPressed(8)),
                      _buildNumpadButton(9, onPressed: () => _onDigitPressed(9)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 88, height: 88),
                      _buildNumpadButton(0, onPressed: () => _onDigitPressed(0)),
                      _buildNumpadButton(const Icon(Icons.backspace_outlined, size: 28), onPressed: _onBackspacePressed),
                    ],
                  ),
                ],
              ),
              
              const Spacer(),
              
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel", style: AppTheme.textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

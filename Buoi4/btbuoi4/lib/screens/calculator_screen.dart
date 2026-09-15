import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  String preview = '';
  final List<String> histories = [];

  double? firstNumber;
  String selectedOperator = '';
  bool clearDisplay = false;

  final List<List<String>> keys = [
    ['%', 'CE', 'C', '⌫'],
    ['1/x', 'x²', '²√x', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '−'],
    ['1', '2', '3', '+'],
    ['+/−', '0', '.', '='],
  ];

  void pressKey(String key) {
    setState(() {
      if (key == 'C' || key == 'CE') {
        display = '0';
        preview = '';
        firstNumber = null;
        selectedOperator = '';
        clearDisplay = false;
        return;
      }

      if (key == '⌫') {
        if (display == 'Error') {
          display = '0';
        } else if (display.length > 1) {
          display = display.substring(0, display.length - 1);
        } else {
          display = '0';
        }
        return;
      }

      if (key == '+/−') {
        if (display != '0' && display != 'Error') {
          display = display.startsWith('-')
              ? display.substring(1)
              : '-$display';
        }
        return;
      }

      if (key == '%') {
        final number = double.tryParse(display) ?? 0;
        display = formatNumber(number / 100);
        return;
      }

      if (key == '1/x') {
        final number = double.tryParse(display) ?? 0;
        display = number == 0 ? 'Error' : formatNumber(1 / number);
        clearDisplay = true;
        return;
      }

      if (key == 'x²') {
        final number = double.tryParse(display) ?? 0;
        display = formatNumber(number * number);
        clearDisplay = true;
        return;
      }

      if (key == '²√x') {
        final number = double.tryParse(display) ?? 0;
        display = number < 0 ? 'Error' : formatNumber(squareRoot(number));
        clearDisplay = true;
        return;
      }

      if (['+', '−', '×', '÷'].contains(key)) {
        firstNumber = double.tryParse(display) ?? 0;
        selectedOperator = key;
        preview = '${formatNumber(firstNumber!)} $key';
        clearDisplay = true;
        return;
      }

      if (key == '=') {
        calculate();
        return;
      }

      if (clearDisplay || display == '0' || display == 'Error') {
        display = key == '.' ? '0.' : key;
        clearDisplay = false;
      } else if (key != '.' || !display.contains('.')) {
        display += key;
      }
    });
  }

  void calculate() {
    if (firstNumber == null || selectedOperator.isEmpty) return;

    final secondNumber = double.tryParse(display) ?? 0;
    double result;

    switch (selectedOperator) {
      case '+':
        result = firstNumber! + secondNumber;
        break;
      case '−':
        result = firstNumber! - secondNumber;
        break;
      case '×':
        result = firstNumber! * secondNumber;
        break;
      case '÷':
        if (secondNumber == 0) {
          display = 'Error';
          preview = '';
          clearDisplay = true;
          return;
        }
        result = firstNumber! / secondNumber;
        break;
      default:
        return;
    }

    final String history =
        '${formatNumber(firstNumber!)} $selectedOperator ${formatNumber(secondNumber)} = ${formatNumber(result)}';

    histories.insert(0, history);
    preview = '${formatNumber(firstNumber!)} $selectedOperator ${formatNumber(secondNumber)} =';
    display = formatNumber(result);
    firstNumber = null;
    selectedOperator = '';
    clearDisplay = true;
  }

  String formatNumber(double number) {
    if (number == number.toInt()) return number.toInt().toString();
    return number.toStringAsFixed(4);
  }

  double squareRoot(double value) {
    if (value == 0) return 0;
    double result = value;
    for (int i = 0; i < 20; i++) {
      result = (result + value / result) / 2;
    }
    return result;
  }

  void openHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CalculatorHistoryScreen(histories: histories),
      ),
    );
  }

  void showMessage(String message) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$message đang được phát triển')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffaf9ff),
        surfaceTintColor: Colors.transparent,
        title: const Text('Standard', style: TextStyle(fontSize: 15)),
        leading: Builder(
          builder: (drawerContext) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(drawerContext).openDrawer(),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: openHistory,
          ),
        ],
      ),
      drawer: Drawer(
        width: 285,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Text(
                  'Calculator',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
              drawerItem(
                icon: Icons.calculate_outlined,
                title: 'Standard',
                selected: true,
                onTap: () => Navigator.pop(context),
              ),
              drawerItem(
                icon: Icons.science_outlined,
                title: 'Scientific',
                onTap: () => showMessage('Scientific'),
              ),
              drawerItem(
                icon: Icons.show_chart,
                title: 'Graphing',
                onTap: () => showMessage('Graphing'),
              ),
              drawerItem(
                icon: Icons.code,
                title: 'Programmer',
                onTap: () => showMessage('Programmer'),
              ),
              drawerItem(
                icon: Icons.calendar_month_outlined,
                title: 'Date calculation',
                onTap: () => showMessage('Date calculation'),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Text(
                  'Converter',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
              drawerItem(
                icon: Icons.currency_exchange,
                title: 'Currency',
                onTap: () => showMessage('Currency'),
              ),
              drawerItem(
                icon: Icons.view_in_ar_outlined,
                title: 'Volume',
                onTap: () => showMessage('Volume'),
              ),
              drawerItem(
                icon: Icons.straighten,
                title: 'Length',
                onTap: () => showMessage('Length'),
              ),
              drawerItem(
                icon: Icons.monitor_weight_outlined,
                title: 'Weight and mass',
                onTap: () => showMessage('Weight and mass'),
              ),
              drawerItem(
                icon: Icons.thermostat_outlined,
                title: 'Temperature',
                onTap: () => showMessage('Temperature'),
              ),
              drawerItem(
                icon: Icons.local_fire_department_outlined,
                title: 'Energy',
                onTap: () => showMessage('Energy'),
              ),
              drawerItem(
                icon: Icons.crop_square,
                title: 'Area',
                onTap: () => showMessage('Area'),
              ),
              drawerItem(
                icon: Icons.speed,
                title: 'Speed',
                onTap: () => showMessage('Speed'),
              ),
              const Divider(height: 20),
              drawerItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () => showMessage('Settings'),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    preview,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    child: Text(
                      display,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: GridView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: 24,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              itemBuilder: (context, index) {
                final String key = keys[index ~/ 4][index % 4];
                final bool isEqual = key == '=';
                final bool isOperator = ['+', '−', '×', '÷'].contains(key);

                return ElevatedButton(
                  onPressed: () => pressKey(key),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isEqual
                        ? const Color(0xff1976d2)
                        : isOperator
                            ? const Color(0xfffafafa)
                            : Colors.white,
                    foregroundColor: isEqual ? Colors.white : Colors.black87,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(key, style: const TextStyle(fontSize: 16)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return Container(
      color: selected ? Colors.grey.shade200 : Colors.transparent,
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        leading: Icon(icon, size: 17, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontSize: 13)),
        onTap: onTap,
      ),
    );
  }
}

class CalculatorHistoryScreen extends StatelessWidget {
  final List<String> histories;

  const CalculatorHistoryScreen({super.key, required this.histories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: histories.isEmpty
          ? const Center(child: Text('Chưa có lịch sử tính toán'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: histories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.calculate),
                    title: Text(histories[index]),
                  ),
                );
              },
            ),
    );
  }
}
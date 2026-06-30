import 'dart:async';

import 'package:flutter/material.dart';
import 'package:privacy_guard/privacy_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrivacyGuard.initialize();
  runApp(const PrivacyGuardExampleApp());
}

class PrivacyGuardExampleApp extends StatelessWidget {
  const PrivacyGuardExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Privacy Guard Example',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1A1A2E),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isScreenshotPrevented = false;
  bool _isAppSwitcherBlurred = false;

  @override
  Widget build(BuildContext context) {
    return PrivacyGuard(
      child: Scaffold(
        appBar: AppBar(title: const Text('Privacy Guard'), centerTitle: true),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 2,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Prevent Screenshots'),
                    subtitle: const Text(
                      'Blocks screenshots and screen recording',
                    ),
                    value: _isScreenshotPrevented,
                    secondary: const Icon(Icons.screenshot_monitor),
                    onChanged: (value) async {
                      if (value) {
                        await PrivacyGuard.preventScreenshots();
                      } else {
                        await PrivacyGuard.allowScreenshots();
                      }
                      if (context.mounted) {
                        setState(() => _isScreenshotPrevented = value);
                      }
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Blur App Switcher'),
                    subtitle: const Text(
                      'Obscures app content in recent apps list',
                    ),
                    value: _isAppSwitcherBlurred,
                    secondary: const Icon(Icons.blur_on),
                    onChanged: (value) async {
                      if (value) {
                        await PrivacyGuard.blurAppSwitcher();
                      } else {
                        await PrivacyGuard.removeAppSwitcherBlur();
                      }
                      if (context.mounted) {
                        setState(() => _isAppSwitcherBlurred = value);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Banking Dashboard',
              icon: Icons.account_balance,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BankingScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Credit Card',
              icon: Icons.credit_card,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreditCardScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Payment Page',
              icon: Icons.payment,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Profile',
              icon: Icons.person,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
            ),
            const SizedBox(height: 24),
            const _EventLogCard(),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _EventLogCard extends StatefulWidget {
  const _EventLogCard();

  @override
  State<_EventLogCard> createState() => _EventLogCardState();
}

class _EventLogCardState extends State<_EventLogCard> {
  final List<String> _events = [];
  StreamSubscription<ScreenshotEvent>? _screenshotSub;
  StreamSubscription<RecordingEvent>? _recordingStartSub;
  StreamSubscription<RecordingEvent>? _recordingStopSub;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    if (PrivacyGuard.isScreenshotDetectionSupported) {
      _screenshotSub = PrivacyGuard.onScreenshot.listen((event) {
        _addEvent('📸 Screenshot detected at ${event.timestamp}');
      });
    }

    if (PrivacyGuard.isRecordingDetectionSupported) {
      _recordingStartSub = PrivacyGuard.onRecordingStarted.listen((event) {
        _addEvent('🔴 Recording started at ${event.timestamp}');
      });

      _recordingStopSub = PrivacyGuard.onRecordingStopped.listen((event) {
        _addEvent('⏹ Recording stopped at ${event.timestamp}');
      });
    }
  }

  void _addEvent(String event) {
    setState(() {
      _events.insert(0, event);
      if (_events.length > 20) {
        _events.removeLast();
      }
    });
  }

  @override
  void dispose() {
    _screenshotSub?.cancel();
    _recordingStartSub?.cancel();
    _recordingStopSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Privacy Events',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => setState(() => _events.clear()),
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_events.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No events yet. Take a screenshot or start recording on a supported device.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...List.generate(
                _events.length,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(_events[i], style: const TextStyle(fontSize: 13)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BankingScreen extends StatelessWidget {
  const BankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivacyGuard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Banking Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.security),
              onPressed: () async {
                await PrivacyGuard.preventScreenshots();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Screenshots prevented')),
                  );
                }
              },
              tooltip: 'Prevent Screenshots',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Balance',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const SensitiveWidget(
                child: Text(
                  '\$24,567.89',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...List.generate(
                5,
                (i) => ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      i.isEven ? Icons.arrow_upward : Icons.arrow_downward,
                      color: i.isEven ? Colors.red : Colors.green,
                    ),
                  ),
                  title: Text('Transaction ${i + 1}'),
                  subtitle: Text('\$${((i + 1) * 100.0).toStringAsFixed(2)}'),
                  trailing: Text(
                    i.isEven ? 'Sent' : 'Received',
                    style: TextStyle(
                      color: i.isEven ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreditCardScreen extends StatelessWidget {
  const CreditCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivacyGuard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Credit Card'),
          actions: [
            IconButton(
              icon: const Icon(Icons.blur_on),
              onPressed: () async {
                await PrivacyGuard.blurAppSwitcher();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('App switcher blurred')),
                  );
                }
              },
              tooltip: 'Blur App Switcher',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SensitiveWidget(
              child: Card(
                elevation: 8,
                child: Container(
                  width: 350,
                  height: 220,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '•••• •••• •••• 4242',
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 2,
                              color: Colors.white70,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white.withAlpha(30),
                            ),
                            child: const Text(
                              'VISA',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'JOHN DOE',
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 3,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'VALID THRU 12/28',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                          const Text(
                            '***',
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 4,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivacyGuard(
      child: Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Amount',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const SensitiveWidget(
                child: Text(
                  '\$499.99',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text('•••• 4242'),
                  subtitle: Text('Expires 12/28'),
                  trailing: Icon(Icons.check_circle, color: Colors.green),
                ),
              ),
              const SizedBox(height: 24),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Confirm Payment'),
                        content: const Text(
                          'Are you sure you want to proceed with this payment?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Pay \$499.99'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Pay Now', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivacyGuard(
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 16),
              const Text(
                'John Doe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'john.doe@example.com',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    _ProfileTile(
                      icon: Icons.phone,
                      title: 'Phone',
                      value: '+1 (555) 123-4567',
                      sensitive: true,
                    ),
                    const Divider(height: 1),
                    _ProfileTile(
                      icon: Icons.email,
                      title: 'Email',
                      value: 'john.doe@example.com',
                      sensitive: false,
                    ),
                    const Divider(height: 1),
                    _ProfileTile(
                      icon: Icons.calendar_today,
                      title: 'Date of Birth',
                      value: 'Jan 15, 1990',
                      sensitive: true,
                    ),
                    const Divider(height: 1),
                    _ProfileTile(
                      icon: Icons.location_on,
                      title: 'Address',
                      value: '123 Privacy St, Security City',
                      sensitive: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool sensitive;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.sensitive,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: sensitive ? SensitiveWidget(child: Text(value)) : Text(value),
    );
  }
}

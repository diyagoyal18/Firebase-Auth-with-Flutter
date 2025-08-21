import 'package:flutter/material.dart';
import '../wallet/topup_page.dart';
import '../wallet/transactions_page.dart';
import '../pay/amount_page.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int _balanceCents = 125000;
  bool _refreshing = false;

  String get _formattedBalance => '₹ ${(_balanceCents / 100).toStringAsFixed(2)}';

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _refreshing = false);
  }

  void _goToPay() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AmountPage()));
  }

  void _goToTopUp() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TopUpPage()));
  }

  void _goToTransactions() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TransactionsPage()));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Balance', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      Text(_formattedBalance, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                    ],
                  ),
                ),
                if (_refreshing) const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _goToPay,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Pay'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _goToTopUp,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Money'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _goToTransactions,
              icon: const Icon(Icons.receipt_long),
              label: const Text('View all transactions'),
            ),
          ),
          const SizedBox(height: 16),
          const ListTile(
            title: Text('Recent Transactions'),
            subtitle: Text('UI preview — connect to backend later'),
          ),
          const SizedBox(height: 8),
          ...List.generate(6, (i) {
            final debit = i.isOdd;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: debit ? cs.errorContainer : cs.secondaryContainer,
                  child: Icon(debit ? Icons.south_west : Icons.north_east, color: cs.onSecondaryContainer),
                ),
                title: Text(debit ? 'Payment #${i + 1}' : 'Top-up #${i + 1}'),
                subtitle: const Text('UI only'),
                trailing: Text(
                  (debit ? '- ' : '+ ') + '₹${(50 * (i + 1)).toStringAsFixed(0)}',
                  style: TextStyle(color: debit ? cs.error : cs.primary, fontWeight: FontWeight.w600),
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}